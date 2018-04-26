#!/bin/bash

ssh -i .tf_remote_files/ec2_ssh_key ubuntu@`terraform output host_ip`


# Local variables:
# coding: utf-8
# mode: shell-script
# sh-shell: bash
# End:
# vim: fileencoding=utf-8 filetype=bash :
