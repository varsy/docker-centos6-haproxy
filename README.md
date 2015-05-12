docker-centos6-haproxy
====================

CentOS6 + haproxy 1.5.2 + configurator support


### List of environment variables

* `ETCDCTL_PEERS` - address of etcd service to watch reload signal. Optional.
* `ETCDCTL_WATCH` - path inside etcd to watch reload signal. Optional.
* `ETCDCTL_NOTIFY` - path inside etcd to notify about state of reload [reloaded, error]. Optional.

### Example:

```
 docker run -d -e ETCDCTL_PEERS="172.17.42.1:4001" \
	-e ETCDCTL_WATCH=/services/haproxy/reload \
	-e ETCDCTL_NOTIFY=/services/haproxy/notify \
	--volumes-from=configurator varsy/centos6-haproxy
```
