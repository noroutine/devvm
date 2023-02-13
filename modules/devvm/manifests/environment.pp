class devvm::environment (
    String $system_locale = "en_US.UTF-8"
) {

    file { '/etc/environment':
        ensure => file,
        content => "export LC_ALL=${system_locale}\n",
    }

}
