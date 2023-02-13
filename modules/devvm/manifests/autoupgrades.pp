class devvm::autoupgrades {
    package { 'unattended-upgrades':
        ensure => latest,
    }

    package { 'apt-listchanges':
        ensure => latest,
    }
}