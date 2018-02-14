# Creating a new environment

If you want to spin up a brand new deployment of Rabble Rouser, follow these steps. This might be because you're a sysadmin
getting a new organisation set up, or perhaps you just want an isolated environment for experimental purposes.

If you just want to make some small changes and test them against an existing environment, follow [these instructions](./existing_environment.md) instead.

## Dependencies

Make sure you [install them](../README.md#dependencies) first.

## Set up AWS

1. [Create an AWS account to work in](https://aws.amazon.com/)
2. [Create an AWS IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
3. [Configure an API key pair for the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

## Manual AWS resources

There are a few AWS resources that can't be automagically created with terraform. You'll need to create these manually:

1. A Route53 hosted zone:

    Currently everything has to be deployed in a subdomain of an existing Route53 domain. For example, you could deploy
    your new instance at rabblerouser.example.com, and first you need to manually set up a Route53 zone for example.com.

2. An S3 bucket:

    Terraform keeps track of your existing infrastructure with the use of a [state file](https://www.terraform.io/docs/state/).
    While you can store this file locally and manage it yourself, it's easier to let terraform store it remotely and
    manage syncing/locking/conflicts for you. This command will create an S3 bucket to store our state file in, and
    later on we will configure terraform to use it:

    ```sh
    # make sure you fill in the <bucket-name> and <region> values
    aws s3api create-bucket --bucket <bucket-name> --region <region> --create-bucket-configuration LocationConstraint=<region> --acl private
    ```

    Note that this bucket will contain sensitive information, so control access to it carefully.

3. SES Configuration:

    This is not needed to get started right away, but if you want Rabble Rouser to be able to send email, you should
    follow the steps laid out in the [mailer](https://github.com/rabblerouser/mailer#ses-setup) documentation.

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

Earlier we manually created an S3 bucket for our terraform state to live in. Now we need to configure terraform to use it:

```sh
terraform init
```

It will ask you for the bucket name and region that you supplied earlier. It will also ask for an object key (i.e. a
file name); you can call it `terraform.tfstate`.

## Configure your environment
There is only a single variable that you have to configure up-front: the domain that you're deploying Rabble Rouser into.
Recall from earlier that your choice here is limited to choosing a subdomain of a hosted zone that you have already
created in Route53.

The quickest way to configure it is with an environment variable:

```sh
TF_VAR_domain="rabblerouser.example.com"

# Now run your terraform commands
```

Note that you should **not** specify a trailing period in the domain.

To save you having to set the environment variable in every terminal session, you can also supply the value in the file
[`terraform/terraform.tfvars`](../terraform/terraform.tfvars), overriding the default (which specifies the Rabble Rouser
team's own staging environment). However, this file is checked into git, and we don't yet have a good way to manage each
deployment's customisations to this file.

All other configuration is either auto-generated or has sensible defaults. There are additional variables listed in the
file [`terraform/variables.tf`](../terraform/variables.tf), which can all be overridden as above.

## Create the base infrastructure

Before you can deploy an application, you need to create the base infrastructure. *Note that this will cost you money,
even if you have the AWS free tier*:

```sh
./tf apply base
```

## Deploy the apps

Next we can deploy the applications onto the infrastructure:

```sh
./tf apply apps
```

## Seed the app

Before the application can be useful, the database needs some seed data. This is also done via terraform:

```sh
./tf apply seeder
```

## Check it works

Open up the app in your browser (at the domain you specified), and try to sign up a new member. Then go to the
`/dashboard` page and log in with these credentials:

- Email: `superadmin@rabblerouser.team`
- Password: `password1234`

## Troubleshooting

[See here](./troubleshooting.md).
