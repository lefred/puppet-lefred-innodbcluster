class innodbcluster::magic {

  $seed = $innodbcluster::seed
  $user = $innodbcluster::grant::user
  $password = $innodbcluster::grant::password
  $ip = $innodbcluster::mysql_ip
  $clustername = $innodbcluster::cluster_name

  # if seed, create cluster if it's not yet existing

  exec {
    "check_instance_config":
        command    => "mysqlsh -e 'print(dba.checkInstanceConfiguration(\"$user@$ip:3306\",{password:\"$password\"}))'  | grep \"status.*ok\"",
        logoutput  => true,
        path       => ['/bin', '/usr/bin'],
        unless  => "mysqlsh --uri $user:$password@$ip:3306 -e \"print(dba.getCluster('$clustername'))\" | grep '^<Cluster'",
        require    => Class['Innodbcluster::Grant'];
    "check_instance_state":
        command => "mysqlsh --uri $user:$password@$seed:3306 -e \"cluster=dba.getCluster('$clustername'); cluster.checkInstanceState('$user@$ip:3306','$password')\"; echo 0 >/dev/null",
        logoutput  => true,
        path       => ['/bin', '/usr/bin'],
        unless  => "mysqlsh --uri $user:$password@$ip:3306 -e \"print(dba.getCluster('$clustername'))\" | grep '^<Cluster'",
        require    => Exec['check_instance_config']
  }

  if  $seed == $hostname or $seed == $ip {
     info ("This node is the seed")

     exec {
        "create_cluster":
           command => "mysqlsh --uri $user:$password@$ip:3306 -e \"dba.createCluster('$clustername')\"",
           unless  => "mysqlsh --uri $user:$password@$ip:3306 -e \"print(dba.getCluster('$clustername'))\" | grep '^<Cluster'",
           path    => ['/bin', '/usr/bin'],
           require => Exec[ "check_instance_config"]
     }
  } else {
     info ("This node needs to join a cluster")

     exec {
        "add_instance":
           # TODO, remove echo 0 when I understand why it returns 1 even when it works
           command => "mysql --defaults-file=/root/.my.cnf -BN -e 'reset master' && mysqlsh --uri $user:$password@$seed:3306 -e \"cluster=dba.getCluster('$clustername'); cluster.addInstance('$user@$ip:3306',{password: '$password'})\"; echo 0 >/dev/null",
           logoutput  => true,
           unless  => "mysqlsh --uri $user:$password@$ip:3306 -e \"print(dba.getCluster('$clustername'))\" | grep '^<Cluster'",
           path    => ['/bin', '/usr/bin'],
           require => Exec[ "check_instance_state"]
     }

  }

}
