class devvm::pip (
	String $pip_index_url = 'https://pypi.org/simple'
) {
	file { '/etc/pip.conf':
        ensure => file,
        content => template('devvm/etc_pip_conf.erb'),
        replace => yes,
	}
}