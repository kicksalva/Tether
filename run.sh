#!/bin/bash

# run linux tether client
sudo pkill -f "linux/run.sh"
sudo linux/run.sh &> run_log.txt &

# wait for tether app to start
until grep "Checking phone status" run_log.txt; do
    sleep 0.1
done

# setup routes
./route.sh

# run internet connectivity monitor in the background
pkill -f "linux/check_connectivity.sh"
linux/check_connectivity.sh &> connectivity_log.txt &


