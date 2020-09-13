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
	&& yum -y install git

RUN set -x \
	&& yum -y upgrade ca-certificates \
	&& wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& rpm -ivh epel-release-latest-7.noarch.rpm

RUN set -x \
	&& cat /etc/yum.repos.d/epel.repo
	#&& rpm -ivh http://mirror.centos.org/altarch/7/os/armhfp/Packages/centos-userland-release-7-8.2003.0.el7.centos.armv7hl.rpm \
#	&& yum -y install htop
#RUN set -x \
#	&& wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
#	&& rpm -ivh epel-release-latest-7.noarch.rpm \
#	&& yum-config-manager --disable epel
	#&& yum -y --enable-repo="epel" install htop
#	&& yum -y install htop
