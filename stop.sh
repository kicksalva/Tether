#!/bin/bash

sudo pkill -f "linux/check_connectivity.sh"
sudo pkill -SIGINT -f "linux/run.sh"
sudo pkill -SIGINT -f "node"

./unroute.sh

