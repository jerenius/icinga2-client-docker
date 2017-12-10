FROM debian:stretch

MAINTAINER Jere Virta 

ENV DEBIAN_FRONTEND=noninteractive \
    MASTER_HOST=icinga2

COPY content/ /

RUN apt-get update \
    && apt-get -qqy install --no-install-recommends \
       apt-utils \
       ca-certificates \
       cron \
       curl \
       debian-keyring \
       ethtool \
       gnupg \
       logrotate \
       nano \
       net-tools \
       procps \
       smartmontools \
       snmp \
       supervisor \
       sysstat \
       wget \
    && wget -O - https://packages.icinga.com/icinga.key | apt-key add - \
    && apt-get -qqy install --no-install-recommends \
       icinga2 \
       monitoring-plugins \
       monitoring-plugins-basic \
       monitoring-plugins-common \
       monitoring-plugins-standard \
       snmp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    

RUN chmod +x /opt/start.sh \
	     /opt/supervisor/*

EXPOSE 5665

ENTRYPOINT ["/opt/start.sh"]
    
    
