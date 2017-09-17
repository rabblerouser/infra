#!/bin/bash

set -e

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo -e '\033[0;31mError:\033[0m It looks like you are executing this script directly.'
  echo 'Instead, you need to source it, like this:'
  echo '    source enable-remote-docker.sh'
  exit 1
fi

echo 'This script will enable an alias for running docker against a remote server.'
echo 'Writing docker credentials to local files...'
echo

CA_PATH='./docker-ca.pem'
CERT_PATH='./docker-cert.pem'
KEY_PATH='./docker-key.pem'

printf '[1/5] CA... '
terraform output docker_api_ca > "${CA_PATH}"
echo -e '\033[0;32mDone!\033[0m'
printf '[2/5] Cert... '
terraform output docker_api_cert > "${CERT_PATH}"
echo -e '\033[0;32mDone!\033[0m'
printf '[3/5] Key... '
terraform output docker_api_key > "${KEY_PATH}"
echo -e '\033[0;32mDone!\033[0m'

printf '[4/5] Reading remote server IP address... '
SERVER_IP=`terraform output host_ip`
echo -e '\033[0;32mDone!\033[0m'

printf '[5/5] Generating alias and verifying... '
alias dockerx="docker --tlsverify -H=${SERVER_IP}:2376 --tlscacert=${CA_PATH} --tlscert=${CERT_PATH} --tlskey=${KEY_PATH}"
dockerx ps > /dev/null
echo -e '\033[0;32mDone!\033[0m'

echo 'You can now execute docker commands against the remote API using `dockerx`. For example:'
echo -e '    \033[1mdockerx ps\033[0m'
echo -e '    \033[1mdockerx logs -f group-mailer\033[0m'
echo -e '    \033[1mdockerx restart core\033[0m'
