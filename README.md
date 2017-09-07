# namesilo_ddns
Dynamic DNS with NameSilo 

This is a Bash script to update Namesilo's DNS record when IP changed. Set to run this script as cronjob in your system.

Uses DNS instead of HTTP to detect IP changes for better security. TTL reduced to 3600 (Namesilo's lowest) as it's supposed to be dynamic ...

Tested in Fedora 23, CentOS 7 and Ubuntu 14.04.

### Troubleshooting
* If you see this error

      dig: command not found

  run (on Ubuntu and Debian):

      sudo apt-get install dnsutils
    
  on CentOS:

      sudo yum install bind-utils

* If you see this error

      xmllint: command not found

  run (on Ubuntu and Debian):

      sudo apt-get install libxml2-utils
    
  on CentOS:

      sudo yum install libxml2
