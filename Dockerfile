FROM debian:jessie

RUN apt-get update \
    && apt-get install -yq git vim-tiny \
    python-pip python-virtualenv python-dev \
    libxml2-dev libxslt1-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/ncwps/src
RUN pip install --upgrade pip setuptools \
    && pip install gunicorn \
    && pip install -e git+https://github.com/geopython/pywps.git@4.0.0#egg=pywps


# Patch pywps - https://github.com/geopython/pywps/pull/311
COPY pullrequest-311.patch .
RUN cd /srv/ncwps/src/src/pywps/ \
    && patch -p1 < /srv/ncwps/src/pullrequest-311.patch

# Patch pywps to add os-environ interpolation - https://github.com/geopython/pywps/pull/365
COPY pullrequest-365.patch .
RUN cd /srv/ncwps/src/src/pywps/ \
    && patch -p1 < /srv/ncwps/src/pullrequest-365.patch
