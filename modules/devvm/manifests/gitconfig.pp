class devvm::gitconfig (
	String $git_user = $facts['user_facts']['user']['name'],
	String $git_email = $facts['user_facts']['user']['email'],
) {
	file { '/etc/gitconfig':
        ensure => file,
        content => template('devvm/etc_gitconfig.erb'),
        replace => yes,
	}
}