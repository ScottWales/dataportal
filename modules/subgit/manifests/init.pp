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

define subgit ($git_url = $title, $svn_url) {

    $subgit_path = "/usr/local/subgit-2.0.0/bin"

    exec {"/usr/bin/wget http://subgit.com/download/subgit-2.0.0.zip":
        cwd => "/tmp",
        creates => "/tmp/subgit-2.0.0.zip",
    }

    exec {"/usr/bin/unzip /tmp/subgit-2.0.0.zip":
        cwd => "/usr/local",
        creates => "$subgit_path",
        require => Package["unzip"],
    }

    file {"$subgit_path":
        require => Exec["/usr/bin/unzip /tmp/subgit-2.0.0.zip"],
    }

    exec {"$subgit_path/subgit configure --svn-url $svn_url $git_url":
        creates => "$git_url/subgit/config",
        require => [File["$subgit_path"],Class["java"]],
    }

    file {"$git_url/subgit/config":
        require => Exec["$subgit_path/subgit configure --svn-url $svn_url $git_url"],
    }

    exec {"$subgit_path/subgit install $git_url":
        creates => "$git_url/hooks/pre-receive",
        require => File["$git_url/subgit/config"],
    }
}
