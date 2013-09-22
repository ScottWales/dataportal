class ramadda {
    require tomcat

    vcsrepo {'/tmp/ramadda':
        source => 'svn://svn.code.sf.net/p/ramadda/code',
        provider => svn
    }

    # Build from subversion
    exec {'cd /tmp/ramadda && ant':
        require => [Vcsrepo['/tmp/ramadda'],Package['ant']],
        creates => '/tmp/ramadda/dist/repository.war',
    }

    # Install
    file {'/var/lib/tomcat6/webapps/repository.war':
        require => Exec['cd /tmp/ramadda && ant'],
        source => '/tmp/ramadda/dist/repository.war',
    }

    # Home directory
    file {'/usr/share/tomcat6/.ramadda':
        ensure => directory,
        owner => 'tomcat',
        group => 'tomcat',
    }
}
