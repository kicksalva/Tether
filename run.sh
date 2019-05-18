#!/bin/bash

# run internet connectivity monitor in the background
pkill -f "linux/check_connectivity.sh"
linux/check_connectivity.sh &> connectivity.txt &

# run linux tether client
sudo linux/run.sh
