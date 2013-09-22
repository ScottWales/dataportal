class tomcat ($vhost = "*:80") {
    package {'tomcat6':}

    service {'tomcat6':
        require => Package['tomcat6'],
        ensure => running,
    }        

    # Get apache to forward connections to tomcat
    apache::vhost {$vhost:
        proxy_dest => 'http://localhost:8080/',
    }
}
