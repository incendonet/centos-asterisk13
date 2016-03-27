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
<<<<<<< HEAD
	./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG' && \
=======
	./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG -mtune=generic' && \
>>>>>>> Asterisk13.1-cert4_PJSIP2.4.5
	make dep && \
	make && \
	make install && \
	ldconfig && \
	#ldconfig -p | grep pj && \
	cd .. && \
	export PKG_CONFIG_PATH=/usr/lib/pkgconfig && \

<<<<<<< HEAD
	wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13.5.0.tar.gz && \
	tar -xzf asterisk-13.5.0.tar.gz && \
	cd asterisk-13.5.0 && \
=======
	wget http://downloads.asterisk.org/pub/telephony/certified-asterisk/asterisk-certified-13.1-cert4.tar.gz && \
	tar -xzf asterisk-certified-13.1-cert4.tar.gz && \
	cd asterisk-certified-13.1-cert4 && \
>>>>>>> Asterisk13.1-cert4_PJSIP2.4.5
	./configure && \

	make menuselect.makeopts && \
<<<<<<< HEAD
	menuselect/menuselect \
		--disable-category MENUSELECT_ADDONS \
		--disable-category MENUSELECT_MOH \
		--disable-category MENUSELECT_EXTRA_SOUNDS \
		--disable-category MENUSELECT_AGIS \
		--disable-category MENUSELECT_TESTS \
		--disable BUILD_NATIVE \
		--enable chan_pjsip \
=======
	menuselect/menuselect && \
		--disable-category MENUSELECT_ADDONS && \
		--disable-category MENUSELECT_CORE_SOUNDS && \
		--disable-category MENUSELECT_MOH && \
		--disable-category MENUSELECT_EXTRA_SOUNDS && \
		--disable-category MENUSELECT_AGIS && \
		--disable-category MENUSELECT_TESTS && \
		--enable chan_pjsip && \
>>>>>>> c2b9ac76c173dbdfef16b9602942b7f9cd74d299
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
