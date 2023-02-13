class devvm::mail (
    String $hostname = "hq-vm-dev-svr"
) {

    file { "/etc/mailname":
        ensure => present,
        content => "$hostname\n",
    }

    file { "/var/tmp/exim4-config.preseed":
        ensure => present,
        content => template("devvm/preseed/exim4-config.erb"),
        replace => yes,
    }

    exec { "preceed exim4-config":
        command => '/bin/bash -c "cat /var/tmp/exim4-config.preseed | /usr/bin/debconf-set-selections"',
        require => File["/var/tmp/exim4-config.preseed"],
        notify => Package["exim4-daemon-light"],
    }

	package { 'exim4-daemon-light':
        require => Exec["preceed exim4-config"],
		ensure => installed,
	}

	package { 'mutt':
		ensure => installed,
	}

    file { '/etc/exim4/update-exim4.conf.conf':
        ensure => file,
        content => template('devvm/etc_exim4_update_exim4_conf_conf.erb'),
        replace => yes,
    } ->

    file { '/etc/exim4/exim4.conf.template':
        ensure => file,
        content => template('devvm/etc_exim4_exim4_conf_template.erb'),
        replace => yes,
        require => Package["exim4-daemon-light"],
        notify => Exec["update-exim4.conf"],
    }

    exec { "update-exim4.conf":
    	command => "/usr/sbin/update-exim4.conf --removecomments --verbose",
        require => [ 
            File["/etc/mailname"],
            File["/etc/exim4/exim4.conf.template"],
            File["/etc/exim4/update-exim4.conf.conf"],
            Exec["preceed exim4-config"],
            Package["exim4-daemon-light"],
        ],
    	notify => Service["exim4"],
    }

}