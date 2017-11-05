# Troubleshooting

## Check the logs!

For any problem where the app isn't working properly, you may want to check the application logs. For Dockerised apps
running on the EC2 instance, see [see here](../README.md#reading-the-app-logs). For lambdas, log into the AWS console
and find their logs in Cloudwatch.

## Common issues

Here are some common problems, and how to approach fixing them.

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

This usually means that you are successfully connecting to the elastic load balancer, but that the ELB is not getting a
valid response from the application. I.e., the application (docker container) might have crashed, or it might not have
been deployed at all yet.

### The app loads but I can't sign up a new member

If the signup page loads successfully, but the form submission then fails, the most common cause is that the app hasn't
been seeded yet. Check this by opening up the network tab in the browser dev tools and refreshing the page. You should
see an XHR request to fetch branches. If that request is returning an empty array, then the application probably has not
been seeded with initial data yet. See [here](./new_environment.md#seed-the-app) for how to run the seeder.

### Can't log in to the admin dashboard

This is often caused by the same issue as signups not working (see above). Or perhaps you're just getting the credentials
wrong. Check the seed script in the `rabblerouser/core` codebase to see what the initial credentials are. Or try asking
around the team to make sure no one has changed them.
