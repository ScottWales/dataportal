class tomcat ($vhost_name = '*', $port = '80') {
    require java

    package {'tomcat6':}

    service {'tomcat6':
        require => Package['tomcat6'],
        ensure => running,
    }        

    # Get apache to forward connections to tomcat
    class {'apache::mod::proxy_http':}
    apache::vhost {'tomcat':
        vhost_name => $vhost_name,
        port => $port, 
        docroot => '/var/www/tomcat',
        proxy_pass => [{'path'=>'/repository','url'=>'http://localhost:8080/repository'}],
    }
}
