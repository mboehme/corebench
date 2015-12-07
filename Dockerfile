FROM ubuntu:14.04

###########
# 
# Installs CoREBench + Desktop environment
# Based on Dockerfile from Roberto H. Hashioka (git://github.com/rogaha/docker-desktop.git)
#
###########

MAINTAINER Marcel Boehme <marcel.boehme@acm.org>

RUN \
    apt-get update  \
        --quiet     \
    && apt-get upgrade -y

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME /root

# RUN apt-mark hold initscripts udev plymouth mountall
# RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl
# RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list

RUN \
  apt-get install \
        --yes       \
        --no-install-recommends \
        --no-install-suggests \
    autoconf        \
    autogen         \
    autopoint       \
    automake        \
    bison           \
    clang           \
    cvs             \
    gettext         \
    gcc             \
    git             \
    gnuplot         \
    gperf           \
    gzip            \
    lcov            \
    libtool         \
    make            \
    nasm            \
    patch           \
    perl            \
    rsync           \
    tar             \
    texinfo         \
    subversion      \
    vim             \
    wget            
 
 RUN apt-get install \
        --yes       \
        --no-install-recommends \
        --no-install-suggests \
    supervisor      \
    python-dev build-essential \
    openssh-server sudo net-tools \
    lxde-core lxde-icon-theme x11vnc xvfb screen openbox nodejs firefox \
    htop bmon nano lxterminal

#    firefox lxde-core lxterminal tightvncserver
#    firefox lxde-core lxterminal tightvncserver
#    ubuntu-desktop xorg lxde-core lxde-icon-theme x11vnc xvfb \
#    pwgen sudo net-tools openssh-server tightvncserver \
#    gtk2-engines-murrine ttf-ubuntu-font-family nano \
#    language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant \
#    nginx \
#    python-pip python-dev build-essential

RUN apt-get clean   \
  && rm -rf /var/lib/apt/lists/*


WORKDIR /root

#FIX problem with aclocal and pkg-config
ENV ACLOCAL_PATH /usr/share/aclocal
RUN \
  wget http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz \
  && tar -zxvf pkg-config-0.28.tar.gz \
  && cd pkg-config-0.28 \
  && ./configure --with-internal-glib && make && make install
#FIX problem with aclocal
RUN cp /usr/local/share/aclocal/* /usr/share/aclocal && mv /usr/local/share/aclocal /tmp

COPY corebench.tar.gz /root
RUN \
  tar -zxvf corebench.tar.gz >/dev/null 2>&1 \
  && mkdir corerepo
WORKDIR /root/corebench
RUN ./createCoREBench.sh compile-all make /root/corerepo
RUN ./createCoREBench.sh compile-all grep /root/corerepo
RUN ./createCoREBench.sh compile-all find /root/corerepo
## Installing coreutils will deplete the 10GB limit imposed by Docker
#RUN ./createCoREBench.sh compile-all core /root/corerepo

RUN \ 
     locale-gen en_US.UTF-8 \
  && locale-gen ru_RU.KOI8-R\
  && locale-gen tr_TR.UTF-8 \
  && locale-gen ja_JP.UTF-8 \
  && locale-gen en_HK.UTF-8 \
  && locale-gen zh_CN       \
  && localedef -i ja_JP -c -f SHIFT_JIS /usr/lib/locale/ja_JP.sjis

#Now fail if any problems
RUN ./createCoREBench.sh compile make /root/corerepo
RUN ./createCoREBench.sh compile grep /root/corerepo
RUN ./createCoREBench.sh compile find /root/corerepo
#RUN ./createCoREBench.sh compile core /root/corerepo
RUN ./executeTests.sh test-all make /root/corerepo
RUN ./executeTests.sh test-all grep /root/corerepo
RUN ./executeTests.sh test-all find /root/corerepo
#RUN ./executeTests.sh test-all core /root/corerepo

ADD startup.sh /
ADD supervisord.conf /
ADD password.txt /

EXPOSE 5800
EXPOSE 5900
EXPOSE 22

WORKDIR /
ENTRYPOINT ["/startup.sh"]