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
	&& yum -y install openssh-server \
	&& yum -y install bzip2 \
	&& yum -y install make

# Manually install htop from RPM because no EPEL release for armhfp architecture
RUN set -x \
	&& wget https://armv7.dev.centos.org/repodir/epel-pass-1/htop/2.2.0-3.el7/armv7hl/htop-2.2.0-3.el7.armv7hl.rpm \
	&& yum -y localinstall htop-2.2.0-3.el7.armv7hl.rpm

# Manually download berryconda3
RUN set -x \
	&& wget https://github.com/jjhelmus/berryconda/releases/download/v2.0.0/Berryconda3-2.0.0-Linux-armv7l.sh \
	&& chmod +x Berryconda3-2.0.0-Linux-armv7l.sh

# Download zsh to compile from source
RUN set -x \
	&& wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz \
	&& tar xf ncurses-6.1.tar.gz \
	&& cd ncurses-6.1 \
	&& ./configure --prefix=/usr/local CXXFLAGS="-fPIC" CFLAGS="-fPIC" \
	&& make -j \
	&& make install
	
RUN set -x \
	&& wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download \
	&& tar xf zsh.tar.xz \
	&& cd zsh-5.7.1 \
	&& ./configure \
		--prefix="/usr/local" \
		--with-tcsetpgrp \
		CPPFLAGS="-I/usr/local/include" \
		LDFLAGS="-L/usr/local/lib" \
	&& make -j \
	&& make install

	

