#!/bin/sh

set -e

if [[ -z `which terraform` ]]; then
  echo 'Error: Install terraform before running this script'
  exit 1
fi

if [[ -z `which aws` ]]; then
  echo 'Error: Install the AWS SDK before running this script'
  exit 1
fi

function usage() {
  echo 'Usage:\n\t tf.sh <COMMAND> [<MODULE>]'
  echo
  echo 'COMMAND: Either `plan` or `apply`'
  echo 'MODULE: Either `base`, `apps`, `seeder`, or omit to do both `base` and `apps`'
  echo
  echo 'Examples:'
  echo '\t./tf.sh plan base'
  echo '\t./tf.sh apply'
  echo '\t./tf.sh apply seeder'
  exit 1
}

BASE="--target module.base"
APPS="--target module.apps"
CORE="--target module.apps.module.core_app --target module.apps.module.core_app.module.app_event_forwarder"
MAILER="--target module.apps.module.mailer_app --target module.apps.module.mailer_app.module.app_event_forwarder"
SEED="--target module.seeder"

case "$1 $2" in
  "plan ")
    set -x
    eval terraform plan
    ;;
  "plan base")
    set -x
    eval terraform plan "$BASE"
    ;;
  "plan apps")
    set -x
    eval terraform plan "$APPS" "$CORE" "$MAILER"
    ;;
  "plan seeder")
    set -x
    eval terraform plan "$SEED"
    ;;

  "apply ")
    set -x
    eval terraform apply "$BASE"
    eval terraform apply "$APPS" "$CORE"
    eval terraform apply "$APPS" "$MAILER"
    ;;
  "apply base")
    set -x
    eval terraform apply "$BASE"
    ;;
  "apply apps")
    set -x
    eval terraform apply "$APPS" "$CORE"
    eval terraform apply "$APPS" "$MAILER"
    ;;
  "apply seeder")
    set -x
    eval terraform apply "$SEED"
    ;;
  *)
    usage
esac
