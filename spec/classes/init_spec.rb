require 'spec_helper'

describe 'diaspora' do

  let :facts do
    {
      concat_basedir: '/foo'
    }
  end

  context 'With default parameters' do
    it { should contain_class('diaspora') }
    it { should contain_class('diaspora::dependencies') }
    it { should contain_class('diaspora::user') }
    it { should contain_class('diaspora::ruby') }
    it { should contain_class('diaspora::database') }
    it { should contain_class('diaspora::webserver') }

    it { should contain_file('/home/diaspora/shared/config/database.yml') }
    it { should contain_file('/home/diaspora/shared/config/diaspora.yml') }
    it { should contain_file('/home/diaspora/shared/config/eye.rb') }
    it { should contain_file('/home/diaspora/shared/env').with_content(/^RAILS_ENV=development$/) }
  end

end
