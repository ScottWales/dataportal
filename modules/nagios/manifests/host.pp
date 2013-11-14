## \file    manifests/host.pp
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

# A nagios host

define nagios::host(
  $hostname = $title,
  $alias    = $title,
  $address  = $title,
  $template = 'linux-server',
) {

  $configfile = "/etc/nagios/objects/${title}.cfg"
  $module_path = get_module_path('nagios')

  file {$configfile:
    ensure => present,
  } ->

  augeas {"host ${title}":
    context   => "/files${configfile}",
    changes   => [
      "set host[host_name = \"${hostname}\"]/host_name ${hostname}",
      "set host[host_name = \"${hostname}\"]/use ${template}",
      "set host[host_name = \"${hostname}\"]/alias ${alias}",
      "set host[host_name = \"${hostname}\"]/address ${address}",
    ],
    load_path => "${module_path}/lib/augeas/lenses",
  }

}

