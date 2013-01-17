# == Class: ganglia::package::rhel
#  wrapper class
#
class ganglia::package::rhel {
  Package{} -> Anchor['ganglia::package::end']
  $packagename        = $ganglia::packagename
  # end of variables
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
}#end class
