require 'spec_helper'

describe 'diaspora::webserver' do

  let :facts do
    {
      concat_basedir: '/foo'
    }
  end

  context 'With default paramaters' do
    it { should contain_nginx__resource__vhost('development.diaspora.local')
                 .with_ensure(:present)
                 .with_proxy(['http://diaspora_server']) }
  end

  context "With an environment different from 'development'" do
    let :params do
      {
        environment: 'production',
        hostname: 'production.diaspora.local'
      }
    end

    %w{crt key}.each do |extension|
      it { should contain_file("/home/diaspora/certs/production.diaspora.local.#{extension}")
                   .that_comes_before('Nginx::Resource::Vhost[production.diaspora.local]') }
    end

    it { should contain_nginx__resource__vhost('production.diaspora.local')
                 .with_ensure(:present)
                 .with_rewrite_to_https(true)
                 .with_ssl(true)
                 .with_ssl_cert('/home/diaspora/certs/production.diaspora.local.crt')
                 .with_ssl_key('/home/diaspora/certs/production.diaspora.local.key')
                 .with_proxy(['http://diaspora_server']) }

    %w{assets uploads}.each do |location|
      it { should contain_nginx__resource__location("production.diaspora.local-#{location}")
                   .with_ensure(:present)
                   .with_ssl(true)
                   .with_www_root('/home/diaspora/current/public')
                   .with_location("/#{location}")
                   .with_vhost('production.diaspora.local')
                   .with_location_cfg_append({'gzip_static' => 'on', 'expires' => 'max', 'add_header' => 'Cache-Control public'}) }
    end

  end

end
