class devvm {

    file { '/etc/profile.d/puppetlabs.sh':
        ensure => present,
        content => 'export PATH=/opt/puppetlabs/bin:$PATH',
    }

    include devvm::apt
    
    include devvm::ssh_fix

    include devvm::swapfile

    class { 'devvm::environment':
        system_locale => "en_US.UTF-8",
    }

    class { 'devvm::time':
        zone => "Europe/Berlin",
    }

    class { 'devvm::lo128':
        interface_name => "lo:128",
        ip_address => "192.168.71.128",
        ip_netmask => "255.255.255.0",
    } ->
    class { 'devvm::hostname':
        hostname => "hq-vm-dev-svr",
        domain => "localdomain",
        static_ip => "127.0.1.1",
    }

    class { 'devvm::sandbox_user':
        username => "tomcat",
    }

    class { 'devvm::gitconfig':
    }

    class { 'devvm::mail':
        hostname => "hq-vm-dev-svr",
    }

    include devvm::autoupgrades

    class { 'devvm::wm':
        autologin => $facts['user_facts']['vm']['autologin'],
        autologinUsername => "tomcat",
        windowManager => $facts['user_facts']['vm']['windowmanager'],
    }

    include devvm::networkmanager

    if ! $facts['user_facts']['debug']['noapps'] {
        class { 'postgresql::globals':
            version                     => "9.6",
        } ->
        class { 'postgresql::server':
            encoding                    => 'UTF-8',
            locale                      => 'en_US.UTF-8',
            ip_mask_deny_postgres_user  => '0.0.0.0/32',
            ip_mask_allow_all_users     => '127.0.0.1/32',
            listen_addresses            => '127.0.0.1, 192.168.71.128',
            pg_hba_conf_defaults        => false,
            ipv4acls                    => [
                'local all postgres ident map=adminaccess',
                'local all all trust',
                'host all postgres 127.0.0.1/32 md5',
                'host all postgres 0.0.0.0/32 reject',
                'host all all 192.168.71.128/32 md5',
                'host test_db test_user 127.0.0.1/32 trust',
                'host dwtest_db test_user 127.0.0.1/32 trust',
                'host all all 127.0.0.1/32 md5',
            ],
            postgres_password           => 'postgres',
            subscribe => Exec['apt-get update'],
        }

        postgresql::server::pg_ident_rule { "adminaccess_postgres":
            map_name          => "adminaccess",
            system_username   => "postgres",
            database_username => "postgres",
        }

        postgresql::server::pg_ident_rule { "adminaccess_tomcat":
            map_name          => "adminaccess",
            system_username   => "tomcat",
            database_username => "postgres",
        }

        postgresql::server::role { "test_user":
            password_hash => postgresql::postgresql_password('test_user', '7AmL49x'),
            login     => true,
        }
        postgresql::server::role { "eyesonly":
            password_hash => postgresql::postgresql_password('eyesonly', '4YurEis'),
            login     => true,
        }
        postgresql::server::database { 'test_db':
            owner     => 'test_user',
        }
        postgresql::server::database { 'dwtest_db':
            owner     => 'test_user',
        }
        postgresql::server::database_grant { 'test_user can use test_db':
            privilege => 'ALL',
            db        => 'test_db',
            role      => 'test_user',
        }
        postgresql::server::database_grant { 'test_user can use dwtest_db':
            privilege => 'ALL',
            db        => 'dwtest_db',
            role      => 'test_user',
        }

        postgresql::server::database_grant { 'eyesonly can connect to test_db':
            privilege => 'CONNECT',
            db        => 'test_db',
            role      => 'eyesonly',
        }

        postgresql::server::database_grant { 'eyesonly can connect to dwtest_db':
            privilege => 'CONNECT',
            db        => 'dwtest_db',
            role      => 'eyesonly',
        }

        postgresql::server::config_entry { 'ssl':
            value     => 'on',
        }

        postgresql::server::config_entry { 'ssl_cert_file':
            value     => '/etc/ssl/postgres/postgres.crt',
        }

        postgresql::server::config_entry { 'ssl_key_file':
            value     => '/etc/ssl/postgres/postgres.key',
        }

        postgresql::server::config_entry { 'ssl_ciphers':
            value     => 'TLSv1.2',
        }

        include devvm::certs

        include devvm::apps
    }

    # include devvm::antivirus

    include devvm::sudo

}
