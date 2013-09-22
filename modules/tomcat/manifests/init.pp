class tomcat {
    package {'tomcat6':}

    service {'tomcat6':
        require => Package['tomcat6'],
        ensure => running,
    }        
}
