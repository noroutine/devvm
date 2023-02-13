class devvm::ssh_fix (
	
) {

	include ::systemd

	file { '/etc/systemd/system/ssh.service.d':
		ensure => directory,
		owner  => 'root',
		group  => 'root',
	} ->

	file { '/etc/systemd/system/ssh.service.d/runtime_dir.conf':
		ensure => file,
		owner  => 'root',
		group  => 'root',
		mode   => '0644',
		content => template("devvm/etc_systemd_system_ssh_service_runtime_dir_conf.erb"),
	} ~>

	Exec['systemctl-daemon-reload']
}

