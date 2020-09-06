#!/bin/bash
apt-get update
apt-get -y install curl

touch chef-server-install.txt

# create staging directories
if [ ! -d /drop ]; then
  mkdir /drop
fi
if [ ! -d /downloads ]; then
  mkdir /downloads
fi

# download the Chef server package
if [ ! -f /downloads/chef-server-core_12.17.33_amd64.deb ]; then
{  
    echo "Downloading the Chef server package..."
    wget -nv -P /downloads https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/16.04/chef-server-core_12.17.33-1_amd64.deb
} >> chef-server-install.txt

fi

# install Chef server
if [ ! $(which chef-server-ctl) ]; then
{
    echo "Installing Chef server..."
    dpkg -i /downloads/chef-server-core_12.17.33-1_amd64.deb
    chef-server-ctl reconfigure
} >> chef-server-install.txt


  echo "Waiting for services..." >> chef-server-install.txt
  until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
  while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

  echo "Creating initial user and organization..." >> chef-server-install.txt
  chef-server-ctl user-create chefadmin Chef Admin admin@hizzleinc.com insecurepassword --filename /drop/chefadmin.pem
  chef-server-ctl org-create hizzleinc "Hizzle, Inc." --association_user chefadmin --filename hizzleinc-validator.pem
fi

echo "Your Chef server is ready!" >> chef-server-install.txt