## \file    manifests/site.pp
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

node default {

  include ssh
  include security
  include sudo
  include nagios

  class {'apache':
    default_mods  => false,
    default_vhost => false,
  }

  # Create a default user
  user {'ec2-user':
    ensure     => present,
    managehome => true,
    home       => '/home/ec2-user',
  } ->
  file {'/home/ec2-user/.ssh':
    ensure => directory,
  } ->
  file {'/home/ec2-user/.ssh/authorized_keys':
    ensure  => present,
    content => $::ec2_public_keys_0_openssh_key,
  }
  
  sudo::conf {'ec2-user':
    content => "ec2-user ALL=(ALL) NOPASSWD: ALL\n",
    require => User['ec2-user'],
  }
}

