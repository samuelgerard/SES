# SES
A basic linux-based security script(s)/application!

***Warning***
This program assumes the following:
- You're in root (or root privileges) as you're running it
- You've made a

# Purpose
- Quickly and efficiently secure your remote server on a fresh startup
- Provide a basic security configuration to work off of

**NOTICE: this is a base template for simple security appending, specific needs are up to the sys admin/user**



Current tools and protocols used:
- Net-tools (used for looking for certain parameters to determine the activation of certain security configurations)
- Snort
- UFW (uncomplicated firewall)
- Fail2ban


# How to use
After spinning up your server and connecting to it, execute the following string of commands:

`git clone https://github.com/samuelgerard/SES.git`

`cd SES`

`chmod +x secure_server_basic.sh`

`./secure_server_basic.sh`
