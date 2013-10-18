## \file    modules/security/manifests/firewall_pre.pp
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

class security::firewall_pre {
  Firewall {
    before  => undef,
    require => undef,
  }

  # Defaults
  firewall {'000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  } ->
  firewall {'001 accept all loopbacks':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  } ->
  firewall {'002 accept established':
    proto  => 'all',
    state  => ['RELATED','ESTABLISHED'],
    action => 'accept',
  }
}
