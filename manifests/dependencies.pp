class diaspora::dependencies () {
  case $::operatingsystem {
    Ubuntu,Debian: {
      class { 'diaspora::dependencies::ubuntu': }
    }
    CentOS,RedHat,Amazon: {
      class { 'diaspora::dependencies::centos': }
    }
  }
}
