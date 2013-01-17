# == Class: ganglia::service
#  wrapper class
Anchor['ganglia::config::end'] -> Class['ganglia::service']
class ganglia::service:: {
  Service{} -> Anchor['ganglia::service::end']
  $packagename        = $ganglia::packagename
  # end of variables
  case $::osfamily {
  #RedHat Debian Suse Solaris Windows
    Debian, Solaris, Suse, Windows: {
      notice "There is not currently a $module_name module for $::osfamily included for $::fqdn"
    }
    default: {
      case $ganglia::ensure {
        enabled, active: {
        #everything should be installed, but puppet is not managing the state of the service
          service {'ganglia':
            ensure    => running,
            enable    => true,
            subscribe => File['ganglia_conf'],
            require   => Package[$packagename],
            hasstatus => true,
          }#end service definition
        }#end enabled class
        disabled, stopped: {
          service {'ganglia':
            ensure    => stopped,
            enable    => false,
            subscribe => File['ganglia_conf'],
            hasstatus => true,
          }#end service definition
        }#end disabled
        default: {
        #nothing to do, puppet shouldn't care about the service
        }#end default ensure case
      }#end ensure case
    }#end supported OS default case
  }#end osfamily case
}#end class
