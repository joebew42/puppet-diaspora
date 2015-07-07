require 'spec_helper'

describe 'diaspora::dependencies' do

  context 'Installing dependencies' do

    operating_system_dependencies = {
      'Ubuntu' => 'ubuntu',
      'Debian' => 'ubuntu',
      'CentOS' => 'centos',
      'RedHat' => 'centos',
      'Amazon' => 'centos'
    }.each do |operating_system, dependencies|
      describe "on #{operating_system}" do
        let(:facts) {{ operatingsystem: operating_system }}

        it { should contain_class("diaspora::dependencies::#{dependencies}") }
      end
    end

  end

end
