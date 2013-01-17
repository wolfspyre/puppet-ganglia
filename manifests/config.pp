# == Class: ganglia::config
#  wrapper class
#
#
Anchor['gangliapackage::end'] -> Class['ganglia::config']
class ganglia::config {
  #make our parameters local scope
  File{} -> Anchor['ganglia::config::end']
  #clean up our parameters
  $ensure             = $ganglia::ensure
  case $::osfamily {
  #RedHat Debian Suse Solaris Windows
    Debian, Solaris, Suse, Windows: {
      notice "There is not currently a $module_name module for $::osfamily included for $::fqdn"
    }
    default: {
      case $ensure {
        present, enabled, active, disabled, stopped: {
        #everything should be installed

        }#end configfiles should be present case
        absent: {
        }#end configfiles should be absent case
        default: {
          notice "ganglia::ensure has an unsupported value of ${ganglia::ensure}."
        }#end default ensure case
      }#end ensure case
    }#end default supported OS case
  }#end osfamily case
}#end class
