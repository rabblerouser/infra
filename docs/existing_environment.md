# Working with the an existing environment

If you just want to contribute to this codebase, and test your changes against an existing environment, follow these
steps. The configuration values shown here will be for the Rabble Rouser core team's [staging environment](https://demo.rr-staging.click).
If you're going to work with a different environment, you'll need to change the values accordingly.

If you're trying to create a brand new environment, follow [these instructions](./new_environment.md) instead.

## Dependencies

Make sure you [install them](../README.md#dependencies) first.

## Set up AWS
1. Ask an existing team member to create an AWS user for you
2. [Configure an API key pair for the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

## Go into the terraform sub-directory

All commands from here on in should be run from here:

```sh
cd terraform
```

## Configure terraform remote state

The current state of the infrastructure is stored in an S3 bucket. You need to tell terraform where it is (enter the given
config values when prompted):

```sh
terraform init
#bucket: rr-staging.click-tf-state
#key: terraform.tfstate
#region: ap-southeast-2
```

## Create an SSH key pair

If you work with git, you likely have an SSH key pair set up already, otherwise you'll need to create a new pair. In
either case, make sure they're in the usual locations: `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`.

## Run terraform

Let's start by checking if the deployed infrastructure is up to date with the infra code:

```sh
./tf plan
```

Ideally it should say that there is nothing to do. If it wants to make changes, you might be having [this problem](./troubleshooting.md#terraform-wants-to-recreate-some-keys).
If you're unsure, reach out to the team for help.

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
