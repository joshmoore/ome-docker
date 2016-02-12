#!/bin/bash

# Setup and run omero

set -eux

echo Downloading ${1}
OMERO_ZIP=`echo "$1" | rev | cut -d / -f 1 | rev`

curl -o ~omero/$OMERO_ZIP.zip \
    http://downloads.openmicroscopy.org/omero/5.2.1/artifacts/$OMERO_ZIP.zip && \
    unzip -d /home/omero $OMERO_ZIP.zip && \
    ln -s ~omero/$OMERO_ZIP ~omero/OMERO.py && \
    rm $OMERO_ZIP.zip

virtualenv ~omero/omeropy-virtualenv --system-site-packages

# Get pip to download and install requirements:
source ~omero/omeropy-virtualenv/bin/activate
pip install --upgrade pip
pip install --upgrade 'Pillow<3.0'
pip install --upgrade -r ~omero/OMERO.py/share/web/requirements-py27-nginx.txt

# configure nginx
~omero/OMERO.py/bin/omero config set omero.web.application_server wsgi-tcp
~omero/OMERO.py/bin/omero web config nginx > ~omero/omero-web.conf.tmp

~omero/OMERO.py/bin/omero web start
sleep 5
ps aux | grep gunicorn

sudo -i
sed -i.bak -re 's/( default_server.*)/; #\1/' /etc/nginx/nginx.conf
cp ~omero/omero-web.conf.tmp > /etc/nginx/conf.d/omero-web.conf

supervisorctl restart nginx