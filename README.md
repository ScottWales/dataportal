CoE CSS Data Server
===================

This repository is the Puppet configuration for the CoE data server. It is
intended to run on a Centos6 VM, but should work for other distributions with
minor changes to the directory structure.

It installs Ramadda as a Tomcat webapp, then sets up Apache to serve the webapp
on port 80.

Starting the VM
---------------

The data portal is configured using Vagrant and Puppet - Vagrant boots the
virtual machine and Puppet configures it.

You will need Vagrant installed on your local machine (make sure its version
1.1 or later), e.g.

    apt-get install vagrant

To boot a local VM using Virtualbox run from this directory:

    vagrant up --provision

You can then access Ramadda by pointing a webbrowser to https://localhost:7443

To run on the cloud you will need the Vagrant Openstack plugin:

    vagrant plugin install vagrant-openstack-plugin

Make sure your openstack credentials are loaded (e.g. $OS\_USERNAME), then from
this directory run:

    vagrant up --provision --provider=openstack

The machine will be booted on the cloud and Puppet will begin to configure it.

In some instances Puppet may not be installed in time to begin the provisioning - if this happens run

    vagrant provision

to redo the configuration

When the configuration is finished point a webbrowser at the public IP address
of the VM to finish configuring Ramadda.

If needed you can SSH to the server by running

    vagrant ssh

or shut it down with

     vagrant destroy

Cloud Prerequisites
-------------------

The boot script expects to find two security groups - `ssh` and `http`, which
are intended to open up their respecive ports, e.g.

    $ nova secgroup-list-rules ssh
    +-------------+-----------+---------+-----------+--------------+
    | IP Protocol | From Port | To Port |  IP Range | Source Group |
    +-------------+-----------+---------+-----------+--------------+
    | tcp         | 22        | 22      | 0.0.0.0/0 |              |
    +-------------+-----------+---------+-----------+--------------+

    $ nova secgroup-list-rules http
    +-------------+-----------+---------+-----------+--------------+
    | IP Protocol | From Port | To Port |  IP Range | Source Group |
    +-------------+-----------+---------+-----------+--------------+
    | tcp         | 80        | 80      | 0.0.0.0/0 |              |
    | tcp         | 443       | 443     | 0.0.0.0/0 |              |
    +-------------+-----------+---------+-----------+--------------+

The VM will use $HOSTNAME as the name of the cloud ssh key
