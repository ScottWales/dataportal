#!/bin/bash
## \file    boot.sh
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  \brief   Boots an instance
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

# Make sure origin is up to date
git push

# Metadata defaults for the VM
# ============================
vmname=${1:-"$USER-base-vm"} # VM name
environment="test"           # Test or production
cloud="NCI"                  # Cloud to use
puppetrepo="https://github.com/ScottWales/dataportal"
                             # Git repo for puppet

# Which cloud are we on?
# ======================
if [ "$OS_AUTH_URL" == "https://keystone.rc.nectar.org.au:5000/v2.0/" ]; then
    # NeCTAR cloud
    image="NeCTAR CentOS 6.4 x86_64"
    cloud="NeCTAR"
else
    # NCI cloud
    image="centos-6.4-20130920"
    cloud="NCI"

    # Default public IPs
    if [ "$environment" = 'production' ]; then
        : ${publicip:='130.56.244.112'}
    elif [ "$environment" = 'test' ]; then
        : ${publicip:='130.56.244.113'}
    fi
fi

# Misc. stuff for booting
# =======================
flavor="m1.small"
key=$(hostname -s)
secgroups="ssh,http"

# Do the boot
# ===========
nova boot \
    --flavor "$flavor" \
    --image "$image" \
    --key_name "$key" \
    --security_groups "$secgroups" \
    --user_data cloud-config \
    --file "/usr/sbin/puppet-init=puppet-init" \
    --meta "cloud=$cloud" \
    --meta "environment=$environment" \
    --meta "puppetrepo=$puppetrepo" \
    --poll \
    $vmname

# Add IP address
# ==============
