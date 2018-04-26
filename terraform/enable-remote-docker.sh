#!/bin/bash

set -e

function echo_done() {
  echo -e '\033[0;32mDone!\033[0m'
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo -e '\033[0;31mError:\033[0m It looks like you are executing this script directly.'
  echo 'Instead, you need to source it, like this:'
  echo '    source enable-remote-docker.sh'
  exit 1
fi

echo 'This script will enable an alias for running docker against a remote server.'
echo 'Writing docker credentials to local files...'
echo

CA_PATH='.tf_remote_files/docker-ca.pem'
CERT_PATH='.tf_remote_files/docker-cert.pem'
KEY_PATH='.tf_remote_files/docker-key.pem'
SERVER_IP_PATH='.tf_remote_files/server-ip'

printf '[1/5] CA... '
[[ ! -e "${CA_PATH}" ]] && terraform output docker_api_ca > "${CA_PATH}"
echo_done
printf '[2/5] Cert... '
[[ ! -e "${CERT_PATH}" ]] && terraform output docker_api_cert > "${CERT_PATH}"
echo_done
printf '[3/5] Key... '
[[ ! -e "${KEY_PATH}" ]] && terraform output docker_api_key > "${KEY_PATH}"
echo_done

printf '[4/5] Reading remote server IP address... '
[[ ! -e "${SERVER_IP_PATH}" ]] && terraform output host_ip > "${SERVER_IP_PATH}"
SERVER_IP=`cat ${SERVER_IP_PATH}`
echo_done

printf '[5/5] Generating alias and verifying... '
alias dockerx="docker --tlsverify -H=${SERVER_IP}:2376 --tlscacert=${CA_PATH} --tlscert=${CERT_PATH} --tlskey=${KEY_PATH}"
dockerx ps > /dev/null
echo_done

echo 'You can now execute docker commands against the remote API using `dockerx`. For example:'
echo -e '    \033[1mdockerx ps\033[0m'
echo -e '    \033[1mdockerx logs -f group-mailer\033[0m'
echo -e '    \033[1mdockerx restart core\033[0m'


# Local variables:
# coding: utf-8
# mode: shell-script
# sh-shell: bash
# End:
# vim: fileencoding=utf-8 filetype=bash :
