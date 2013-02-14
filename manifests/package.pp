# == Class: ganglia::package
#  wrapper class
#
class ganglia::package {
  Package{} -> Anchor['ganglia::package::end']
  include ganglia
  include ganglia::params
  #make our variables local scope
  $gmetad_package        = $ganglia::params::gmetad_package_name
  $gmond_package         = $ganglia::params::gmond_package_name
  $web_package           = $ganglia::params::web_package_name
  # end of variables
  case $::osfamily {
  #RedHat Debian Suse Solaris Windows
    Debian, Solaris, Suse, Windows: {
      notice "There is not currently a ${module_name} module for ${::osfamily} included for ${::fqdn}"
    }
    default: {
      #metadaemon
      case $ganglia::gmetad {
        present, enabled, active, disabled, stopped, true: {
          package { $gmetad_package:
            ensure => 'present',
          } -> Anchor['ganglia::package::end']
        }#end present case
        absent, false: {
          package { $gmetad_package:
            ensure => 'absent',
          } -> Anchor['ganglia::package::end']
        }#end absent case
        default: {
          notice "ganglia::gmetad has an unsupported value of ${ganglia::gmetad}."
        }#end default ensure case
      }
      #monitor
      case $ganglia::gmond {
        present, enabled, active, disabled, stopped, true: {
          package { $gmond_package:
            ensure => 'present',
          } -> Anchor['ganglia::package::end']
        }#end present case
        absent, false: {
          package { $gmond_package:
            ensure => 'absent',
          } -> Anchor['ganglia::package::end']
        }#end absent case
        default: {
          notice "ganglia::gmond has an unsupported value of ${ganglia::gmond}."
        }#end default ensure case
      }
      #web
      case $ganglia::web {
        present, enabled, active, disabled, stopped, true: {
          package { $web_package:
            ensure => 'present',
          } -> Anchor['ganglia::package::end']
        }#end present case
        absent, false: {
          package { $web_package:
            ensure => 'absent',
          } -> Anchor['ganglia::package::end']
        }#end absent case
        default: {
          notice "ganglia::web has an unsupported value of ${ganglia::web}."
        }#end default ensure case
      }
    }#end supported OS default case
  }#end osfamily case
}#end class
