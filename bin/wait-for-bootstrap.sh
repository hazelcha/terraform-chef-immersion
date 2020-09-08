#!/bin/bash

# pause for 6 minutes while chef server bootstraps
sleep 360s

while ! grep "Your Chef server is ready!" /chef-server-install.txt;do 
    echo "not found";
    sleep 2s;
done