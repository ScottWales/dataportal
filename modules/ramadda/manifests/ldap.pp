## \file    ../manifests/ldap.pp
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

class ramadda::ldap (
  $url             = 'ldap://example.com',
  $user_directory  = 'uid=${id},ou=People,dc=example,dc=com',
  $group_directory = 'ou=Group,dc=example,dc=com',
  $group_attribute = 'gid',
  $admin_group     = 'admin',
  $givenname_attr  = 'givenName',
  $surname_attr    = 'surname',
)
{
  include ramadda
  include tomcat

  File {
    owner => $tomcat::user,
  }

  file {"${ramadda::home}/ldap.properties":
    ensure  => present,
    content => template('ramadda/ldap.properties.erb'),
    notify  => Service[$tomcat::service],
  }
}

