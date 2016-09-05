# This Dockerfile is derived from https://github.com/grpc/grpc-docker-library/blob/master/0.10/cxx/Dockerfile
# (which is the most recent at this time), mainly CentOS-ifying it and upping the version.
# Please see original copyright notice following the build instructions.

FROM centos:7

RUN yum -y update; yum clean all
RUN yum -y install epel-release
RUN \
#	yum -y groupinstall "Development Tools" &&\
	yum -y install \
		autoconf \
		automake \
		curl \
		gcc \
		gcc-c++ \
		gflags-devel \
		git \
		glib2-devel \
		glibc-common \
		glibc-devel \
		gtest-devel \
		libtool \
		make \
		unzip \
		wget \
		which \
		xz-devel \
		zlib-devel &&\
	yum clean all

# Install protoc 3.0.0
ENV PROTOC_RELEASE_TAG 3.0.0

RUN \
	wget https://github.com/google/protobuf/releases/download/v3.0.0/protoc-${PROTOC_RELEASE_TAG}-linux-x86_64.zip &&\
	unzip protoc-${PROTOC_RELEASE_TAG}-linux-x86_64.zip -d /usr/local &&\
	rm -f protoc-${PROTOC_RELEASE_TAG}-linux-x86_64.zip

# Build grpc
ENV GRPC_RELEASE_TAG v1.0.0

RUN git clone https://github.com/grpc/grpc.git /usr/local/src/grpc
RUN \
	cd /usr/local/src/grpc &&\
	git checkout tags/${GRPC_RELEASE_TAG} &&\
	git submodule update --init --recursive

RUN \
	cd /usr/local/src/grpc/third_party/protobuf &&\
	./autogen.sh &&\
	./configure --prefix=/usr &&\
	make -j12 && make check && make install && make clean

RUN cd /usr/local/src/grpc && make install



# Copyright 2015, Google Inc. # All rights reserved. # # Redistribution and use in source and binary forms, with or without # modification, are permitted provided that the following conditions are # met: # #     * Redistributions of source code must retain the above copyright # notice, this list of conditions and the following disclaimer. #     * Redistributions in binary form must reproduce the above # copyright notice, this list of conditions and the following disclaimer # in the documentation and/or other materials provided with the # distribution. #     * Neither the name of Google Inc. nor the names of its # contributors may be used to endorse or promote products derived from # this software without specific prior written permission. # # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS # "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT # LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR # A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT # OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, # SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, # DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.