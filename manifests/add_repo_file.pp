define ganglia::add_repo_file() {
  file { "yumrepo_$title":
    path   => "/etc/yum.repos.d/${title}.repo",
    ensure => 'file',
    before => Anchor['ganglia::end'],
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }
}