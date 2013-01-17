# == Class: ganglia::rhel::service
#  wrapper class
Anchor['ganglia::config::end'] -> Class['ganglia::service::rhel']
class ganglia::service::rhel {
  Service{} -> Anchor['ganglia::service::end']
  $packagename        = $ganglia::packagename
  # end of variables
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
}#end class
