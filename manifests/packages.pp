class innodbcluster::packages {

#        $versionpack = "5.7.15-1.labs_gr090.el7"
        $versionpack = "5.7.17-1.1.el7"
        $versionurl  = "5.7.15-preview"
        $versiontgz  = "labs201609-el7"
        $buildtag    = "commercial"

	    $require = Exec['extract_labs']
        
        exec {
#		get_labs:
#			path 	=> ['/usr/bin', '/bin'],
#			unless  => "test -f /vagrant/mysql-innodb-cluster-$versiontgz-$architecture.rpm.tar.gz || rpm -q  mysql-community-server >/dev/null",
#            cwd	=> '/vagrant',
#            timeout => 3600,
#            command	=> "wget http://downloads.mysql.com/snapshots/pb/mysql-innodb-cluster-$versionurl/mysql-innodb-cluster-$versiontgz-$architecture.rpm.tar.gz";
#		extract_labs:
#            path 	=> ['/usr/bin', '/bin'],
#            unless  => "rpm -q  mysql-community-server",
#            cwd	=> '/vagrant',
#            require => Exec['get_labs'],
#            command	=> "tar zxvf mysql-innodb-cluster-$versiontgz-$architecture.rpm.tar.gz";
		swap_packages:
            path 	=> ['/usr/bin', '/bin'],
            onlyif  => "rpm -q  mariadb-libs",
            cwd	=> '/vagrant',
#            require => Exec['extract_labs'],
#            command	=> "yum -y swap mariadb-libs mysql-community-libs-$versionpack.$architecture.rpm mysql-community-common-$versionpack.$architecture.rpm mysql-community-libs-compat-$versionpack.$architecture.rpm"
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
		            source => "/vagrant/20852104.mysql-shell-1.0.6-0.1.fb2.el7.x86_64.rpm",
#                    require => [$require, Package["mysql-$buildtag-libs"]],
                    require => [ Package["mysql-$buildtag-libs"]],
                    ensure  => "installed";
  	}


}
