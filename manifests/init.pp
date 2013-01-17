# == Class: ganglia
#
# This module enables the configuration and management of a Ventrillo
# Server. see www.ventrillo.com for details on ganglia
# an RPM spec file, an RPM, init script, and config template are provided.
#
# === Parameters
#
#
# [*ganglia::add_repo*]
#
#
# [*ganglia::gmond_cluster_name*]
#   The name of the cluster this node is a member of
#
#
# [*ganglia::gmond_latlong*]
#
#
# [*ganglia::gmond_location*]
#
#
#
# [*ganglia::gmond_owner*]
#
#
#
# [*ganglia::gmond_tcp_accept_channels*]
#    A hash of TCP ports to listen on
#
# [*ganglia::gmond_version*]
#   The version of Ganglia to install. Currently supported versions are 3.4 and 3.5
#
# [*ganglia::repo_hash*]
#    A hash containing the necessary bits to feed to create_resources yumrepo
#
# [*ganglia::web*]
#   Whether or not this node is the web node
#
#  [*ganglia::gmond_udp_recv_channels*]
#    A hash of configured recieve channels
#
#  [*ganglia::gmond_udp_send_channels*]
#    A hash of configured send channels
#
#  [*ganglia::user*]
#    The user which ganglia should run as
# === Variables
#
# example hiera variable
#
#ganglia::add_repo: 'false'
#ganglia::gmond_cluster_name: 'CLUSTERNAME'
#ganglia::gmond_latlong: 'unspecified'
#ganglia::gmond_location: 'ANYTOWN,USA'
#ganglia::gmond_owner: 'CLUSTER CONTACT PERSON'
#ganglia::gmond_tcp_accept_channels:
# main: {
#   port:       '8649'
# }
#ganglia::gmond_udp_recv_channels:
# main: {
#   mcast_join: '239.2.11.71'
#   port:       '8649'
#   ttl:        '1'
# }
#ganglia::gmond_udp_send_channels:
# main: {
#   mcast_join: '239.2.11.71'
#   port:       '8649'
#   ttl:        '1'
# }
#ganglia::repo_hash:
#  ganglia_34: {
#    descr: 'ganglia_34',
#    baseurl: 'http://repo.mydomain.com/ganglia/3.4/',
#    gpgcheck: '0',
#    enabled: '1'
#  }
#ganglia::user: 'nobody'
#ganglia::version: '3.4'
#ganglia::web: False

#
# === Examples
#
# class { Ganglia:
#  ganglia::gmond_cluster_name => 'Web Cluster',
#  ganglia::gmond_location     => 'City, State',
#)
#
# === To Do:
#
# === Authors
#
# Wolf Noble <wolfspyre@wolfspaw.com>
#
# === Copyright
#
#
class ganglia(
  ganglia::add_repo                  = hiera('ganglia::add_repo', 'false' ),
  ganglia::gmond_cluster_name        = hiera('ganglia::gmond_cluster_name', 'CLUSTERNAME' ),
  ganglia::gmond_latlong             = hiera('ganglia::gmond_latlong', 'unspecified' ),
  ganglia::gmond_location            = hiera('ganglia::gmond_location', 'ANYTOWN,USA' ),
  ganglia::gmond_owner               = hiera('ganglia::gmond_owner', 'CLUSTER CONTACT PERSON' ),
  ganglia::gmond_tcp_accept_channels = hiera('ganglia::gmond_tcp_accept_channels'.
    main => {
      port => '8649',
    }),
  ganglia::gmond_udp_recv_channels   = hiera('ganglia::gmond_udp_recv_channels',
    main => {
      mcast_join => '239.2.11.71',
      port       => '8649',
      ttl        => '1',
    } ),
  ganglia::gmond_udp_send_channels   = hiera('ganglia::gmond_udp_send_channels',
    main => {
      mcast_join => '239.2.11.71',
      port       => '8649',
      ttl        => '1',
    } ),
  ganglia::repo_hash                 = hiera('ganglia::repo_hash',
    ganglia_34 => {
      descr     => 'ganglia_34',
      baseurl   => 'http://repo.mydomain.com/ganglia/3.4/',
      gpgcheck  => '0',
      enabled   => '1',
    }),
  ganglia::user                      = hiera('ganglia::user', 'nobody' ),
  ganglia::version                   = hiera('ganglia::version', '3.4'),
  ganglia::web                       = hiera('ganglia::web', false )
) {
  #take advantage of the Anchor pattern
  anchor{'ganglia::begin':}
  -> anchor {'ganglia::package::begin':}
  -> anchor {'ganglia::package::end':}
  -> anchor {'ganglia::config::begin':}
  -> anchor {'ganglia::config::end':}
  -> anchor {'ganglia::service::begin':}
  -> anchor {'ganglia::service::end':}
  -> anchor {'ganglia::end':}
  #clean up our parameters
$add_repo                  = $ganglia::add_repo
$gmond_cluster_name        = $ganglia::gmond_cluster_name
$gmond_latlong             = $ganglia::gmond_latlong
$gmond_location            = $ganglia::gmond_location
$gmond_owner               = $ganglia::gmond_owner
$gmond_tcp_accept_channels = $ganglia::gmond_tcp_accept_channels
$gmond_udp_recv_channels   = $ganglia::gmond_udp_recv_channels
$gmond_udp_send_channels   = $ganglia::gmond_udp_send_channels
$repo_hash                 = $ganglia::repo_hash
$user                      = $ganglia::user
$version                   = $ganglia::version
$web                       = $ganglia::web

  case $::osfamily {
    #RedHat Debian Suse Solaris Windows
    RedHat: {
      include ganglia::rhel::package
      include ganglia::rhel::config
      include ganglia::rhel::service
    }#end RHEL variant case
    default: {
      notice "There is not currently a ganglia module for $::osfamily"
    }#end default unsupported OS case
  }
}#end of ganglia class







