# Why would you want to run Icinga2 client in a container anyway?

A judge question my liege. One could also ask why not? With Docker I can get Icinga2 client up and running
really fast and easy. If client goes fubar for some reason, I can just scrap it and spin up a new client.
All the monitoring related configuration is received from the master node. Client configuration is automaticly
done based on few environment variables set. Some preconfiguration at master end is required.

This image is quite useless without the master.

For the master node check out [my repository](https://github.com/jerenius/icinga2) or source of 
my inspiration, [jjethwa's icinga2 docker image](https://github.com/jjethwa/icinga2).


At the client-side you need to setup few variables;
MASTER_HOST
MASTER_IP
CLIENT_HOST
API_USER
API_PWD

Startup script request a install ticket from master via API, and configures
icinga2 -client automatically.

At the master-side you need to configure zone and endpoint -objects for the client.

At the moment this container image only support one satellite per zone. I might
change that in the future.
