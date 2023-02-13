class devvm::vboxsf {
    mount { '/c':
        ensure  => 'absent',
        device  => 'c',
        options => 'defaults',
        fstype  => 'vboxsf',
    }

    mount { '/vagrant':
        ensure  => 'absent',
        device  => 'vagrant',
        options => 'defaults',
        fstype  => 'vboxsf',
    }

    mount { '/host/home':
        ensure  => 'absent',
        device  => 'host_home',
        options => 'defaults',
        fstype  => 'vboxsf',
    }

    mount { '/var/cache/apt/archives':
        ensure  => 'absent',
        device  => 'var_cache_apt_archives',
        options => 'defaults',
        fstype  => 'vboxsf',
    }
}