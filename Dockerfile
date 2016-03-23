# Base OS
FROM centos:centos6
MAINTAINER bryanayers+Dockerfile@gmail.com

# Env setup
ENV HOME /root
WORKDIR ~/

# Build deps
RUN \
	yum -y update && \
	yum -y install epel-release &&\
	yum -y install \
		autoconf \
		automake \
		bzip2 \
		gcc-c++ \
		jansson-devel \
		libtool \
		libuuid-devel \
		libxml2-devel \
		ncurses-devel \
		make \
		sqlite-devel \
		tar \
		uuid-devel \
		wget && \
	yum clean all

# Asterisk and dependencies install
RUN \
	wget http://www.pjsip.org/release/2.4.5/pjproject-2.4.5.tar.bz2 && \
	tar -xjf pjproject-2.4.5.tar.bz2 && \
	cd pjproject-2.4.5 && \
	./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG -mtune=generic' && \
	make dep && \
	make && \
	make install && \
	ldconfig && \
	#ldconfig -p | grep pj && \
	cd .. && \
	export PKG_CONFIG_PATH=/usr/lib/pkgconfig && \

	wget http://downloads.asterisk.org/pub/telephony/certified-asterisk/asterisk-certified-13.1-cert4.tar.gz && \
	tar -xzf asterisk-certified-13.1-cert4.tar.gz && \
	cd asterisk-certified-13.1-cert4 && \
	./configure && \

	make menuselect.makeopts && \
	menuselect/menuselect \
		--disable-category MENUSELECT_ADDONS \
		--disable-category MENUSELECT_MOH \
		--disable-category MENUSELECT_EXTRA_SOUNDS \
		--disable-category MENUSELECT_AGIS \
		--disable-category MENUSELECT_TESTS \
		--disable BUILD_NATIVE \
		--enable chan_pjsip \
			menuselect.makeopts && \
	make && \
	make install && \
	ldconfig && \
	#ldconfig -p | grep libast && \
	#make samples && \
	rm -Rf /etc/asterisk && \
	cd .. && \

	# Cleanup
	rm -Rf pjproject* && \
	rm -Rf asterisk* && \
	rm -f *.tar.*

EXPOSE \
	5060-5061 \
	10000-10999

CMD ["/usr/sbin/asterisk", "-cv"]
