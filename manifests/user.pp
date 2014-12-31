class diaspora::user (
  $home,
  $user,
  $group
) {

  group { $group:
    ensure => present,
  }->
  user { $user:
    ensure   => present,
    gid      => $group,
    shell    => '/bin/bash',
    home     => $home,
  }->
  file_line { 'sudo_rule':
    path => '/etc/sudoers',
    line => "$user ALL=(ALL) NOPASSWD: ALL",
  }->
  file { [$home,
          "$home/.ssh",
          "$home/shared",
          "$home/shared/config",
          "$home/certs"]:
    ensure => 'directory',
    owner  => $user,
    group  => $group
  }->
  file { "$home/.ssh/authorized_keys":
    source  => "puppet:///modules/diaspora/diaspora.pub",
    mode    => '600',
    owner   => $user,
    group   => $group,
  }
}
