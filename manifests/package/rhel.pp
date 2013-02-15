# == Class: ganglia::package::rhel
class ganglia::package::rhel {
  $packagename        = $ganglia::packagename
  # end of variables
  case $ganglia::ensure {
    present, enabled, active, disabled, stopped: {
      #everything should be installed
      package { $packagename:
        ensure => 'present',
      }
    }#end present case
    absent: {
      #everything should be removed
      package { $packagename:
        ensure => 'absent',
      }
    }#end absent case
    default: {
      notice "ganglia::ensure has an unsupported value of ${ganglia::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
