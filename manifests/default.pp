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


hiera_include('classes')

node default {
  #  $heira_classes = hiera_array('classes')
  #  class {$heira_classes:}
  include nci

  $yum_packages = hiera_array('packages',[])
  if size($yum_packages) > 0 {
    package {$yum_packages:}
  }

  $pip_packages = hiera_array('python-packages',[])
  if size($pip_packages) > 0 {
    python::package {$pip_packages:}
  }

  if $::openstack_meta_site == 'NCI' {
    # NFS mounts
    $gdata_mounts = hiera_array('gdata-mounts',[])
    if size($gdata_mounts) > 0 {
      nci::gdata {$gdata_mounts:}
    }
  }

  #  include ssh
  #  include security
  #  include sudo
  #  include ec2user
  #  include epel
  #
  #  mailalias {'forward root mail':
  #    name      => 'root',
  #    recipient => 'scott.wales@unimelb.edu.au',
  #  }
  #
  #  # Firewall defaults
  #  Firewall {
  #    before  => Class['security::firewall_post'],
  #    require => Class['security::firewall_pre'],
  #  }
  #
  #  class {'monitoring':
  #    monitor_ip => '128.250.120.34'
  #  }
  #
  #  # Bare-bones apache install
  #  class {'apache':
  #    default_vhost => false,
  #    default_mods  => false,
  #  }
  #
  #  # Tomcat will be the default apache vhost
  #  class {'tomcat':}
  #
  #  # Ramadda will be at http://$fqdn/repository
  #  class {'ramadda':
  #    vhost => 'climate-cms.nci.org.au',
  #  }
  #  class {'ramadda::ldap':
  #    url             => 'ldap://sfldap0.anu.edu.au:389',
  #    user_directory  => 'uid=${id},ou=People,dc=apac,dc=edu,dc=au',
  #    group_directory => 'ou=Group,dc=apac,dc=edu,dc=au',
  #    group_attribute => 'memberUid',
  #    admin_group     => 'fe2_2',
  #  }
  #
  #  # Dependencies
  #  package{'wget':}
  #
  #  # Database
  #  class {'postgresql::server':
  #    postgres_password => 'test',
  #  }
  #
  }
