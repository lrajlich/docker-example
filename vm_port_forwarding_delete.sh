#!/bin/bash

## Check to see if the port forwarindg rule already exists on VM
if [ $(VBoxManage showvminfo "boot2docker-vm" | grep -c tcp-port8080) -eq 0 ]
then
    echo VM port forwarding NAT already removed. Skip
    exit 0
fi

## Port forwarding on VM, delete
echo Running vm_port_forwarding_remove.sh. Turn off VM, delete port forwarding rules from NAT, turn on VM.

boot2docker down
VBoxManage modifyvm "boot2docker-vm" --natpf1 delete tcp_port6379
VBoxManage modifyvm "boot2docker-vm" --natpf1 delete tcp_port3306
VBoxManage modifyvm "boot2docker-vm" --natpf1 delete tcp_port8080
boot2docker up
