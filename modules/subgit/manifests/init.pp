define subgit ($git_url = $title, $svn_url) {

    $subgit_path = "/usr/local/subgit-2.0.0/bin"

    exec {"wget http://subgit.com/download/subgit-2.0.0.zip -O - | unzip":
        cwd => "/usr/local",
        creates => "$subgit_path",
    }

    exec {"$subgit_path/subgit configure --svn-url $svn_url $git_url":
        creates => "$git_url/subgit/config",
        require => [File["$subgit_path"],Class["java"]],
    }

    exec {"$subgit_path/subgit install $git_url":
        creates => "$git_url/hooks/pre-receive",
        require => File["$git_url/subgit/config"],
    }
}
