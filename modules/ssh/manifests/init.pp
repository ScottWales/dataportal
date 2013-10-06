## \file    modules/ssh/manifests/init.pp
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  \brief
#
#  Copyright 2013 Scott Wales
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

class ssh {

  package {'openssh':} ->

  file {'/etc/ssh/sshd_config':} ->

  service {'sshd':
    ensure    => running,
    subscribe => File['/etc/ssh/sshd_config'],
  }

  augeas {'Disable root login':
    context => '/files/etc/ssh/sshd_config',
    changes => 'PermitRootLogin no',
    notify  => Service['sshd'],
  }
  augeas {'Disable protocol 1':
    context => '/files/etc/ssh/sshd_config',
    changes => 'Protocol 2',
    notify  => Service['sshd'],
  }
}
