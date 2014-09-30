# TonicDNS cookbook
[![Build Status](https://secure.travis-ci.org/podwhitehawk/tonicdns.svg?branch=master)](http://travis-ci.org/podwhitehawk/tonicdns)

This cookbook is used to install [TonicDNS](https://github.com/Cysource/TonicDNS) - a RESTful API for [PowerDNS](https://www.powerdns.com/).

## Requirements
You should have already installed PowerDNS and pdns-backend-mysql to use it without errors.

Depends on cookbooks:

- apt
- apache2
- tar
- database
- [chef-pdns](https://github.com/podwhitehawk/chef-pdns) (this one used for tests)

## Supported Platforms
Tested and runs on:

- Ubuntu 12.04
- Ubuntu 14.04
- CentOS 6.5
- Debian 7.6
- CentOS 7
- Debian 6

Should also work with other RHEL and Debian based distos, but not tested yet.

## Attributes

`node["TonicDNS"]["git_install"]` - whenever to install TonicDNS from remote or local source. Default - `true`

`node["TonicDNS"]["git_repo"]` - download URL for TonicDNS. Default - `https://github.com/Cysource/TonicDNS.git`

`node["TonicDNS"]["package_name"]` - name for local package located in files/default. Default - `tonicdns-git.tar.gz`

`node["TonicDNS"]["install_dir"]` - Docroot for apache2 where TonicDNS will be located. Default - `/var/www/TonicDNS`

`node["poweradmin"]["http_port"]` - port where TonicDNS API could be found. Default - `8080`

`node["tonicdns"]["user"]` - User that will be created to serve API requests. Default - `tonicdns`

`node["tonicdns"]["user_email"]` - email for user created to serve API requests. Default - `sampleuser@example.org`

Here is a block of mysql connection settings - it should be easy to understand what value stands for.

Should be the same, previously used to configure pdns-backend-mysql.

`node["tonicdns"]["hostname"]` = `'localhost'`

`node["tonicdns"]["username"]` = `'powerdns'`

`node["tonicdns"]["password"]` = `'p4ssw0rd'`

`node["tonicdns"]["dbname"]` = `'powerdns'`

## Usage

### tonicdns::default
Use `recipe[tonicdns::default]` to deploy TonicDNS API on your working copy of PowerDNS with mysql-backend.

### tonicdns::test
Use `recipe[tonicdns::test]` to deploy TonicDNS API alongside with test deployment of PowerDNS+mysql-backend used in this [chef-pdns](https://github.com/podwhitehawk/chef-pdns) test cookbook.

But it's not recomended to use it in such way. At least right now.


## Contributing
Your contributions is highly appreciated.
Here is standart instruction how to do so:

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors
- Author:: SiruS (https://github.com/podwhitehawk)
```text
Copyright (C) 2014 SiruS (https://github.com/podwhitehawk)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
