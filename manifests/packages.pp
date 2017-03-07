class innodbcluster::packages {


 	package {
               "mysql57-community-release":
                    provider => rpm, 
                    source => "https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm",
                    ensure => installed;
               "mysql-community-server":
                    require => Package['mysql57-community-release'],
                    ensure  => "installed";
 		       "mysql-shell":
                    require => Package['mysql57-community-release'],
                    install_options => ["--enablerepo=mysql-tools-preview"],
                    ensure  => "installed";
  	}


}
