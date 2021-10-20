#!/bin/bash
source ./ipv4
echo "Deploying to $FPGA_IPV4"
scp hps_gpio root@$FPGA_IPV4:/home/root