class diaspora::ruby (
  $system_user = 'diaspora',
  $rvm_version  = '1.25.14',
  $ruby_version = '2.0.0'
) {

  $gemset       = 'diaspora'

  class { 'rvm':
    version => $rvm_version
  }->
  rvm_system_ruby { $ruby_version:
    ensure      => 'present',
    default_use => true
  }->
  rvm_gem { "$ruby_version/puppet":
    ensure  => '3.1.1',
  }->
  rvm_gemset { "$ruby_version@$gemset":
    ensure  => present,
  }->
  rvm::system_user { "$system_user": }
}
