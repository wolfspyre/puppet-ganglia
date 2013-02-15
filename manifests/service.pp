# == Class: ganglia::service
class ganglia::service {
  $gmond_package       = $ganglia::params::gmond_package_name
  $gmetad_package       = $ganglia::params::gmetad_package_name
  $gmond_config       = $ganglia::params::gmond_service_config
  $gmetad_config       = $ganglia::params::gmetad_service_config
  # end of variables
  case $::osfamily {
  #RedHat Debian Suse Solaris Windows
    Debian, Solaris, Suse, Windows: {
      notice "There is not currently a ${module_name} module for ${::osfamily} included for ${::fqdn}"
    }
    default: {
      case $ganglia::ensure {
        enabled, active: {
          $ensure = running
          $enable = true
        }
        disabled, stopped: {
          $ensure = stopped
          $enable = false
        }
        default: {
        #nothing to do, puppet shouldn't care about the service
        }#end default ensure case
      }#end case
      if $ganglia::gmond {
        service {'gmond':
          ensure    => $ensure,
          enable    => $enable,
          subscribe => File[$gmond_config],
          require   => Package[$gmond_package],
          hasstatus => true,
        }#end service definition
      }
      if $ganglia::gmetad {
        service {'gmetad':
          ensure    => $ensure,
          enable    => $enable,
          subscribe => File[$gmetad_config],
          require   => Package[$gmetad_package],
          hasstatus => true,
        }#end service definition
      }
      if $ganglia::web {
        #not sure what to do here.
        #default vhost is created in /var/www/html/gweb/
      }
    }#end supported OS default case
  }#end osfamily case
}#end class
