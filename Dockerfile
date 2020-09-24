FROM centos:centos7


# Set the timezone
ENV TZ Australia/Canberra

RUN set -x \
	&& yum -y update

# Install base tools
RUN set -x \
	&& yum -y install wget \
	&& yum -y install man \
	&& yum -y install man-pages \
	&& yum -y install vim \
	&& yum -y install gvim \
	&& yum -y install gcc \
	&& yum -y install gcc-c++ \
	&& yum -y install httpd \
	&& yum -y install git \
	&& yum -y install openssh-server

# Manually install htop from RPM because no EPEL release for armhfp architecture
RUN set -x \
	&& wget https://armv7.dev.centos.org/repodir/epel-pass-1/htop/2.2.0-3.el7/armv7hl/htop-2.2.0-3.el7.armv7hl.rpm \
	&& yum -y localinstall htop-2.2.0-3.el7.armv7hl.rpm

