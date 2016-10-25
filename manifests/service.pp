class innodbcluster::service ($ensure="running") {

  $buildtag = $innodbcluster::packages::buildtag


  service {
    "mysqld":
        enable  => true,
        ensure  => $ensure,
        subscribe => File['my.cnf'],
        require => [ Package["mysql-$buildtag-server"], Exec['initialize_mysql'], Service['firewalld'] ];
    "firewalld":
        enable  => false,
        ensure  => stopped,
  }
}

