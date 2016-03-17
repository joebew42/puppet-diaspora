class diaspora::webserver (
  $environment   = 'development',
  $hostname      = 'development.diaspora.local',
  $app_directory = '/home/diaspora'
) {

  class { 'nginx': }

  nginx::resource::upstream { 'diaspora_server':
    ensure  => present,
    members => ['localhost:3000']
  }

  if ($environment == 'development') or ($environment == 'test') {
    nginx::resource::vhost { $hostname:
      ensure      => present,
      proxy       => 'http://diaspora_server',
    }
  } else {
    file {
      "$app_directory/certs/$hostname.crt":
        source  => "puppet:///modules/diaspora/certs/$hostname.crt",
        owner   => $user,
        group   => $group,
        before  => Nginx::Resource::Vhost[$hostname];

      "$app_directory/certs/$hostname.key":
        source  => "puppet:///modules/diaspora/certs/$hostname.key",
        owner   => $user,
        group   => $group,
        before  => Nginx::Resource::Vhost[$hostname];
    }

    nginx::resource::vhost { $hostname:
      ensure           => present,
      rewrite_to_https => true,
      ssl              => true,
      ssl_cert         => "$app_directory/certs/$hostname.crt",
      ssl_key          => "$app_directory/certs/$hostname.key",
      proxy            => 'http://diaspora_server'
    }

    $cache_config = {
     'gzip_static' => 'on',
     'expires'     => 'max',
     'add_header'  => 'Cache-Control public'
    }

    nginx::resource::location {
      "$hostname-assets":
        ensure              => present,
        ssl                 => true,
        www_root            => "$app_directory/current/public",
        location            => '/assets',
        vhost               => $hostname,
        location_cfg_append => $cache_config;

      "$hostname-uploads":
        ensure              => present,
        ssl                 => true,
        www_root            => "$app_directory/current/public",
        location            => '/uploads',
        vhost               => $hostname,
        location_cfg_append => $cache_config;
    }
  }
}
