class devvm::wm (
    Boolean $autologin = false,
    String $autologinUsername = "tomcat",
    String $windowManager = "gnome",
) {

    case $windowManager {
        'gnome': {
            $ensure_gnome = latest
            $ensure_kde = purged
            $ensure_mate = purged
            $ensure_xfce = purged
            $ensure_awesome = purged
            $ensure_i3 = purged

            $displayManager = "gdm3"
        }

        'broken-kde': {
            $ensure_gnome = purged
            $ensure_kde = latest
            $ensure_mate = purged
            $ensure_xfce = purged
            $ensure_awesome = purged
            $ensure_i3 = purged

            $displayManager = "lightdm"
        }

        'mate': {
            $ensure_gnome = purged
            $ensure_kde = purged
            $ensure_mate = latest
            $ensure_xfce = purged
            $ensure_awesome = purged
            $ensure_i3 = purged

            $displayManager = "lightdm"
        }

        'xfce4': {
            $ensure_gnome = purged
            $ensure_kde = purged
            $ensure_mate = purged
            $ensure_xfce = latest
            $ensure_awesome = purged
            $ensure_i3 = purged

            $displayManager = "lightdm"
        }

        'awesome': {
            $ensure_gnome = purged
            $ensure_kde = purged
            $ensure_mate = purged
            $ensure_xfce = purged
            $ensure_awesome = latest
            $ensure_i3 = purged

            $displayManager = "lightdm"
        }

        'i3': {
            $ensure_gnome = purged
            $ensure_kde = purged
            $ensure_mate = purged
            $ensure_xfce = purged
            $ensure_awesome = purged
            $ensure_i3 = latest

            $displayManager = "lightdm"
        }

        default: {
            fail("gnome, mate, xfce4, awesome and i3 are supported as window managers")
        }
    }

    case $displayManager {
        'gdm3': {
            $ensure_gdm = latest
            $ensure_sddm = purged
            $ensure_lightdm = purged
        }

        'lightdm': {
            $ensure_gdm = purged
            $ensure_sddm = purged
            $ensure_lightdm = latest
        }

        default: {
            fail("gdm and lightdm are supported as desktop managers")
        }
    }

    package { 'gnome-terminal':
        ensure => latest,
        uninstall_options => [ "--auto-remove", "--purge" ]
    }

    package { [ 'mutter', 'metacity', 'gnome-core', 'gnome-session' ]:
        ensure => $ensure_gnome,
        uninstall_options => [ "--auto-remove", "--purge" ],
    }


    package { 'kde-standard':
        ensure => $ensure_kde,
        uninstall_options => [ "--auto-remove", "--purge" ],
    }

    package { [ 'mate-desktop-environment', 'mate-session-manager', 'mate-desktop' ]:
        ensure => $ensure_mate,
        uninstall_options => [ "--auto-remove", "--purge" ],
    } 

    package { ['xfce4', 'xfwm4', 'xfce4-session']:
        ensure => $ensure_xfce,
        uninstall_options => [ "--auto-remove", "--purge" ],
    }

    package { 'awesome':
        ensure => $ensure_awesome,
        uninstall_options => [ "--auto-remove", "--purge" ],
    }

    package { 'i3':
        ensure => $ensure_i3,
        uninstall_options => [ "--auto-remove", "--purge" ],
    }

    package { 'gdm3':
        ensure => $ensure_gdm,
        uninstall_options => [ "--auto-remove", "--purge" ],
    }

    package { 'sddm':
        ensure => $ensure_sddm,
        uninstall_options => [ "--auto-remove", "--purge" ],
    }

    package { 'lightdm':
        ensure => $ensure_lightdm,
        uninstall_options => [ "--auto-remove", "--purge" ],
    }

    exec { 'kill user processes':
        command => "/usr/bin/pkill -u $autologinUsername || true",
    }

    service { 'dbus':
        ensure => running,
        enable => true,
        hasrestart => true,
    }

    if $displayManager == 'gdm3' {
        file { '/etc/gdm3/daemon.conf':
            ensure => present,
            backup => false,
            content => template("devvm/etc_gdm3_daemon_conf.erb"),
            require => Package["gdm3"],
        }

        file { '/etc/gdm3/Xsession':
            ensure => file,
            replace => yes,
            content => template("devvm/etc_gdm3_Xsession.erb"),
            require => Package["gdm3"],
        }

        file { '/etc/pam.d/gdm-password':
            ensure => file,
            replace => yes,
            content => template("devvm/etc_pamd_gdm_password.erb"),
            require => Package["gdm3"],
        }
    }

    if $displayManager == 'lightdm' {
        file { '/var/lib/lightdm/data':
            ensure => directory,
            require => Package["lightdm"],
            owner => 'lightdm',
            group => 'lightdm',
        }

        file { '/etc/lightdm/lightdm.conf':
            ensure => file,
            replace => yes,
            content => template("devvm/etc_lightdm_lightdm_conf.erb"),
            require => Package["lightdm"],
        }    
    }

    file { '/etc/X11/xorg.conf':
        ensure => file,
        replace => yes,
        content => template("devvm/etc_x11_xorg_conf.erb"),
    }

    file { '/etc/X11/Xsession.d/65srvkeys':
        ensure => file,
        replace => yes,
        content => template("devvm/etc_x11_xsession_65srvkeys.erb"),
    }

}
