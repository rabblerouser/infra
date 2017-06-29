# Rabble Rouser Infrastructure

Code for spinning up Rabble Rouser infrastructure and provisioning the app.

## First-time setup

Right now this is not suitable for end users to be running on their own. You probably need to be at least semi-technical
for these instructions to make sense.

1. [Install Terraform 0.9.x](https://www.terraform.io/intro/getting-started/install.html)
OR
`brew install terraform`
2. [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
3. [Create an AWS account](https://aws.amazon.com/)
4. [Create an AWS API key pair](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
5. Put your credentials in `~/.aws/credentials` like this:

    ```
    [default]
    aws_access_key_id=AKIAEXAMPLEEXAMPLE
    aws_secret_access_key=abc123abc123abc123+abc123abc123
    ```

6. **Note: This is only necessary for a brand new environment.** Create a Route53 hosted zone for the parent domain of where your Rabble Rouser will live. E.g., if you are going to
 deploy it at rabblerouser.example.com, then you'll need to have a Route53 hosted zone already created for example.com.
7. **Note: This is only necessary for a brand new environment.** Create an S3 bucket to store the [terraform state file](https://www.terraform.io/docs/state/) in (see notes below):

    ```sh
    aws s3api create-bucket --bucket example-bucket-tf-state --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2 --acl private
    ```

8. Go into the `terraform/` directory. From there, run `terraform init`. It will ask you for some S3 config. Specify the
location where your remote state lives. For demo.rr-staging.click, this will be:

    ```
    bucket: rr-staging.click-tf-state
    key: terraform.tfstate
    region: ap-southeast-2
    ```

9. **Note: This is only necessary for a brand new environment.** If you want email sending to work, you need to set up SES. See the instructions in [mailer](https://github.com/rabblerouser/mailer) for how to do that.

## What did that just do?

This whole process will create a local file `.terraform/terraform.tfstate`, to remember where your state is stored. You can ignore
this file, and if you lose it, you can regenerate it with the above command.

Notes on the S3 bucket:
 - The bucket name must be unique to the whole world (not just your AWS account)
 - Terraform will store all of its state in the bucket, some of which is sensitive, so don't share access with anyone who doesn't need it
 - Terraform won't manage the bucket itself, just its contents

## Create all your infrastructure

1. Edit the file `terraform.tfvars` so that it references the Rabble Rouser instance you want to manage. The values that
are in there by default are specific for the project's staging instance at https://demo.rr-staging.click. You can also
override any of the variables in `variables.tf` if you don't like their default values.

2. Do a dry run first to see what terraform will do:

    ```
    terraform plan
    ```

3. Create the infrastructure: *Warning: this will cost you money, even if you have the AWS free tier!*

    ```
    terraform apply
    ```

## Re-run the provisioner

You might want to do this because the ansible code has changed, or to deploy the latest version of the app:

```sh
./re-deploy.sh
```

## To seed the database

Before the application can be useful, the database needs some seed data. The seed script can be run as part of the
provisioner, but because it is not idempotent (i.e. you should only run it once), you must opt-in to it:

```sh
terraform apply -var 'seed_database=true'
```

## Running it without a tfvars config file

If using a file is inconvenient (e.g. when running in a CI pipeline), you can use CLI flags or environment variables
instead (see the [terraform docs](https://www.terraform.io/intro/getting-started/variables.html) for more detail):

```sh
terraform apply -var 'route53_zone_id="ABC123"'
# OR
TF_VAR_route53_zone_id="ABC123" terraform apply
```

## To get SSH access to the EC2 instance

```sh
./ssh.sh
```
