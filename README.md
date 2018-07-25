# pywps
Dockerized pywps

see https://hub.docker.com/r/onaci/pywps-base/

use this base image like:

```
FROM onaci/pywps-base

RUN apt-get update \
	&& apt-get install -yq  \
	cdo libfreetype6-dev libgdal-dev libhdf5-dev liblapack-dev \
	libnetcdf-dev libopenblas-dev libpq-dev  netcdf-bin \
        gfortran

WORKDIR /srv/ncwps/src

COPY requirements.txt /srv/ncwps/src/
RUN pip install -r /srv/ncwps/src/requirements.txt

COPY . /srv/ncwps/src/

# setup for gunicorn
#RUN cp pywps.wsgi ncwps.py \
#	&& echo "/srv/ncwps/src" > /srv/ncwps/venv/lib/python2.7/site-packages/ncwps.pth

RUN mkdir -p /srv/ncwps/conf \
   && cd /srv/ncwps/conf \
   && cp /srv/ncwps/src/pywps.cfg . \
   && cp /srv/ncwps/src/deployment.cfg . 

RUN mkdir -p /srv/ncwps/outputs \
   && cd /srv/ncwps/outputs \
   && chgrp www-data . \
   && chmod 775 .

CMD gunicorn --bind 0.0.0.0:80 --pythonpath /src/ncwps/src ncwps:application

# this cases lots of log entries
HEALTHCHECK --interval=60s --timeout=3s \
        CMD curl --fail "http://0.0.0.0/ncwps/?service=WPS&request=GetCapabilities" || exit 1

```
