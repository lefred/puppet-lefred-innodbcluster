class innodbcluster::service ($ensure="running") {

  service {
    "mysqld":
        enable  => true,
        ensure  => $ensure,
        subscribe => File['my.cnf'],
        require => [ Package["mysql-community-server"], Exec['initialize_mysql'], Service['firewalld'] ];
    "firewalld":
        enable  => false,
        ensure  => stopped,
  }
}

