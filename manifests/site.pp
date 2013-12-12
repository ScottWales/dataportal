# Copyright 2013 ARC CoE for Climate System Science
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


node default {
  include ssh
  include security
  include sudo
  include ec2user

  # Firewall defaults
  Firewall {
    before => Class['security::firewall_pre'],
    require  => Class['security::firewall_post'],
  }

  # Bare-bones apache install
  class {'apache':
    default_vhost => false,
  }

  # Tomcat will be the default apache vhost
  class {'tomcat':}

  # Ramadda will be at http://$fqdn/repository
  class {'ramadda':}

  # Dependencies
  package {'subversion':}
  package {'ant':}

  # Floating IPs
  host {'production':
    ip => '130.56.244.112',
  }
  host {'test':
    ip => '130.56.244.113',
  }

  # Database
  class {'postgresql::server':
    postgres_password => 'test',
	}

  # NFS mounts
  file {['/g','/g/data1']:
    ensure => directory,
  }
  mount {'/g/data1/ua8':
    ensure  => mounted,
    device  => 'nnfs3.nci.org.au:/mnt/gdata1/ua8',
    options => 'ro,nolock',
  }
}
