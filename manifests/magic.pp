class innodbcluster::magic {

  $seed = $innodbcluster::seed
  $user = $innodbcluster::grant::user
  $password = $innodbcluster::grant::password
  $ip = $innodbcluster::mysql_ip
  $clustername = $innodbcluster::cluster_name

  # if seed, create cluster if it's not yet existing

  exec {
    "check_instance":
        command    => "mysqlsh -e 'print(dba.checkInstanceConfig(\"$user@$ip:3306\",{password:\"$password\"}))'  | grep \"status.*ok\"",
        logoutput  => true,
        path       => ['/bin', '/usr/bin'],
        unless  => "mysqlsh --uri $user:$password@$ip:3306 -e \"print(dba.getCluster('$clustername'))\" | grep '^<Cluster'",
        require    => Class['Innodbcluster::Grant']
  }

  if  $seed == $hostname or $seed == $ip {
     info ("This node is the seed")

     exec {
        "create_cluster":
           command => "mysqlsh --uri $user:$password@$ip:3306 -e \"dba.createCluster('$clustername')\"",
           unless  => "mysqlsh --uri $user:$password@$ip:3306 -e \"print(dba.getCluster('$clustername'))\" | grep '^<Cluster'",
           path    => ['/bin', '/usr/bin'],
           require => Exec[ "check_instance"]
     }
  } else {
     info ("This node needs to join a cluster")

     exec {
        "add_instance":
           command => "mysql --defaults-file=/root/.my.cnf -BN -e 'reset master' && mysqlsh --uri $user:$password@$seed:3306 -e \"cluster=dba.getCluster('$clustername'); cluster.addInstance('$user@$ip:3306','$password')\"; echo 0",
           logoutput  => true,
           unless  => "mysqlsh --uri $user:$password@$ip:3306 -e \"print(dba.getCluster('$clustername'))\" | grep '^<Cluster'",
           path    => ['/bin', '/usr/bin'],
           require => Exec[ "check_instance"]
     }

  }

}
