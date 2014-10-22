require 'spec_helper'

if ['debian', 'ubuntu'].include?(os[:family])
  describe package('apache2') do
    it { should be_installed }
  end
  describe service('apache2') do
    it { should be_enabled }
    it { should be_running }
  end
  describe package('libapache2-mod-php5') do
    it { should be_installed }
  end
  describe package('php5-mysql') do
    it { should be_installed }
  end
elsif os[:family] == 'redhat'
  describe package('httpd') do
    it { should be_installed }
  end
  describe service('httpd') do
    it { should be_enabled }
    it { should be_running }
  end
  describe package('php') do
    it { should be_installed }
  end
  describe package('php-mysql') do
    it { should be_installed }
  end
end

describe port(8080) do
  it { should be_listening }
end

if ['debian', 'ubuntu'].include?(os[:family])
  describe file('/etc/apache2/ports.conf') do
    it { should be_file }
    it { should contain 'Listen *:8080' }
  end
elsif os[:family] == 'redhat'
  describe file('/etc/httpd/ports.conf') do
    it { should be_file }
    it { should contain 'Listen *:8080' }
  end
end

# tonicdns
if ['debian', 'ubuntu'].include?(os[:family])
  describe file('/etc/apache2/sites-enabled/tonicdns.conf') do
    it { should be_file }
    it { should contain 'DocumentRoot /var/www/tonicdns/docroot' }
    it { should contain 'Options +FollowSymLinks' }
    it { should contain 'AllowOverride All' }
  end
elsif os[:family] == 'redhat'
  describe file('/etc/httpd/sites-enabled/tonicdns.conf') do
    it { should be_file }
    it { should contain 'DocumentRoot /var/www/tonicdns/docroot' }
    it { should contain 'Options +FollowSymLinks' }
    it { should contain 'AllowOverride All' }
  end
end

if ['debian', 'ubuntu'].include?(os[:family])
  describe file('/var/www/tonicdns') do
    it { should be_directory }
    it { should be_owned_by 'www-data' }
    it { should be_mode 750 }
  end
elsif os[:family] == 'redhat'
  describe file('/var/www/tonicdns') do
    it { should be_directory }
    it { should be_owned_by 'apache' }
    it { should be_mode 750 }
  end
end

describe file('/var/www/tonicdns/conf/database.conf.php') do
  it { should be_file }
  it { should_not contain 'DB_USER = ""' }
  it { should_not contain 'DB_PASS = ""' }
  it { should_not contain 'TOKEN_SECRET = ""' }
end

describe file('/var/www/tonicdns/conf/logging.conf.php') do
  it { should be_file }
end

describe file('/var/www/tonicdns/conf/validator.conf.php') do
  it { should be_file }
end
