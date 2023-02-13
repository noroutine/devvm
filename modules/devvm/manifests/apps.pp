class devvm::apps {

    package { 'docker-ce':
        ensure => latest,
    }

    package { ['google-chrome-stable', 'fonts-liberation', 'libu2f-udev']:
        ensure => latest,
    } ->

    file { '/etc/apt/sources.list.d/google-chrome.list':
        ensure => absent,
    }

    package { ['sublime-text', 'code']:
        ensure => latest,
    } ->

    file { '/etc/apt/sources.list.d/vscode.list':
        ensure => absent,
    }

    package { [ 'vim', 'git', 'subversion', 'colordiff', 'htop', 'build-essential', 'ruby' ]:
        ensure => latest,
    }

    package { 'protobuf-compiler':
        ensure => latest,
    }

    package { 'git-review':
        ensure => latest,
    }

    package { 'virtualenv':
        ensure => latest,
    }

    package { 'whois':
        ensure => latest,
    }

    package { 'xdg-utils':
        ensure => latest,
    }

    package { 'python3-pip':
        ensure => latest,
    }

    package { 'apt-file':
        ensure => latest,
        notify => Exec['apt-file update'],
    }

    exec { 'apt-file update':
        command => "/usr/bin/apt-file update",
    }

}
