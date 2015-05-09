class diaspora::ruby (
  $system_user    = 'diaspora',
  $rvm_key_server = 'pgp.mit.edu',
  $rvm_version    = '1.26.11',
  $ruby_version   = '2.1.5',
) {

  $gemset              = 'diaspora'
  $ruby_system_version = '2.1.5'

  class { 'rvm':
    version    => $rvm_version,
    key_server => $rvm_key_server
  }->
  rvm_system_ruby { $ruby_version:
    ensure      => 'present',
    default_use => true
  }->
  rvm_gemset { "${ruby_version}@${gemset}":
    ensure  => present
  }->
  rvm_gem { "${ruby_version}@${gemset}/bundler":
    ensure  => latest
  }->
  rvm::system_user { "$system_user": }

  if $ruby_system_version != $ruby_version {
    rvm_system_ruby { $ruby_system_version:
      ensure      => 'present',
      default_use => true,
      require     => Class['rvm']
    }
  }

  rvm_gem { "${ruby_system_version}/puppet":
    ensure  => '3.7.3',
    require => Rvm_system_ruby[$ruby_system_version]
  }
}
