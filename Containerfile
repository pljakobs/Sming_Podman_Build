FROM fedora:latest

# ------------------------------------------------------------------------------
# Pre-requisites
# ------------------------------------------------------------------------------

RUN yum -y update;\
    yum install -y git tzdata vim bzip2 python3-tkinter; \
    TZ=Europe/Berlin

# ------------------------------------------------------------------------------
# Fetch Sming and install tools
# ------------------------------------------------------------------------------

ARG SMING_REPO=https://github.com/SmingHub/Sming
ARG SMING_BRANCH=develop
ARG INSTALL_ARGS=all

RUN git clone $SMING_REPO -b $SMING_BRANCH /opt/sming

WORKDIR "/opt/sming"

RUN Tools/install.sh $INSTALL_ARGS
RUN echo ". /opt/sming/Tools/export.sh" >> ~/.bashrc

COPY ./make.sh /usr/bin
RUN chmod +x /usr/bin/make.sh

#
#run a build for the esp32 platform to fetch and precompile all modules
#######################################################################

WORKDIR /opt/sming/samples/Basic_WiFi

#run it once for the esp32c3
ARG C_BUILDARGS="-j8 STRICT=1 SMING_SOC=esp32c3"
ARG C_SOC="esp32c3"
ARG C_TARGET=""

RUN /usr/bin/make.sh

#clean the *application* binary
ARG C_TARGET="clean" 

RUN /usr/bin/make.sh

#
#and once for the extensa based esp32
#####################################

ARG C_BUILDARGS="-j8 STRICT=1 SMING_SOC=esp32"
ARG C_SOC="esp32"
ARG C_TARGET=""

RUN /usr/bin/make.sh

ARG C_TARGET="clean" 

RUN /usr/bin/make.sh

#
#and once for host 
##################

ARG C_BUILDARGS="-j8 STRICT=1 SMING_SOC=host"

ARG C_SOC="esp32"
ARG C_TARGET=""

RUN /usr/bin/make.sh

ARG C_TARGET="clean" 

RUN /usr/bin/make.sh

#
#build host tests
#################

WORKDIR /opt/sming/tests/HostTests/
ARG C_BUILDARGS="-j8 STRICT=1 SMING_SOC=host"

ARG C_SOC="esp32"
ARG C_TARGET=""

RUN /usr/bin/make.sh

ARG C_TARGET="clean" 

RUN /usr/bin/make.sh


ENTRYPOINT ["/usr/bin/make.sh"]

