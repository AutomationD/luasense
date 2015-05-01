#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Configuring puppet labs apt repo"
cat > /etc/apt/sources.list.d/puppetlabs.list << EOF
deb-src http://apt.puppetlabs.com wheezy main
deb-src http://apt.puppetlabs.com wheezy dependencies
deb http://apt.puppetlabs.com wheezy main
deb http://apt.puppetlabs.com wheezy dependencies
EOF

apt-get update
echo "Installing puppet"
apt-get install puppet --force-yes -y

echo "Installing luasense module"
wget https://bintray.com/artifact/download/kireevco/generic/kireevco-luasense-0.1.0.tar.gz
puppet module install kireevco-luasense-0.1.0.tar.gz --modulepath /etc/puppet/modules

echo "Applying luasense module"
puppet apply /etc/puppet/modules/luasense/manifests/init.pp -e 'include ::luasense' --modulepath /etc/puppet/modules/
# puppet apply /etc/puppet/modules/luasense/manifests/init.pp --modulepath /etc/puppet/modules/

