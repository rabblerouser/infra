# Rabble Rouser Infrastructure

Code for spinning up Rabble Rouser infrastructure and deploying applications.

## Dependencies

Before you get started, you'll need to install a couple of dependencies first:

1. [Terraform 0.10.x](https://www.terraform.io/intro/getting-started/install.html) (For MacOS it's just: `brew install terraform`)
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

## Reading the app logs

See the next section on how to run arbitrary docker commands against the docker daemon running on the remote server.

## Run docker commands remotely
The EC2 instance has the docker remote API enabled, and you can interact with it using the regular docker client, just
like you would when working with images and containers on your own machine. First run this command, which will set up
a `dockerx` alias that's configured to run against the remote docker daemon:

```sh
cd terraform
source enable-remote-docker.sh
```

Now you can use the alias to do things like watch the logs for a particular app:

```sh
dockerx logs -f group-mailer
```

## SSH Access

If the EC2 instance exists and your SSH public key is on it, you can use this helper script:

```sh
cd terraform
./ssh.sh
```

Unfortunately this only works if you were the last person to run the provisioner, otherwise someone else's public key
will have overwritten yours. We intend to remove this limitation in the future.

## Troubleshooting

[See here](./docs/troubleshooting.md).
