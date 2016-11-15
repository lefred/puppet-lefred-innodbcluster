class innodbcluster::packages ( $versionpack="5.7.18-1.1.el7", $buildtag="commerciala", $shellversion="1.0.6-0.1.el7" ) {

        exec {
		swap_packages:
            		path 	=> ['/usr/bin', '/bin'],
            		onlyif  => "rpm -q  mariadb-libs",
            		cwd	=> '/vagrant',
            		command	=> "yum -y swap mariadb-libs mysql-$buildtag-libs-$versionpack.$architecture.rpm mysql-$buildtag-common-$versionpack.$architecture.rpm mysql-$buildtag-libs-compat-$versionpack.$architecture.rpm"
			
	}

 	package {
        	   "mysql-$buildtag-common":
		            provider => rpm,
		            source => "/vagrant/mysql-$buildtag-common-$versionpack.$architecture.rpm",
                    require => Exec['swap_packages'],
                    ensure  => "installed";
               "mysql-$buildtag-libs":
		            provider => rpm,
		            source => "/vagrant/mysql-$buildtag-libs-$versionpack.$architecture.rpm",
                    require => [ Exec['swap_packages'], Package["mysql-$buildtag-common"]],
                    ensure  => "installed";
               "mysql-$buildtag-libs-compat":
		            provider => rpm,
		            source => "/vagrant/mysql-$buildtag-libs-compat-$versionpack.$architecture.rpm",
                    require => [ Exec['swap_packages'], Package["mysql-$buildtag-libs"]],
                    ensure  => "installed";
               "mysql-$buildtag-server":
		            provider => rpm,
		            source => "/vagrant/mysql-$buildtag-server-$versionpack.$architecture.rpm",
#                    require => [$require, Package["mysql-$buildtag-libs"], Package["mysql-$buildtag-client"] ],
                    require => [ Package["mysql-$buildtag-libs"], Package["mysql-$buildtag-client"] ],
                    ensure  => "installed";
 		       "mysql-$buildtag-client":
		            provider => rpm,
		            source => "/vagrant/mysql-$buildtag-client-$versionpack.$architecture.rpm",
#                    require => [$require, Package["mysql-$buildtag-libs"]],
                    require => [ Package["mysql-$buildtag-libs"]],
                    ensure  => "installed";
 		       "mysql-shell":
		            provider => rpm,
		            source => "/vagrant/mysql-shell-$shellversion.x86_64.rpm",
#                    require => [$require, Package["mysql-$buildtag-libs"]],
                    require => [ Package["mysql-$buildtag-libs"]],
                    ensure  => "installed";
  	}


}
