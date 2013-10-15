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

git push

vmname=$USER-base-vm
nova delete $vmname

if [ "$OS_AUTH_URL" == "https://keystone.rc.nectar.org.au:5000/v2.0/" ]; then
    # NeCTAR cloud
    image="NeCTAR CentOS 6.4 x86_64"
else
    # NCI cloud
    image="centos-6.4-20130920"
fi

flavor="m1.small"
key=walesnix
secgroups="ssh,http"

nova boot \
    --flavor "$flavor" \
    --image "$image" \
    --key_name "$key" \
    --security_groups "$secgroups" \
    --user_data userdata.sh \
    --file "/root/.ssh/id_rsa=private/repos/id_rsa" \
    --file "/root/.ssh/known_hosts=private/repos/repos.nci.org.au" \
    --poll \
    $vmname

