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

# Install Ramadda

class ramadda  ($home  = '/var/ramadda',
                $vhost = '*') {
    include tomcat
    $plugins = "${home}/plugins"

    File {
      owner => 'tomcat',
    }

    exec {'wget repository.war':
      command => 'wget https://github.com/ScottWales/ramadda/releases/download/portal-v1.5.1/repository.war -O /tmp/repository.war',
      path    => '/usr/bin',
      creates => '/tmp/repository.war',
      require => Package['wget'],
    }

    tomcat::webapp {'repository':
      war     => '/tmp/repository.war',
      vhost   => $ramadda::vhost,
      require => [Exec['wget repository.war'],File[$ramadda::home]],
    }

    file {$ramadda::home:
      ensure => directory,
    }
    file {$ramadda::plugins:
      ensure => directory,
    }

    # Configuration
    file {"${tomcat::home}/conf/repository.properties":
        ensure  => present,
        content => "ramadda_home=${ramadda::home}",
        require => Package['tomcat6'],
        notify  => Service['tomcat6'],
    }

    # Setup postgres
    $postgres_db = 'ramadda'
    $postgres_user = 'ramadda'
    $postgres_passwd = 'TODO:changeme'

    postgresql::server::db {$postgres_db:
      user     => $postgres_user,
      password => postgresql_password($postgres_user,$postgres_passwd),
    }

    file {"${ramadda::home}/db.properties":
      ensure  => present,
      mode    => '0500',
      content => template('ramadda/db.properties.erb'),
      notify  => Service['tomcat6'],
    }
    file {"${ramadda::home}/repository.properties":
      ensure  => present,
      content => 'ramadda.html.template.default=aodnStyle',
      notify  => Service['tomcat6'],
    }
}
