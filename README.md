# Rabble Rouser Infrastructure

Code for spinning up Rabble Rouser infrastructure and deploying applications.

## Dependencies

Before you get started, you'll need to install a couple of dependencies first:

1. [Terraform 0.9.x](https://www.terraform.io/intro/getting-started/install.html) (For MacOS it's just: `brew install terraform`)
2. [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) (For MacOs it's just: `brew install awscli`)

## Working with an existing environment

If you just want to contribute to this codebase, and test your changes against an existing environment, [go here](./docs/existing_environment.md).

## Creating a new environment

If you want to spin up a brand new deployment of Rabble Rouser, [go here](./docs/new_environment.md).

## About the `tf` script

Throughout these docs, you are often told to run a special `tf` script, rather than running terraform directly. This is
to work around some terraform limitations ([1](https://github.com/hashicorp/terraform/issues/10462),
[2](https://github.com/hashicorp/terraform/issues/5190)), which currently make the native terraform commands a bit
verbose. You can run the script with no arguments to see how to use it, or read [`the source code`](./terraform/tf) to
see how it works:

```sh
cd terraform
./tf
```

## SSH Access

Assuming you've created the the EC2 instance and so your SSH key is on there, you can just run this helper script:

```sh
cd terraform
./ssh.sh
```

## Troubleshooting

[See here](./docs/troubleshooting.md).
