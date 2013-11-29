## \file    modules/tomcat/manifests/webapp.pp
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  \brief
#
#  Copyright 2013 Scott Wales
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# Install a war file & setup an apache vhost for it

define tomcat::webapp(
  $war,
  $vhost = '*',
) {

  # Install the war
  file {"${tomcat::home}/webapps/${title}.war":
    source => $war,
    notify => Service['tomcat6'],
  }

  # Get apache to forward connections to tomcat
  apache::vhost {"tomcat-${title}":
    vhost_name      => $vhost,
    port            => 443,
    ssl             => true,
    docroot         => '/var/www/tomcat',
    proxy_pass      => [{
      'path' => "/${title}",
      'url'  => "http://localhost:8080/${title}"
    }],
    # Redirect the base URL to the war directory
    custom_fragment => "RedirectMatch 302 ^/$ /${title}",
  }

  # Redirect http connections to https
  apache::vhost {"tomcat-redirect-${title}":
    vhost_name      => $vhost,
    port            => 80,
    docroot         => '/var/www/tomcat',
    redirect_status => 'permanent',
    redirect_dest   => 'https://130.56.244.112/',
  }
}
