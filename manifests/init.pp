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
# [*ganglia::gmetad_conf_comments*]
#   Boolean to display comments in gmetad conf file
#
# [*ganglia::gmetad_data_source*]
#   A hash of the nodes to poll gmetad data from for additional groups
#
# [*ganglia::gmetad_template*]
#   The template file to use
#
# [*ganglia::gmond*]
#
# [*ganglia::gmond_cluster_name*]
#   The name of the cluster this node is a member of
#
# [*ganglia::gmond_latlong*]
#
# [*ganglia::gmond_location*]
#
# [*ganglia::gmond_owner*]
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
#ganglia::add_repo:             'false'
#ganglia::gmetad:               'false'
#ganglia::gmetad_conf_comments: 'false'
#ganglia::gmetad_grid_name:     undef
#ganglia::gmetad_template:      'ganglia/etc/ganglia/gmetad.conf.erb'
#ganglia::gmetad_data_source:
#  mycluster: {
#    host: 'collectornode.mydomain.com'
#    port: '8649'
#  }
#ganglia::gmond:                'true'
#ganglia::gmond_cluster_name:   'unspecified'
#ganglia::gmond_gexec_enable:   'false'
#ganglia::gmond_latlong:        'unspecified'
#ganglia::gmond_location:       'unspecified'
#ganglia::gmond_owner:          'unspecified'
#ganglia::gmond_tcp_accept_channels:
# main: {
#   port:       '8649'
# }
#ganglia::gmond_template:       'ganglia/etc/ganglia/gmond.conf.erb'
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
#ganglia::gmond_url:            'unspecified'
#ganglia::repo_hash:
#  ganglia_34: {
#    descr: 'ganglia_34',
#    baseurl: 'http://repo.mydomain.com/ganglia/3.4/',
#    gpgcheck: '0',
#    enabled: '1'
#  }
#ganglia::user:                 'nobody'
#ganglia::version:              '3.4'
#ganglia::web:                  'false'
#ganglia::web_php53:            'true'
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
#gmetad options to parameterize
#  RRAs
#  scalable mode
#  authority url
#  all_trusted
#  setuid
#  setuid_username
#  umask
#  xml_port
#  interactive_port
#  server_threads
#  rrd_rootdir
#  unsummarized_metrics
#  case_sensitive_hostnames
#  carbon_server
#  carbon_port
#  graphite_prefix
#  carbon_timeout
#
# === Authors
#
# Wolf Noble <wolfspyre@wolfspaw.com>
#
# === Copyright
#
#
class ganglia(
  $ganglia_add_repo                  = hiera('ganglia::add_repo',             'false' ),
  $ganglia_ensure                    = enabled,
  $ganglia_gmetad                    = hiera('ganglia::gmetad',               'false' ),
  $ganglia_gmetad_conf_comments      = hiera('ganglia::gmetad_conf_comments', 'false'),
  $ganglia_gmetad_data_source        = hiera('ganglia::gmetad_data_source',   undef),
  $ganglia_gmetad_grid_name          = hiera('ganglia::gmetad_grid_name',     undef),
  $ganglia_gmetad_template           = hiera('ganglia::gmetad_template',      'ganglia/etc/ganglia/gmetad.conf.erb'),
  $ganglia_gmetad_trusted_hosts      = hiera('ganglia::gmetad_trusted_hosts',  undef),
  $ganglia_gmond                     = hiera('ganglia::gmond',                'true' ),
  $ganglia_gmond_cluster_name        = hiera('ganglia::gmond_cluster_name',   'unspecified' ),
  $ganglia_gmond_gexec_enable        = hiera('ganglia::gmond_gexec_enable',   'false' ),
  $ganglia_gmond_latlong             = hiera('ganglia::gmond_latlong',        'unspecified' ),
  $ganglia_gmond_location            = hiera('ganglia::gmond_location',       'unspecified' ),
  $ganglia_gmond_owner               = hiera('ganglia::gmond_owner',          'unspecified' ),
  $ganglia_gmond_tcp_accept_channels = hiera('ganglia::gmond_tcp_accept_channels',
    main => {
      port => '8649'
    }),
  $ganglia_gmond_template            = hiera('ganglia::gmond_template',     'ganglia/etc/ganglia/gmond.conf.erb'),
  $ganglia_gmond_udp_recv_channels   = hiera('ganglia::gmond_udp_recv_channels',
    main => {
      mcast_join => '239.2.11.71',
      port       => '8649',
      bind       => '239.2.11.71',
      retry_bind => true
    } ),
  $ganglia_gmond_udp_send_channels   = hiera('ganglia::gmond_udp_send_channels',
    main => {
      bind_hostname => 'yes',
      mcast_join    => '239.2.11.71',
      port          => '8649',
      ttl           => '1',
    } ),
  $ganglia_gmond_url                 = hiera('ganglia::gmond_url',            'www.mydomain.com'),
  $ganglia_repo_hash                 = hiera('ganglia::repo_hash',
    ganglia_34 => {
      descr     => 'ganglia_34',
      baseurl   => 'http://repo.mydomain.com/ganglia/3.4/',
      gpgcheck  => '0',
      enabled   => '1',
    }),
  $ganglia_user                      = hiera('ganglia::user',                 'nobody' ),
  $ganglia_version                   = hiera('ganglia::version',              '3.4'),
  $ganglia_web                       = hiera('ganglia::web',                  'false' ),
  $ganglia_web_php53                 = hiera('ganglia::web_php53',            'false')
) {
  #clean up our parameters
  if is_string($ganglia_dd_repo) {
    $add_repo = str2bool($ganglia_add_repo)
  } else {
    $add_repo = $ganglia_add_repo
  }
  if is_string($ganglia_gmetad) {
    $gmetad = str2bool($ganglia_gmetad)
  } else {
    $gmetad = $ganglia_gmetad
  }
  if is_string($ganglia_gmetad_conf_comments) {
    $gmetad_conf_comments = str2bool($ganglia_gmetad_conf_comments)
  } else {
    $gmetad_conf_comments = $ganglia_gmetad_conf_comments
  }
  if is_string($ganglia_gmond) {
    $gmond = str2bool($ganglia_gmond)
  } else {
    $gmond = $ganglia_gmond
  }
  if is_string($ganglia_gmond_gexec_enable) {
    $gmond_gexec_enable = str2bool($ganglia_gmond_gexec_enable)
  } else {
    $gmond_gexec_enable = $ganglia_gmond_gexec_enable
  }
  if is_string($ganglia_web) {
    $web = str2bool($ganglia_web)
  } else {
    $web = $ganglia_web
  }
  if is_string($ganglia_web_php53) {
    $web_php53 = str2bool($ganglia_web_php53)
  } else {
    $web_php53 = $ganglia_web_php53
  }
  $ensure                    = $ganglia_ensure
  $gmetad_data_source        = $ganglia_gmetad_data_source
  $gmetad_grid_name          = $ganglia_gmetad_grid_name
  $gmetad_template           = $ganglia_gmetad_template
  $gmetad_trusted_hosts      = $ganglia_gmetad_trusted_hosts
  $gmond_cluster_name        = $ganglia_gmond_cluster_name
  $gmond_latlong             = $ganglia_gmond_latlong
  $gmond_location            = $ganglia_gmond_location
  $gmond_owner               = $ganglia_gmond_owner
  $gmond_tcp_accept_channels = $ganglia_gmond_tcp_accept_channels
  $gmond_template            = $ganglia_gmond_template
  $gmond_udp_recv_channels   = $ganglia_gmond_udp_recv_channels
  $gmond_udp_send_channels   = $ganglia_gmond_udp_send_channels
  $gmond_url                 = $ganglia_gmond_url
  $repo_hash                 = $ganglia_repo_hash
  $user                      = $ganglia_user
  $version                   = $ganglia_version
  include ganglia::package
  include ganglia::service
  include ganglia::config
  #take advantage of the Anchor pattern
  anchor{'ganglia::begin':
    before => Class['ganglia::packge'],
  }
  Class['ganglia::package'] -> Class['ganglia::config']
  Class['ganglia::package'] -> Class['ganglia::service']
  Class['ganglia::config']  -> Class['ganglia::service']

  anchor {'ganglia::end':
    require => [
      Class['ganglia::package'],
      Class['ganglia::config'],
      Class['ganglia::service'],
    ],
  }
  if $add_repo {
    Yumrepo{
        notify  => Exec['yum_clean_metadata'],
        before  => Class['ganglia::package'],
      }
    create_resources('yumrepo', $ganglia_repo_hash)
    $ganglia_reponame = keys($ganglia_repo_hash)
    ganglia::add_repo_file{ $ganglia_reponame: }
  }
}#end of ganglia class









