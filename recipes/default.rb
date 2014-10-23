#
# Cookbook Name:: tonicdns
# Recipe:: default
#
# Copyright (C) 2014 SiruS (https://github.com/podwhitehawk)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if platform_family?("debian")
  include_recipe "apt"
end
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
include_recipe "database::mysql"

package "php_mysql" do
  package_name value_for_platform_family(
    "debian" => "php5-mysql",
    "rhel" => "php-mysql"
  )
end

owner_group = value_for_platform_family(
    "debian" => "www-data",
    "rhel" => "apache"
  )

directory node["tonicdns"]["install_dir"] do
  owner owner_group
  group owner_group
  mode 0750
  action :create
end
if node["tonicdns"]["git_install"]
  package "git" do
    action :install
  end
  git "clone_tonicdns_repository" do
    repository node["tonicdns"]["git_repo"]
    destination node["tonicdns"]["install_dir"]
    action :checkout
  end
else
  cookbook_file node["tonicdns"]["package_name"] do
    path "/tmp/#{node["tonicdns"]["package_name"]}"
    action :create_if_missing
  end
  tar_extract "/tmp/#{node["tonicdns"]["package_name"]}" do
    action :extract_local
    target_dir node["tonicdns"]["install_dir"]
    creates "#{node["tonicdns"]["install_dir"]}/conf/database.conf.php.default"
    tar_flags [ '--strip-components 1' ]
  end
end

%w{logging validator}.each do |conf|
  remote_file "copy #{conf}.conf.php" do 
    path "#{node["tonicdns"]["install_dir"]}/conf/#{conf}.conf.php" 
    source "file://#{node["tonicdns"]["install_dir"]}/conf/#{conf}.conf.php.default"
  end
end

template "#{node["tonicdns"]["install_dir"]}/conf/database.conf.php" do
  source "database.conf.php.erb"
  variables("token" => rand(36**64).to_s(36))
  action :create_if_missing
end

# setup mysql connection
mysql_connection_info = {
  :host => node["tonicdns"]["hostname"],
  :username => node["tonicdns"]["username"],
  :password => node["tonicdns"]["password"]
}

# import from a dump file
mysql_database "tonicdns_import_sql_dump" do
  connection mysql_connection_info
  database_name node["tonicdns"]["dbname"]
  sql { ::File.open("#{node["tonicdns"]["install_dir"]}/db/tables.sql").read }
  not_if {File.exists?("/etc/.tonicdns_sql.imported")}
  action :query
end

mysql_database "alter_users_table" do
  connection mysql_connection_info
  database_name node["tonicdns"]["dbname"]
  sql "ALTER TABLE users ADD use_ldap BOOLEAN NOT NULL;"
  not_if {File.exists?("/etc/.poweradmin_sql.imported")}
  not_if {File.exists?("/etc/.tonicdns_sql.imported")}
  action :query
end

#marker for sql import
file "/etc/.tonicdns_sql.imported"

# add user
mysql_database "add_tonicdns_user" do
  connection mysql_connection_info
  database_name node["tonicdns"]["dbname"]
  sql "INSERT IGNORE INTO users VALUES (NULL, '#{node["tonicdns"]["user"]}', '#{getMD5pass?}','TonicDNS user','#{node["tonicdns"]["user_email"]}','tonicdns api user',0,0,0);"
  action :query
end

web_app "tonicdns" do
  cookbook 'apache2'
  server_name node['hostname']
  docroot "#{node["tonicdns"]["install_dir"]}/docroot"
  server_port node["tonicdns"]["http_port"]
  allow_override 'All'
  directory_options '+FollowSymLinks'
end
