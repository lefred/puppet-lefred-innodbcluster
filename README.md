Puppet - MySQL InnoDB Cluster Module
====================================

This module is made for CentOS/RHEL and allows to install and bootstrap a
MySQL InnoDB Cluster group using MySQL Shell's AdminAPI.

Example
-------
Hiera example with 3 nodes:

hieradata/common.yaml
.....................

```
---

innodbcluster::mysql_root_password: fred
innodbcluster::mysql_bind_interface:    eth1
innodbcluster::cluster_name: mycluster
innodbcluster::grant::user: root
innodbcluster::grant::password: fred
innodbcluster::seed: mysql1
```

hieradata/mysql1.yaml
.....................

```
---
classes:
    - innodbcluster

    innodbcluster::mysql_serverid:  1
```


hieradata/mysql2.yaml
.....................

```
---
classes:
    - innodbcluster

    innodbcluster::mysql_serverid:  2
```


hieradata/mysql3.yaml
.....................

```
---
classes:
    - innodbcluster

    innodbcluster::mysql_serverid:  3
```





Todo
----
add router

