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
  include epel

  # Firewall defaults
  Firewall {
    before  => Class['security::firewall_post'],
    require => Class['security::firewall_pre'],
  }

  class {'monitoring':
    monitor_ip => '128.250.120.34'
  }

  # Bare-bones apache install
  class {'apache':
    default_vhost => false,
  }

  # Tomcat will be the default apache vhost
  class {'tomcat':}

  # Ramadda will be at http://$fqdn/repository
  class {'ramadda':
    vhost => 'climate-cms.nci.org.au',
  }
  class {'ramadda::ldap':
    url             => 'ldap://sfldap0.anu.edu.au:389',
    user_directory  => 'uid=${id},ou=People,dc=apac,dc=edu,dc=au',
    group_directory => 'ou=Group,dc=apac,dc=edu,dc=au',
    group_attribute => 'memberUid',
    admin_group     => 'fe2_2',
  }

  # Dependencies
  package{'wget':}

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
  file {['/g','/g/data1','/g/data1/ua8']:
    ensure => directory,
  }
  package {'nfs-utils':}
  #mount {'/g/data1/ua8':
  #  ensure  => mounted,
  #  device  => 'nnfs3.nci.org.au:/mnt/gdata1/ua8',
  #  fstype  => 'nfs',
  #  options => 'ro,nolock',
  #  require => [Package['nfs-utils'],File['/g/data1/ua8']],
  #}
}
