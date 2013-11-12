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

class ramadda {
    include tomcat

    vcsrepo {'/tmp/ramadda':
        source => 'svn://svn.code.sf.net/p/ramadda/code',
        ensure => present,
        provider => svn,
    }

    # Build from subversion
    exec {'ant':
        command => '/usr/bin/ant',
        cwd => '/tmp/ramadda',
        require => [Vcsrepo['/tmp/ramadda'],Package['ant']],
        creates => '/tmp/ramadda/dist/repository.war',
    }

    # Install
    file {'/var/lib/tomcat6/webapps/repository.war':
        require => Exec['ant'],
        source => '/tmp/ramadda/dist/repository.war',
        require => Class['tomcat']
        notify => Service['tomcat6'],
    }

    # Home directory
    file {'/usr/share/tomcat6/.ramadda':
        ensure => directory,
        owner => 'tomcat',
        group => 'tomcat',
        require => Class['tomcat']
    }
}
