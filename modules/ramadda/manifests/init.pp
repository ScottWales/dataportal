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

class ramadda ($home  = '/var/ramadda',
               $vhost = '*') {
    include tomcat

    $builddir = '/tmp/ramadda'
    
    File {
      owner => 'tomcat',
    }

    vcsrepo {$ramadda::builddir:
        ensure   => present,
        source   => 'svn://svn.code.sf.net/p/ramadda/code',
        revision => '3334',
        provider => svn,
        require  => Package['subversion'],
    }

    # Apply patches
    # Fix bug in login code that blocks the LDAP plugin from working
    file {"${ramadda::builddir}/login.patch":
      ensure => present,
      source => 'puppet:///modules/ramadda/login.patch'
    } ->
    exec {'Patch login':
      command => '/usr/bin/patch -p0 < login.patch',
      cwd     => $ramadda::builddir,
      require => Vcsrepo[$ramadda::builddir],
      unless  => '/usr/bin/patch --dry-run --reverse -p0 < login.patch',
    } ->

    # Fix dropdown menus in the AODN style
    file {"${ramadda::builddir}/aodn.patch":
      ensure => present,
      source => 'puppet:///modules/ramadda/aodn.patch'
    } ->
    exec {'Patch aodnStyle':
      command => '/usr/bin/patch -p0 < aodn.patch',
      cwd     => $ramadda::builddir,
      require => Vcsrepo[$ramadda::builddir],
      unless  => '/usr/bin/patch --dry-run --reverse -p0 < aodn.patch',
    } ->

    # Build from subversion
    exec {'Build Ramadda':
        command => '/usr/bin/ant',
        cwd     => $ramadda::builddir,
        require => [Vcsrepo['/tmp/ramadda'],Package['ant']],
        creates => "${ramadda::builddir}/dist/repository.war",
    }
    #    exec {'Build ldapplugin':
    #        command => '/usr/bin/ant',
    #        cwd     => "${ramadda::builddir}/src/org/ramadda/plugins/ldap",
    #        require => [Vcsrepo['/tmp/ramadda'],Package['ant']],
    #        creates => "${ramadda::builddir}/dist/plugins/ldapplugin.jar",
    #    }

    tomcat::webapp {'repository':
      war     => "${ramadda::builddir}/dist/repository.war",
      vhost   => $ramadda::vhost,
      require => [Exec['Build Ramadda'],File[$ramadda::home]],
    }

    file {$ramadda::home:
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

    file {"${ramadda::home}/plugins":
      ensure => directory,
    }

    file {"${ramadda::home}/plugins/userguideplugin.jar":
      source  => "${ramadda::builddir}/dist/plugins/userguideplugin.jar",
      require => Exec['Build Ramadda'],
    }
    file {"${ramadda::home}/plugins/threddsplugin.jar":
      source  => "${ramadda::builddir}/dist/plugins/threddsplugin.jar",
      require => Exec['Build Ramadda'],
    }
    file {"${ramadda::home}/plugins/ldapplugin.jar":
      source  => "${ramadda::builddir}/dist/otherplugins/ldapplugin.jar",
      require => Exec['Build Ramadda'],
    }
    file {"${ramadda::home}/plugins/zzzcdmdataplugin.jar":
      source  => "${ramadda::builddir}/dist/plugins/zzzcdmdataplugin.jar",
      require => Exec['Build Ramadda'],
    }

}
