#!/bin/bash

## Check to see if the port forwarindg rule already exists on VM
if [ $(VBoxManage showvminfo "boot2docker-vm" | grep -c tcp_port8080) -gt 0 ]
then
    echo VM port forwarding NAT rule already exists. Skip
    exit 0
fi

## Port forwarding not on VM, add
echo Running vm_port_forwarding_add.sh. Turn off VM, add port forwarding rules to NAT, turn VM back on.

boot2docker down
VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp_port6379,tcp,,6379,,6379"
VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp_port3306,tcp,,3306,,3306"
VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp_port8080,tcp,,8080,,8080"
boot2docker up
