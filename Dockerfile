FROM ubuntu:18.04
MAINTAINER Tom Christopoulos <tom.christopoulos@platform9.com>

ENV DEBIAN_FRONTEND=noninteractive \
    USER=root

RUN apt-get update && \
    apt-get install -y \
    curl \
    jq

COPY DO-dnsupdater.sh /DO-dnsupdater.sh

RUN chmod 0700 /DO-*
CMD ["/bin/bash","/DO-dnsupdater.sh"] 
