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

class tomcat ($vhost_name = '*') {
  require java
  include apache::mod::proxy
  include apache::mod::proxy_ajp

  $home = '/usr/share/tomcat6'
  $user = 'tomcat'
  $service = 'tomcat6'

  # Manually set tomcat's UID and GID so that it can see the NFS mount
  group {'ua8':
    ensure => present,
    gid    => 5972,
  }
  group {'tomcat':
    ensure => present,
  }
  user {$user:
    ensure  => present,
    gid     => 'ua8',
    uid     => '5424',
    system  => true,
    groups  => 'tomcat',
    require => Group['ua8','tomcat'],
  }

  package {'tomcat6':}

  service {$service:
    ensure  => running,
    require => Package['tomcat6'],
  }

}
