class devvm::apt {

    [ "ANSIBLE", "DOCKER", "GOOGLE", "GOOGLE2", "ARTIFACTORY", "PGDG", "SUBLIME", "MICROSOFT" ].each | String $key | {
    	file { "/tmp/DPKG-GPG-KEY-$key-REPO":
    		source => "puppet:///modules/devvm/apt/gpg/DPKG-GPG-KEY-$key-REPO",
    		ensure => present,
    	} ->

        exec { "Import APT $key":
            path => "/bin:/usr/bin",
            command => "cat /tmp/DPKG-GPG-KEY-$key-REPO | apt-key add -",
            notify => Exec['apt-get update'],
        }
    }

    file { '/etc/apt/sources.list':
		content => template("devvm/etc_apt_sources_list.erb"),
		ensure => present,
		notify => Exec['apt-get update'],
    }

	exec { 'apt-get update':
    	path => "/bin:/usr/bin",
    	command => "apt-get -qq update",
	}

	Exec['apt-get update'] -> Package <| provider == apt |>

}