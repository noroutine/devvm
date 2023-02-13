class devvm::certs {
  file { '/etc/ssl':
    ensure => directory,
  }

  file { '/etc/ssl/postgres':
    ensure  => directory,
    recurse => remote,
    source  => 'puppet:///modules/devvm/certs/server/postgres',
    owner   => 'postgres',
    group   => 'postgres'
  }

  exec { 'postgres certificate permissions':
    command => '/bin/chmod 600 /etc/ssl/postgres/postgres.key'
  }
}