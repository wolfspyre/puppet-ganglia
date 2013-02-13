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
# [*ganglia::gmetad*]
#
# [*ganglia::gmond*]
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
# [*ganglia::web_php53*]
#   Whether or not to use php53 RPMs in rh/cent5
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
#ganglia::add_repo:           'false'
#ganglia::gmetad:             'false'
#ganglia::gmetad_template:    'ganglia/etc/ganglia/gmetad.conf.erb'
#ganglia::gmond:              'true'
#ganglia::gmond_cluster_name: 'unspecified'
#ganglia::gmond_gexec_enable: 'false'
#ganglia::gmond_latlong:      'unspecified'
#ganglia::gmond_location:     'unspecified'
#ganglia::gmond_owner:        'unspecified'
#ganglia::gmond_tcp_accept_channels:
# main: {
#   port:       '8649'
# }
#ganglia::gmond_template:     'ganglia/etc/ganglia/gmond.conf.erb'
#ganglia::gmond_udp_recv_channels:
# main: {
#   mcast_join: '239.2.11.71',
#   bind:       '239.2.11.71',
#   port:       '8649',
#   retry_bind: true
# }
#ganglia::gmond_udp_send_channels:
# main: {
#   mcast_join:    '239.2.11.71',
#   port:          '8649',
#   bind_hostname: 'yes',
#   ttl:           '1'
# }
#ganglia::gmond_url:          'unspecified'
#ganglia::repo_hash:
#  ganglia_34: {
#    descr: 'ganglia_34',
#    baseurl: 'http://repo.mydomain.com/ganglia/3.4/',
#    gpgcheck: '0',
#    enabled: '1'
#  }
#ganglia::user:               'nobody'
#ganglia::version:            '3.4'
#ganglia::web:                'false'
#ganglia::web_php53:          'true'
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
  $ganglia::add_repo                  = hiera('ganglia::add_repo',           'false'
  $ganglia::ensure                    = enabled,
  $ganglia::gmetad                    = hiera('ganglia::gmetad',             'false' ),
  $ganglia::gmetad_template           = hiera('ganglia::gmetad_template',    'ganglia/etc/ganglia/gmetad.conf.erb'),
  $ganglia::gmond                     = hiera('ganglia::gmond',              'true' ),
  $ganglia::gmond_cluster_name        = hiera('ganglia::gmond_cluster_name', 'unspecified' ),
  $ganglia::gmond_gexec_enable        = hiera('ganglia::gmond_gexec_enable', 'false' ),
  $ganglia::gmond_latlong             = hiera('ganglia::gmond_latlong',      'unspecified' ),
  $ganglia::gmond_location            = hiera('ganglia::gmond_location',     'unspecified' ),
  $ganglia::gmond_owner               = hiera('ganglia::gmond_owner',        'unspecified' ),
  $ganglia::gmond_tcp_accept_channels = hiera('ganglia::gmond_tcp_accept_channels',
    main => {
      port => '8649'
    }),
  $ganglia::gmond_template            = hiera('ganglia::gmond_template',     'ganglia/etc/ganglia/gmond.conf.erb'),
  $ganglia::gmond_udp_recv_channels   = hiera('ganglia::gmond_udp_recv_channels',
    main => {
      mcast_join => '239.2.11.71',
      port       => '8649',
      bind       => '239.2.11.71',
      retry_bind => true
    } ),
  $ganglia::gmond_udp_send_channels   = hiera('ganglia::gmond_udp_send_channels',
    main => {
      bind_hostname => 'yes',
      mcast_join    => '239.2.11.71',
      port          => '8649',
      ttl           => '1',
    } ),
  $ganglia::gmond_url                 = hiera('ganglia::gmond_url',          'www.mydomain.com'),
  $ganglia::repo_hash                 = hiera('ganglia::repo_hash',
    ganglia_34 => {
      descr     => 'ganglia_34',
      baseurl   => 'http://repo.mydomain.com/ganglia/3.4/',
      gpgcheck  => '0',
      enabled   => '1',
    }),
  $ganglia::user                      = hiera('ganglia::user',               'nobody' ),
  $ganglia::version                   = hiera('ganglia::version',            '3.4'),
  $ganglia::web                       = hiera('ganglia::web',                'false' ),
  $ganglia::web_php53                 = hiera('ganglia::web_php53',          'false')
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
  if is_string($ganglia::add_repo) {
    $add_repo = str2bool($ganglia::add_repo)
  } else {
    $add_repo = $ganglia::add_repo
  }
  if is_string($ganglia::gmetad) {
    $gmetad = str2bool($ganglia::gmetad)
  } else {
    $gmetad = $ganglia::gmetad
  }
  if is_string($ganglia::gmond) {
    $gmond = str2bool($ganglia::gmond)
  } else {
    $gmond = $ganglia::gmond
  }
  if is_string($ganglia::gmond_gexec_enable) {
    $gmond_gexec_enable = str2bool($ganglia::gmond_gexec_enable)
  } else {
    $gmond_gexec_enable = $ganglia::gmond_gexec_enable
  }
  if is_string($ganglia::web) {
    $web = str2bool($ganglia::web)
  } else {
    $web = $ganglia::web
  }
  if is_string($ganglia::web_php53) {
    $web_php53 = str2bool($ganglia::web_php53)
  } else {
    $web_php53 = $ganglia::web_php53
  }
  $ensure                    = $ganglia::ensure
  $gmetad_template           = $ganglia::gmetad_template
  $gmond_cluster_name        = $ganglia::gmond_cluster_name
  $gmond_latlong             = $ganglia::gmond_latlong
  $gmond_location            = $ganglia::gmond_location
  $gmond_owner               = $ganglia::gmond_owner
  $gmond_tcp_accept_channels = $ganglia::gmond_tcp_accept_channels
  $gmond_template            = $ganglia::gmond_template
  $gmond_udp_recv_channels   = $ganglia::gmond_udp_recv_channels
  $gmond_udp_send_channels   = $ganglia::gmond_udp_send_channels
  $gmond_url                 = $ganglia::gmond_url
  $repo_hash                 = $ganglia::repo_hash
  $user                      = $ganglia::user
  $version                   = $ganglia::version
  if $add_repo {
    Yumrepo{
        notify  => Exec['yum_clean_metadata'],
        require => Anchor['dprepo::config::end'],
        before  => Anchor['ganglia::package::begin'],
      }
    create_resources('yumrepo', $ganglia::repo_hash)
    $ganglia_reponame = keys($ganglia::repo_hash)
    ganglia::add_repo_file{ $ganglia::repo_hash: }
  }
}#end of ganglia class









