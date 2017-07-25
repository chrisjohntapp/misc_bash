#!/bin/bash

until [ ! -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock ]
do
    sleep 1
done

sudo /etc/init.d/puppet stop

sudo find /etc/puppetlabs/puppet/ssl/certs/ -type f -exec rm -rf {} \;
sudo find /etc/puppetlabs/puppet/ssl/certificate_requests/ -type f -exec rm -rf {} \;
sudo rm -f /etc/puppetlabs/puppet/ssl/crl.pem

sudo /etc/init.d/puppet start

