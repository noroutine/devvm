class devvm::hostname (
    String $hostname = "hq-vm-dev-svr",
    String $domain = "localdomain",
    String $static_ip = "127.0.1.1",
) {

    exec { "hostname_change":
        command => "hostname $hostname",
        path => "/bin",
        subscribe => File["/etc/hostname"],
    }

    file { '/etc/hostname':
        content => "$hostname\n",
    }

    file { '/etc/hosts':
        content => template("devvm/etc_hosts.erb"),
    }
}
