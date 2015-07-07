require 'spec_helper'

describe 'diaspora::database' do

  context 'With default paramaters' do
    it { should contain_class('diaspora::database::db_mysql') }
  end

  context 'With postgresql as db_provider' do
    let :facts do
      {
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '6.0',
        lsbdistid:'Debian',
        concat_basedir: '/foo'
      }
    end

    let :params do
      {
        db_provider: 'postgresql',
      }
    end

    it { should contain_class('diaspora::database::db_postgresql') }
  end

end
