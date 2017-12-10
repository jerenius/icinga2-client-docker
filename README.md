# Why would you want to run Icinga2 client in a container anyway?

A judge question my liege. One could also ask why not? With Docker I can get Icinga2 client up and running
really fast and easy. If client goes fubar for some reason, I can just scrap it and spin up a new client.
All the monitoring related configuration is received from the master node. Client configuration is automaticly
done based on few environment variables set. Some preconfiguration at master end is required.

This image is quite useless without the master.

For the master node check out [my repository](https://github.com/jerenius/icinga2) or source of 
my inspiration, [jjethwa's icinga2 docker image](https://github.com/jjethwa/icinga2).

Usage:
and use the value for ICINGA2_TICKET_SALT -option. Installation ticket could actually be obtained within
the autoconfiguration process via Icinga2 Api, but I didn't get curl and JSON play nicely with with variables
yet. Working on it, when I have the time and inspiration. This workaround is easy enough for now.

Start your Icinga2 -container with command:
docker run --hostname CLIENT_NAME --name CLIENT_NAME \

You also need to 
-e ICINGA2_MASTER_HOST=<YOUR_MASTER> -e ICINGA2_CLIENT_FQDN=<CLIENT_NAME> \
-e ICINGA2_TICKET_SALT=4b723a43889df16fd0834e1122ee11d7579aa729 \
--add-host="<YOUR_MASTER>:<YOUR_MASTER_IP>" \
-p 5665:5665 -t jerenius/icinga2-client:latest

and let the magic of autoconfiguration happen.
