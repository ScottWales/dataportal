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


hiera_include('classes')

node default {
  $yum_packages = hiera_array('packages',[])
  if size($yum_packages) > 0 {
    package {$yum_packages:}
  }

  $pip_packages = hiera_array('python-packages',[])
  if size($pip_packages) > 0 {
    python::package {$pip_packages:}
  }

  $gem_packages = hiera_array('ruby-packages',[])
  if size($gem_packages) > 0 {
    package {$gem_packages:
      provider => gem,
    }
  }

  if $::openstack_meta_site == 'NCI' {
    # NFS mounts
    $gdata_mounts = hiera_array('gdata-mounts',[])
    if size($gdata_mounts) > 0 {
      nci::gdata {$gdata_mounts:}
    }
  }

  $proxies = hiera_hash('proxy',{})
  create_resources('nginx::resource::location', $proxies)

  amanda::ssh_authorized_key {'walesnix':
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDqp2BfHPXR02CjODE0gHJjTcd+d1e2SXUjjpRe8twVeQrcjFTvVwGJOENSyGeoccUPVzkcz0i/9ZaAljam1782t2o63Olt/bAYcp+njMCKtz1QTEVT6glr0S9vYmzTKARP/7d9Ld6d9TZAscRhZkKuDY5GD1cY3eZBD2Ffe+9ChC+oEgasS/Yp5u2m0+Aj4dNboMYqAs2930rJbqgfluNfNV8e4+xq7Th1OCZMGo0VK/bgieMJsXxSNhqCNYhL+p1RPRSZulzHT/MMXfldym1nLh/ntVGx2qcDvNG4MzunoX2AYdt0/JJTMHihyknDbk0pefV9Q9FBwuj+1eCuuapd',
  }

  file {'/etc/sysconfig/pgsql/postgresql':
    content => 'PGDATA=/persistent/postgresdata',
    require => Package['postgresql'],
    notify  => Service['postgresql'],
  }
}
