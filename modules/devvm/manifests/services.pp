class devvm::services {

    exec { "NetworkManager_reload":
        command => "/usr/bin/systemctl reload NetworkManager",
    }

    exec { "networking_restart":
        command => "/etc/init.d/networking restart",
    } ->

    exec { 'ifup lo:128':
        command => "/sbin/ifup lo:128",
        # notify => Package['rabbitmq-server'],
    }

    service { "exim4":
        ensure => running,
        enable => true,
        hasrestart => true,
    }

    service { "puppet":
        ensure => stopped,
        enable => false,
    }

    service { "mcollective":
        ensure => stopped,
        enable => false,
    }

}
