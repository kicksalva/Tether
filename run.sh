#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $script_dir

# stop existing processes
./stop.sh

# run linux tether client
sudo linux/run.sh &

# make http request to trigger tether to connect
wget -q --spider google.com &> /dev/null

# wait for tether app to start
until grep "Tether has connected" tether.log &> /dev/null; do
    echo "wating for tether connection"
    sleep 1
done

# setup routes
./route.sh

# run internet connectivity monitor in the background
linux/check_connectivity.sh &> connectivity.log &

popd

