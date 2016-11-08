#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM alpine:3.4
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV GOPATH="/go" \
    VERSION="0.5.0"

#------------------------------------------------------------------------------
# Install docker:
#------------------------------------------------------------------------------

RUN apk add -U --no-cache -t dev git go make \
    && mkdir -p ${GOPATH}/src/github.com/prometheus \
    && cd ${GOPATH}/src/github.com/prometheus \
    && git clone https://github.com/prometheus/alertmanager.git \
    && cd alertmanager && git checkout v${VERSION} -b build \
    && make build && mv alertmanager /usr/local/bin \
    && apk del --purge dev && rm -rf /tmp/* /go

#------------------------------------------------------------------------------
# Volumes:
#------------------------------------------------------------------------------

VOLUME [ "/etc/alertmanager", \
         "/var/lib/alertmanager" ]

#------------------------------------------------------------------------------
# Command:
#------------------------------------------------------------------------------

ENTRYPOINT [ "alertmanager" ]
CMD        [ "-config.file=/etc/alertmanager/config.yml", \
             "-storage.path=/var/lib/alertmanager" ]
