class devvm::sandbox_user (
    String $username = "tomcat",
) {

    file { "/home/$username":
        ensure => directory,
        recurse => remote,
        source => "puppet:///modules/devvm/dotfiles",
        owner => $username,
        group => $username,
        notify => Exec['fix script permissions'],
    }

    exec { 'fix script permissions':
        command => "/bin/chmod +x /home/$username/.bashrc.d/bash-git-prompt/*.sh"
    }

    group { $username:
        ensure => present,
        gid => 1100,
    }

    user { $username:
        ensure => present,
        uid => 1100,
        groups => [ ],
        shell => '/bin/bash',
        home => "/home/$username",
        # Use supplied createpwd.sh to generate this
        password => '$6$n5QgFDoU2Z8WO0Vr$KEE9Iz4owrQXMzfMK2EuwuuzagSgcNj0FWxmHcWCXryhR5QJQKTgvhpu011w2g.2/ogxnVcBABxMdeKhI/3JZ1',
    }

    file { "/opt/devel":
        ensure => directory,
        owner => $username,
        group => $username,
    }

    file { "/opt/data":
        ensure => directory,
        owner => $username,
        group => $username,
    }

}
