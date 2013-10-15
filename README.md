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

The boot script will look for a ssh key to access the `private` submodule in
the file private/repos/id\_rsa, and for the repositories public host key in
private/repos/known\_hosts.

The private submodule is intended to hold information like private keys that
shouldn't be world-readable, the rest of the repository is publically viewable
on Github.
