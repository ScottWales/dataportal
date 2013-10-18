## \file    modules/security/manifests/init.pp
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

# Various security features

class security {
  include firewall
  include security::firewall_pre
  include security::firewall_post

  File {
    owner => root,
    group => root,
  }

  # Firewall defaults
  Firewall {
    before => Class['security::firewall_pre'],
    require  => Class['security::firewall_post'],
  }

  file {['/etc/passwd','/etc/group','/etc/fstab']:
    mode  => '0644',
  }
  file {'/etc/shadow':
    mode  => '0000',
  }
  file {'/root':
    mode  => '0500',
  }

  # Remove any firewall rules not defined in puppet
  resources {'firewall':
    purge => true,
  }

  firewall {'101 allow ssh':
    port   => 22,
    proto  => tcp,
    action => accept,
  }
  firewall {'102 allow http/s':
    port   => [80,443],
    proto  => tcp,
    action => accept,
  }

}
