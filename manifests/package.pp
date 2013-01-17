# == Class: ganglia::rhel::package
#  wrapper class
#
class ganglia::rhel::package {
  Package{} -> Anchor['ganglia::package::end']
  $packagename        = $ganglia::packagename
  # end of variables
  case $::osfamily {
  #RedHat Debian Suse Solaris Windows
    Debian, Solaris, Suse, Windows: {
      notice "There is not currently a $::modulename module for $::osfamily included for $::fqdn"
    }
    default: {
      case $ganglia::ensure {
        present, enabled, active, disabled, stopped: {
        #everything should be installed
          package { $packagename:
            ensure => 'present',
          } -> Anchor['ganglia::package::end']
        }#end present case
        absent: {
        #everything should be removed
          package { $packagename:
            ensure => 'absent',
          } -> Anchor['ganglia::package::end']
        }#end absent case
        default: {
          notice "ganglia::ensure has an unsupported value of ${ganglia::ensure}."
        }#end default ensure case
      }#end ensure case
    }#end supported OS default case
  }#end osfamily case
}#end class