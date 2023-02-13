class devvm::sudo (
) {
    file { '/etc/sudoers':
        ensure => present,
        content => template("devvm/etc_sudoers.erb"),
    }
}
