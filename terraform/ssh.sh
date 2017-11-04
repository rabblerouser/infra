#!/bin/bash

ssh -i .tf_remote_files/ec2_ssh_key ubuntu@`terraform output host_ip`
