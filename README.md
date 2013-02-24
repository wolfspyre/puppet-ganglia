puppet-ganglia
================

A puppet module to manage the deployment and configuration of the [Ganglia](http://ganglia.sourceforge.net) monitoring tool.

Currently this module is geared towards a hierified puppet 2.6+ environment. I plan to remove the hiera bits from the main module and move them to an implementation/profile example module.

necessary hiera bits are listed in init.pp

I have not included the bits to configure apache, as that's out of the scope of this module. I plan to have an example implementation module which assumes you've already installed the [puppetlabs apache](https://github.com/puppetlabs/puppetlabs-apache) module