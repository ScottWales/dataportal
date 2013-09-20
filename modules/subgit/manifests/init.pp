define subgit ($git_url = $title, $svn_url) {

    package {"subgit":}
    
    exec {"subgit configure --svn-url $svn_url $git_url":
        creates => "$git_url/subgit/config",
        require => Package["subgit"],
    }

    exec {"subgit install $git_url":
        creates => "$git_url/hooks/pre-receive",
        require => File["$git_url/subgit/config"],
    }
}
