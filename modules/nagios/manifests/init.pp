## \file    modules/nagios/manifests/init.pp
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
#

# Setup a Nagios server
class nagios (
  $vhost_name = '*',
  $port     = '80'
) {
  require epel
  require apache

  include apache::mod::mime
  include apache::mod::dir
  include apache::mod::php
  include apache::mod::cgi
  include apache::mod::auth_basic
  apache::mod{'authn_file':}
  apache::mod{'authz_user':}

  package {'nagios':
    # Apache will delete the config files, install nagios first so the build is
    # stable
    before => Class['apache'],
  } ->
  service {'nagios':
    ensure => running,
  }

  file {'/etc/nagios/htpasswd':
    owner  => 'apache',
    source => 'puppet:///modules/nagios/htpasswd',
  }

  # Puppet says it loads lenses in lib/augeas/lenses, but it doesn't
  $module_path = get_module_path('nagios')

  augeas {'base url':
    context   => '/files/etc/nagios/cgi.cfg',
    changes   => 'set url_html_path /',
    require   => Package['nagios'],
    load_path => "${module_path}/lib/augeas/lenses",
  }

  apache::vhost {'nagios':
    vhost_name       => $vhost_name,
    port             => $port,
    docroot          => '/usr/share/nagios/html',
    scriptalias      => '/usr/lib64/nagios/cgi-bin',
    redirect_source  => '/nagios/cgi-bin',
    redirect_dest    => '/cgi-bin',
    directories      => [
      {path          => '/usr/share/nagios/html',
      auth_require   => 'valid-user',
      auth_type      => 'Basic',
      auth_name      => 'Nagios',
      auth_user_file => '/etc/nagios/htpasswd'},
      {path          => '/usr/lib64/nagios/cgi-bin',
      auth_require   => 'valid-user',
      auth_type      => 'Basic',
      auth_name      => 'Nagios',
      auth_user_file => '/etc/nagios/htpasswd'},
    ],
  }

  nagios::plugin{['ssh','ping','http','disk','users','swap','load','procs']:}
}
