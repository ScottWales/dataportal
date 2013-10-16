## \file    modules/ramadda/manifests/init.pp
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

class ramadda (
  $vhost_name = '*',
  $port = '80',
  $tomcat_home = '/var/ramadda',
) {

  $tomcat_port = '8009'

  include tomcat
  tomcat::instance {'ramadda':
    ensure           => present,
    ajp_port         => $tomcat_port,
    instance_basedir => $tomcat_home,
  }

  include apache::mod::proxy_ajp
  apache::vhost {'ramadda':
    ensure     => present,
    docroot    => '/var/www/html',
    proxy_dest => "ajp://localhost:${tomcat_port}",
  }

  $download = 'http://downloads.sourceforge.net/project/ramadda/ramadda1.5b/repository.war?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Framadda%2Ffiles%2Framadda1.5b%2F&ts=1381896458&use_mirror=aarnet'

  exec {"/usr/bin/wget -O ${tomcat_home}/webapps/repository.war ${download}":
    creates => "${tomcat_home}/instances/repository.war",
  }
}
