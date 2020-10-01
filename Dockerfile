FROM centos:centos7

LABEL maintainer="s3641721@student.rmit.edu.au"

# Set the timezone
ENV TZ Australia/Canberra

# Set up build directory and install all base tools with yum
RUN set -x \
	&& cd ~ \
	&& mkdir build \
	&& cd build \
	&& yum -y update \
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
	&& yum -y install make \
	&& yum -y install sudo \
	&& yum -y install clang

# Manually install htop from RPM because no EPEL release for armhfp architecture
RUN set -x \
	&& wget https://armv7.dev.centos.org/repodir/epel-pass-1/htop/2.2.0-3.el7/armv7hl/htop-2.2.0-3.el7.armv7hl.rpm \
	&& yum -y localinstall htop-2.2.0-3.el7.armv7hl.rpm

# Manually download berryconda3
RUN set -x \
	&& wget https://github.com/jjhelmus/berryconda/releases/download/v2.0.0/Berryconda3-2.0.0-Linux-armv7l.sh \
	&& chmod +x Berryconda3-2.0.0-Linux-armv7l.sh

# Download ncurses to compile from source
RUN set -x \
	&& wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz \
	&& tar xf ncurses-6.1.tar.gz \
	&& cd ncurses-6.1 \
	&& ./configure --prefix=/usr/local CXXFLAGS="-fPIC" CFLAGS="-fPIC" \
	&& make -j \
	&& make install

# Compile zsh from source
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
	&& make install \
	&& echo '/usr/local/bin/zsh' >> /etc/shells

# Generate keys for SSHD
RUN set -x \
	&& /usr/bin/ssh-keygen -A

# Add start script for httpd
ADD start-httpd /root

# Add start script for sshd
ADD start-sshd /root

RUN set -x \
	&& chmod +x /root/start-httpd \
	&& chmod +x /root/start-sshd

# Create new user fred
RUN set -x \
	&& useradd -m -s /usr/local/bin/zsh -G wheel fred \
	&& echo "fred:Password1" | chpasswd

USER fred
RUN set -x \
	&& touch ~/.zshrc \
	&& git config --global user.name "Robert Beardow" \
	&& git config --global user.email "s3641721@student.rmit.edu.au" \
	&& sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
	&& git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

USER root

# Expose port 80 for httpd
EXPOSE 80

# Expose port 22 for sshd
EXPOSE 22	

# Manual stuff. 
# Berryconda.
# visudo wheel group
# Disable ssh



