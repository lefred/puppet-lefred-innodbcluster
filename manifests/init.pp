class innodbcluster (
    $mysql_root_password=undef,
    $mysql_old_root_password=undef,
    $mysql_serverid=undef,
    $ensure="running",
	$mysql_bind_interface="eth0",
    $cluster_name="mycluster",
    $seed=undef
                    ) {
      
    info("Welcome in MySQL InnoDB Cluster Experience !")

    $mysql_ip = inline_template("<%= scope.lookupvar('ipaddress_${mysql_bind_interface}') -%>")
    info("Interface to use = $mysql_bind_interface and has IP $mysql_ip")

    include innodbcluster::packages
    include innodbcluster::config
    include innodbcluster::service
    include innodbcluster::grant
    include innodbcluster::magic
            
}
