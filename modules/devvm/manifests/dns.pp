class devvm::dns {

    package { "dnsmasq":
        ensure => purged,
    }

}
