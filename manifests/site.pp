node default {

    class {'apache':
        default_mods => false,
    }

    vcsrepo { "/var/git/test":
        ensure => bare,
        provider => git,
    }

    vcsrepo { "/var/svn/test":
        ensure => present,
        provider => svn,
    }
}
