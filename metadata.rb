name             'tonicdns'
maintainer       'SiruS'
maintainer_email 'https://github.com/podwhitehawk'
license          'Apache 2.0'
description      'Installs/Configures tonicdns'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'

depends 'apt'
depends 'apache2'
depends 'tar'
depends 'database'
depends 'chef-pdns'

supports 'centos'
supports 'ubuntu'
supports 'debian'