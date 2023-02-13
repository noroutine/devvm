class devvm::networkmanager (
    String $unmanaged_devices = "interface-name:eth1",
) {

    contain devvm::services

    file { '/etc/NetworkManager/conf.d/99-unmanaged-devices.conf':
        ensure => file,
        content => template('devvm/etc_NetworkManager_99_unmanaged_devices_conf.erb'),
        notify => Exec['NetworkManager_reload'],
        replace => yes,
    }

}
