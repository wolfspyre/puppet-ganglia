puppet-ganglia
================

A puppet module to manage the deployment and configuration of the [Ganglia](http://ganglia.sourceforge.net) monitoring tool.

Currently this module is geared towards a hierified puppet 2.6+ environment. I plan to remove the hiera bits from the main module and move them to an implementation/profile example module.

necessary hiera bits are listed in init.pp

I have not included the bits to configure apache, as that's out of the scope of this module. I plan to have an example implementation module which assumes you've already installed the [puppetlabs apache](https://github.com/puppetlabs/puppetlabs-apache) module

I have included [RPMs](https://github.com/wolfspyre/puppet-ganglia/tree/master/files/RPMs) for easy installation of both ganglia 3.4 and 3.5 for redhat5 based distros. I've also modified ganglia-web to have its' dependencies updated in environments where php53 is the php in use. I will provide RPMs for rh6 soon.