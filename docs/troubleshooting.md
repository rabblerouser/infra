# Troubleshooting

## Check the logs!

For any problem where the app isn't working properly, you may want to check the server logs. First you need to ssh on to
the server ([see here](../README.md#ssh-access) for how), then these commands might be useful:

 - `sudo journalctl -fu docker`: tail the docker daemon logs
 - `sudo tail -f /var/log/nginx/access.log`: tail the nginx access logs
 - `sudo tail -f /var/log/nginx/error.log`: tail the nginx error logs
 - `sudo docker logs -f <container>`: tail the application logs for a particular container

Bonus command: Use `sudo docker ps` to see the currently running docker containers. Add `-a` to see stopped containers
too, which are often (but not always) crashed apps.

## Common issues

Here are some common problems, and how to approach fixing them.

### Terraform wants to recreate some keys?

You might sometimes see terraform want to recreate the resource `aws_key_pair.ansible`, and modify some other resources
that depend on it. It's usually safe to just let it do this.

The key pair in question is the SSH keys used to get access to the EC2 instance for running ansible and configuring the
server. Currently we don't generate the keys dynamically - instead we rely on the SSH keys configured on your machine.
Because each person has their own SSH keys (hopefully!), if you were not the last person to run `terraform apply` on the
given infrastructure, then terraform will need to update the keys.

### Ansible fails with an 'UNREACHABLE' error

This might be because the server's IP address or fingerprint has change since last time you accessed it via SSH. This is
especially likely if the EC2 instance has been destroyed and recreated. Test this out by trying to SSH onto the server
([see here](../README.md#ssh-access)). If it says something about the host having changed, then you *probably* just want
to do `ssh-keygen -R <domain-name>` or `ssh-keygen -R <ip-address>`. **HOWEVER:** as the big warning message tells you,
this can also be caused by a malicious man-in-the-middle attack. If there's any chance of this (especially if you're on
a dodgy unsecured wifi network), then you should stop and try again from a safer place.

### Connection refused

If you see something like this, it might be a networking issue. Assuming the server is there, maybe check the AWS
security group rules, or the server firewall rules, and make sure the relevant ingress/access is allowed.

### No response from the server

If the server isn't responding at all, then it might just not be there. Try logging into the AWS console, go into EC2,
and check what instances are there.

### 502 Bad Gateway

This usually means that you are successfully connecting to the nginx proxy running on the server, but that nginx is not
getting a valid response from the application. I.e., the application (docker container) might have crashed, or it might
not have been deployed at all yet.

### The app loads but I can't sign up a new member

If the signup page loads successfully, but the form submission then fails, the most common cause is that the app hasn't
been seeded yet. Check this by opening up the network tab in the browser dev tools and refreshing the page. You should
see an XHR request to fetch branches. If that request is returning an empty array, then the application probably has not
been seeded with initial data yet. See [here](./new_environment.md#seed-the-app) for how to run the seeder.

### Can't log in to the admin dashboard

This is often caused by the same issue as signups not working (see above). Or perhaps you're just getting the credentials
wrong. Check the seed script in the `rabblerouser/core` codebase to see what the initial credentials are. Or try asking
around the team to make sure no one has changed them.

### Docker auth fails because IP addresses don't match
When running something related to Docker, if you see an x509 error where a certificate is only valid for IP addres 'X',
and not 'Y', then it probably means the server's IP address has changed and the Docker auth certificate needs to be
updated. Terraform should generate and upload the new certs automatically, but you may need to SSH onto the server and
manually restart the docker daemon. Ideally ansible should automatically restart Docker when the cert gets updated, but
at the moment it doesn't.
