# Working with the an existing environment

If you just want to contribute to this codebase, and test your changes against an existing environment, follow these
steps. The configuration values shown here will be for the Rabble Rouser core team's [staging environment](https://demo.rr-staging.click).
If you're going to work with a different environment, you'll need to change the values accordingly.

If you're trying to create a brand new environment, follow [these instructions](./new_environment.md) instead.

## Dependencies

Make sure you [install them](../README.md#dependencies) first.

## Set up AWS
1. Ask an existing team member to create an AWS user for you. *(note: we usually only give access to people we know - if
  you're new to the project then you might need to create your own AWS account to work in)*
2. [Configure an API key pair for the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

## Go into the terraform sub-directory

All commands from here on in should be run from here:

```sh
cd terraform
```

## Initialise the terraform modules

This tells terraform to go and find any modules (local or remote), and initialise or download them:

```sh
terraform get
```

## Configure terraform remote state

The current state of the infrastructure is stored in an S3 bucket. You need to tell terraform where it is:

```sh
# Adjust the config if you're not trying to work on the RR team's staging environment
terraform init \
  --backend-config='bucket=rr-staging.click-tf-state' \
  --backend-config='key=terraform.tfstate' \
  --backend-config='region=ap-southeast-2'
```

## Run terraform

Let's start by checking if the deployed infrastructure is up to date with the infra code:

```sh
./tf plan
```

Ideally it should say that there is nothing to do. If it wants to make changes and you're not sure why, reach out to the
team for help.

Once you've made some changes and you want to apply them, run this:

```sh
./tf apply
```

If you want, you can apply just the base infrastructure code, or just the app deployment:

```sh
./tf apply base
./tf apply apps
```

## Troubleshooting

[See here](./troubleshooting.md).
