class devvm::lo128 (
    String $interface_name = "lo:128",
    String $ip_address = "192.168.71.128",
    String $ip_netmask = "255.255.255.0",
) {

    contain devvm::services

    file { '/etc/network/interfaces.d/lo128':
        ensure => file,
        content => template('devvm/etc_network_interfaces_d_lo128.erb'),
        notify => Exec['networking_restart'],
        replace => yes,
    }

    file { '/etc/dhcp/dhclient.conf':
        ensure => file,
        content => template('devvm/etc_dhcp_dhclient_conf.erb'),
        notify => Exec['networking_restart'],
        replace => yes,
    }

}
