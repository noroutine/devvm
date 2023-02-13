class devvm::time (
    String $zone = "Europe/Berlin",
) {
    file { '/etc/localtime':
        ensure => link,
        target => "/usr/share/zoneinfo/$zone",
    }
}
