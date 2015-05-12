

reload_config() {
	if [ -d /tmp/haproxy ] ; then
	    rm -rf /tmp/haproxy
	fi
	# Create temporary config for haproxy
	cp -r /etc/haproxy /tmp/
	# Add/overwrite new files there
	cp -rf /conf/haproxy /tmp/
	# Check new configuration of haproxy
	/usr/sbin/haproxy -c -C /tmp/haproxy -f haproxy.cfg
	if [ $? -eq 0 ] ; then
	    # Copy tested configuration to production and reload
	    cp -rfp /tmp/haproxy /etc/
	    /sbin/service haproxy reload
	    etcdctl set ${ETCDCTL_NOTIFY} reloaded
	    echo "New configuration applied"
	else
	    etcdctl set ${ETCDCTL_NOTIFY} error
	    echo "New configuration NOT applied"
	fi
	
	rm -rf /tmp/haproxy
}