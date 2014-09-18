default["tonicdns"]["git_install"] = true
default["tonicdns"]["git_repo"] = 'https://github.com/Cysource/TonicDNS.git'
default["tonicdns"]["package_name"] = 'tonicdns-git.tar.gz'
default["tonicdns"]["install_dir"] = '/var/www/tonicdns'
default["tonicdns"]["http_port"] = 8080

default["tonicdns"]["hostname"] = 'localhost'
default["tonicdns"]["username"] = 'powerdns'
default["tonicdns"]["password"] = 'p4ssw0rd'
default["tonicdns"]["dbname"] = 'powerdns'

default["tonicdns"]["user"] = 'tonicdns'
default["tonicdns"]["user_email"] = 'sampleuser@example.org'

default['apache']['listen_ports'] = [node["tonicdns"]["http_port"]]
