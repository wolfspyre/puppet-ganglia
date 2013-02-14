Anchor['ganglia::package::end'] -> Class['ganglia::config']
# == Class: ganglia::config
class ganglia::config {
  #make our parameters local scope
  $gmetad_data_source = $ganglia::gmetad_data_source
  #set variables
  $ganglia_dirs       = ['/etc/ganglia', '/etc/ganglia/conf.d']
  #set defaults
  File{
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    before => Anchor['ganglia::config::end'],
  }
  #clean up our parameters
  case $ganglia::ensure {
    enabled, active: {
      $fileensure      = 'present'
      $directoryensure = 'directory'
    }
    disabled, stopped: {
      $fileensure      = 'absent'
      $directoryensure = 'absent'
    }
    default: {
      notice "ganglia::ensure has an unsupported value of ${ganglia::ensure}."
    }#end default ensure case
  }
  case $::osfamily {
  #RedHat Debian Suse Solaris Windows
    Debian, Solaris, Suse, Windows: {
      notice "There is not currently a ${module_name} module for ${::osfamily} included for ${::fqdn}"
    }
    default: {
      file { $ganglia_dirs:
        ensure => $directoryensure,
        mode   => '0755',
      }
      if $ganglia::gmond {
        file {'/etc/ganglia/gmond.conf':
          ensure  => $fileensure,
          content => template($ganglia::gmond_template),
        }
      }
      if $ganglia::gmetad {
        file {'/etc/ganglia/gmetad.conf':
          ensure  => $fileensure,
          content => template($ganglia::gmetad_template),
        }
      }

    }#end default supported OS case
  }#end osfamily case
}#end class
