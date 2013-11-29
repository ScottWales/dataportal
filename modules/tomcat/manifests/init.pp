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

class tomcat ($vhost_name = '*', $port = '80') {
  require java

  package {'tomcat6':}

  service {'tomcat6':
    ensure  => running,
    require => Package['tomcat6'],
  }

  # Get apache to forward connections to tomcat
  class {'apache::mod::proxy_http':}
  apache::vhost {'tomcat':
    vhost_name => $vhost_name,
    port       => 443,
    ssl        => true,
    docroot    => '/var/www/tomcat',
    proxy_pass => [{
      'path'=> '/repository',
      'url' => 'http://localhost:8080/repository'
    }],
	custom_fragment => 'RedirectMatch 302 ^/$ /repository',
  }
  apache::vhost {'tomcat-redirect':
    vhost_name      => $vhost_name,
    port            => 80,
    docroot         => '/var/www/tomcat',
    redirect_status => 'permanent',
    redirect_dest   => 'https://130.56.244.112/',
  }
}
