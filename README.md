A Basic VM
==========

This is a basic Puppet configuration for VM instances on the NeCTAR cloud

Services
--------

 * Nagios: System monitoring information, web service at http://$::fqdn/

Booting the instance
--------------------

To boot an instance run

    ./boot.sh

This requires openstack credentials in your environment.

