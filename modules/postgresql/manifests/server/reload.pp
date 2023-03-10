# @api private
class postgresql::server::reload {
  $service_status = $postgresql::server::service_status
  $service_reload = $postgresql::server::service_reload

  exec { 'postgresql_reload':
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    command     => $service_reload,
    onlyif      => $service_status,
    refreshonly => true,
    require     => Class['postgresql::server::service'],
  }
}
