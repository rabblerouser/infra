#!/bin/bash

set -e
set -x

terraform taint null_resource.provisioner
terraform apply
