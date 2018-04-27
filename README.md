# Rabble Rouser Infrastructure

Code for spinning up Rabble Rouser infrastructure and deploying applications.

## Dependencies

Before you get started, you'll need to install a couple of dependencies first:

0. [Homebrew 1.3.6](https://brew.sh/) (Not strictly required for Rabblerouser, but it makes installing the toolchain a whole lot easier.)
1. [Terraform 0.10.x](https://www.terraform.io/intro/getting-started/install.html) (For MacOS it's just: `brew install terraform`)
2. [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) (For MacOS it's just: `brew install awscli`)
3. [Ansible 2.4.1.0](http://docs.ansible.com/ansible/latest/intro_installation.html) (For MacOS it's just: `brew install ansible`)
4. [ACME plugin for Terraform](https://github.com/paybyphone/terraform-provider-acme)

    This one you need to download and extract manually:

    ```sh
    # Create the Terraform plug-in directory.
    mkdir -p ~/.terraform.d/plugins/

    # Download the latest release of the ACME plug-in.
    # Visit <URL:https://github.com/vancluever/terraform-provider-acme/releases/latest>
    # to find the latest built release for your platform.
    wget -O /tmp/terraform-provider-acme.zip \
        https://github.com/vancluever/terraform-provider-acme/releases/download/v0.5.0/terraform-provider-acme_v0.5.0_darwin_amd64.zip

    # Extract the downloaded archive to the Terraform plug-in directory.
    unzip -d ~/.terraform.d/plugins/ /tmp/terraform-provider-acme.zip

    # Confirm the ACME provider is installed.
    # (This will not work until after the Terraform configuration is initialised.)
    (cd terraform/ && terraform providers)
    ```

## Working with an existing environment

If you just want to contribute to this codebase, and test your changes against an existing environment, [go here](./docs/existing_environment.md).

## Creating a new environment

If you want to spin up a brand new deployment of Rabble Rouser, [go here](./docs/new_environment.md).

## About the `tf` script

Throughout these docs, you are often told to run a special `tf` script, rather than running terraform directly. This is
to work around a particular [terraform limitation](https://github.com/hashicorp/terraform/issues/2430). You can run the
script with no arguments to see how to use it, or read [`the source code`](./terraform/tf) to see how it works:

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
bash # See note below
source enable-remote-docker.sh
```

Now you can use the alias to do things like watch the logs for a particular app:

```sh
dockerx logs -f group-mailer
```

Note that we start a new sub-shell before running the script. For some reason, if the script fails, it has a tendency
to crash the whole shell, which is really annoying. By running it in a sub-shell, if it crashes, it will at least just
crash back to the outer shell and no further.

If it does crash or hang, it might be because some cached data has gotten out of date. Clean it up and then try again:

```sh
rm .tf_remote_files/docker-*
rm .tf_remote_files/server-ip
```

## SSH Access

To get direct access to the EC2 instance, you can use this helper script:

```sh
cd terraform
./ssh.sh
```

Note that you must have previously run `./tf apply` at least once for this to work, otherwise the required SSH key will
not be present.

## Troubleshooting

[See here](./docs/troubleshooting.md).
