#This class contains parameters not sourced elsewhere
class ganglia::params {
  $gmond_package_name   = ['ganglia-gmond', 'ganglia-gmond-modules-python']
  $gmond_service_name   = 'gmond'

  $gmetad_package_name  = 'ganglia-gmetad'
  $gmetad_service_name  = 'gmetad'

  # paths are the same for el5.x & el6.x
  case $ganglia::web_php53 {
    true: {
      $web_package_name     = 'ganglia-web-php53'
    }
    false: {
      $web_package_name     = 'ganglia-web'
    }
    default: {fail("Expecting true or false for ganglia::web_php53, but got ${ganglia::web_php53}")}
  }
  $web_php_config       = '/etc/ganglia/conf.php'
  $web_php_erb          = 'ganglia/conf.php.erb'

  case $ganglia::version {
    3.4: {
      $gmond_service_config  = '/etc/ganglia/gmond.conf'
      $gmond_service_erb     = 'ganglia/gmond.conf.3.4.erb'
      $gmetad_service_config = '/etc/ganglia/gmetad.conf'
      $gmetad_service_erb    = 'ganglia/gmetad.conf.3.4.erb'
    }
    3.5: {
      $gmond_service_config  = '/etc/ganglia/gmond.conf'
      $gmond_service_erb     = 'ganglia/gmond.conf.3.5.erb'
      $gmetad_service_config = '/etc/ganglia/gmetad.conf'
      $gmetad_service_erb    = 'ganglia/gmetad.conf.3.5.erb'
    }
    default: {
      fail("Module ${module_name} version ${ganglia::version} is not supported on ${::fqdn}")
    }
  #may not need this since we're rolling our own packages
  #case $::osfamily {
  #  redhat: {
  #    case $::lsbmajdistrelease {
  #      # the epel packages change uid/gids + install paths between 5 & 6
  #      5: {
  #        $gmond_service_config = '/etc/gmond.conf'
  #        $gmond_service_erb    = 'ganglia/gmond.conf.el5.erb'
  #
  #        $gmetad_service_config = '/etc/gmetad.conf'
  #        # it looks like it's safe to use the same template for el5.x & el6.x
  #        $gmetad_service_erb    = 'ganglia/gmetad.conf.el6.erb'
  #      }
  #      # fedora is also part of $::osfamily = redhat so we shouldn't default
  #      # to failing on el7.x +
  #      6, default: {
  #        $gmond_service_config = '/etc/ganglia/gmond.conf'
  #        $gmond_service_erb    = 'ganglia/gmond.conf.el6.erb'
  #
  #        $gmetad_service_config = '/etc/ganglia/gmetad.conf'
  #        $gmetad_service_erb    = 'ganglia/gmetad.conf.el6.erb'
  #      }
  #    }
  #  }
  #  default: {
  #    fail("Module ${module_name} is not supported on ${::operatingsystem}")
  #  }
  }
}
