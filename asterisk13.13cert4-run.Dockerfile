# Base OS
FROM centos:7
MAINTAINER info@incendonet.com

# Env setup
ENV HOME /root
WORKDIR /usr/local/

# Build deps
RUN \
	yum -y update && \
	yum -y install epel-release && \
	yum -y install \
		bzip2 \
		jansson \
		libuuid \
		libxml2 \
		ncurses \
		sqlite \
		tar \
		uuid && \
	yum clean all

# Copy in Asterisk and dependencies
COPY software/lib /usr/local/lib/
COPY software/sbin /usr/local/sbin/
COPY software/share/man/man8 /usr/local/share/man/man8/
COPY software/var/lib/asterisk /usr/local/var/lib/asterisk/

# Initialize
RUN \
    mkdir -p /usr/local/etc/asterisk && \
    mkdir -p /usr/local/var/run/asterisk

EXPOSE \
	5060-5061 \
	10000-10999

CMD ["/usr/local/sbin/asterisk", "-cv"]
