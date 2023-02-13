class devvm::swapfile (
  String $file = '/swap.bin',
  String $size = '1G',
) {

  exec { 'swapoff':
    command => "/usr/sbin/swapoff -a",
  } ->

  exec { 'allocate swap file':
    command => "/usr/bin/fallocate -l $size $file",
  } ->

  exec { 'mkswap on swap file':
    command => "/usr/sbin/mkswap $file",
  } ->

  mount { 'swap file':
      name => 'none',
      ensure => 'present',
      device => $file,
      options => 'nofail',
      fstype => 'swap',
  } ->

  exec { 'swapon':
    command => "/usr/sbin/swapon -a",
  }

}
