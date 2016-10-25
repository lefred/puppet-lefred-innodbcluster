class innodbcluster::grant ($user="root", $password="fred") {

   $cmd1 = "GRANT ALL PRIVILEGES ON *.* TO '$user'@'%' IDENTIFIED BY '$password' WITH GRANT OPTION;"
   
   exec {
      "add_grant":
        command => "mysql --defaults-file=/root/.my.cnf -BN -e \"$cmd1\"",
        unless    => "mysql --defaults-file=/root/.my.cnf -BN -e 'select user from mysql.user where user = \"$user\" and host = \"%\"' | grep $user > /dev/null",
        path      => [ '/bin' ],
        require   => Exec['set_root_pwd'];
   }

}
