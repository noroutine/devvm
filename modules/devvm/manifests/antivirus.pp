class devvm::antivirus {
    package { 'clamav':
        ensure => installed,
    }
}
