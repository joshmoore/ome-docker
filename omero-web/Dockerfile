FROM openmicroscopy/omero-ssh-systemd
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

# OMERO.py prerequesties
RUN yum install -y epel-release && \
    yum clean all

RUN yum install -y unzip && \
    yum clean all

RUN yum install -y \
    python-pip python-devel python-virtualenv \
    numpy scipy python-matplotlib python-tables && \
    yum clean all
  
RUN curl -o /etc/yum.repos.d/zeroc-ice-el7.repo \
    http://download.zeroc.com/Ice/3.5/el7/zeroc-ice-el7.repo

RUN yum install -y ice ice-python ice-servers && \
    yum clean all

# install Pillow via pip
RUN yum install -y \
    zlib-devel \
    libjpeg-devel \
    gcc && \
    yum clean all

RUN yum install -y nginx && \
    yum clean all

EXPOSE 80

# AS OMERO user
USER omero
ENV HOME /home/omero
WORKDIR /home/omero

ADD ./download.sh /home/omero/download.sh

CMD bash -C '/home/omero/download.sh https://ci.openmicroscopy.org/job/OMERO-DEV-merge-build/ICE=3.5,jdk=8_LATEST,label=octopus/lastSuccessfulBuild/artifact/src/target/OMERO.py-5.2.1-534-6ee6dde-ice35-b233.zip';'bash'