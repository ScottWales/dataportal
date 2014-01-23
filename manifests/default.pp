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

  if $::openstack_meta_site == 'NCI' {
    # NFS mounts
    $gdata_mounts = hiera_array('gdata-mounts',[])
    if size($gdata_mounts) > 0 {
      nci::gdata {$gdata_mounts:}
    }
  }
}
