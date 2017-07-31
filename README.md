# centos-asterisk13
Dockerfile for building an image from CentOS x86_64 with Asterisk 13.  You will want to mount a volume with your configuration
files to /usr/local/etc/asterisk/.

While you can use the resultant image from the Dockerfile, you will get a substantially smaller image (by 117MB) by using the Makefile.  
It uses the first image as a builder image, copies out the artifacts, and builds another image without the dev tools installed.
