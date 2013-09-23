CoE CSS Data Server
===================

This repository is the Puppet configuration for the CoE data server. It is
intended to run on a Centos6 VM, but should work for other distributions with
minor changes to the directory structure.

It installs Ramadda as a Tomcat webapp, then sets up Apache to serve the webapp
on port 80.

To install
----------

Requires git and puppet

    git clone https://github.com/ScottWales/puppet
    cd puppet
    git submodule update --init
    puppet apply manifests/site.pp
