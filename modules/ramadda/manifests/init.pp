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

class ramadda ($home = '/var/ramadda') {
    include tomcat

    vcsrepo {'/tmp/ramadda':
        ensure   => present,
        source   => 'svn://svn.code.sf.net/p/ramadda/code',
        provider => svn,
        require  => Package['subversion'],
    }

    # Build from subversion
    exec {'ant':
        command => '/usr/bin/ant',
        cwd     => '/tmp/ramadda',
        require => [Vcsrepo['/tmp/ramadda'],Package['ant']],
        creates => '/tmp/ramadda/dist/repository.war',
    }

    tomcat::webapp {'ramadda':
      war     => '/tmp/ramadda/dist/repository.war',
      vhost   => '*',
      require => [Exec['ant'],File[$ramadda::home]],
    }

    file {$ramadda::home:
      ensure => directory,
      owner  => 'tomcat',
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
      owner   => tomcat,
      mode    => '0500',
      content => template('ramadda/db.properties.erb'),
      notify  => Service['tomcat6'],
    }

}
