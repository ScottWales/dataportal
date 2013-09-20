node default {

    class {'apache':
        default_mods => false,
    }

    package {["git", "subversion"]:}
    
    vcsrepo { "/var/git/test":
        ensure => bare,
        provider => git,
        require => Package["git"],
    }

    vcsrepo { "/var/svn/test":
        ensure => present,
        provider => svn,
        require => Package["subversion"],
    }
}
