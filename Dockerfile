FROM debian:8
MAINTAINER Oldrich Vykydal sysadmin@klokantech.com
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && apt-get -qq -y install \
    curl \
    libedit2 \
    libjemalloc1 \
    build-essential \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

RUN curl -J -L -s -k \
    'https://repo.varnish-cache.org/pkg/5.0.0/varnish_5.0.0-1_amd64.deb' \
    -o /tmp/varnish_5.0.0-1_amd64.deb \
&& dpkg -i /tmp/varnish_5.0.0-1_amd64.deb \
&& rm /tmp/varnish_5.0.0-1_amd64.deb

ADD start.sh /start.sh

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      1024m
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600

CMD /start.sh
EXPOSE 80
