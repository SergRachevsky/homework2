#!/usr/bin/bash

csv_file="/var/tmp/autoinstalled-software.csv"

container_id=$(docker ps -a|grep teamcity-agent| awk '{print $1}')
files=$(docker exec $container_id ls /opt/buildagent)
[[ $files =~ .*BUILD_([0-9]+).* ]]
version=${BASH_REMATCH[1]}
echo "TeamCity build agent;$version" >> $csv_file

version=$(echo $(/home/ubuntu/.local/bin/ansible --version) | awk '{print $3}')
version="${version//]}"
echo "ansible;$version" >> $csv_file

version=$(echo $(node_exporter --version) | awk '{print $3}')
echo "Prometheus node exporter;$version" >> $csv_file

version=$(echo $(docker --version) | awk '{print $3}')
version="${version//,}"
echo "docker;$version" >> $csv_file

version=$(echo $(docker-compose --version) | awk '{print $3}')
version="${version//,}"
echo "docker-compose;$version" >> $csv_file
