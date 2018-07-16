FROM ubuntu:18.04
MAINTAINER Tom Christopoulos <tom.christopoulos@platform9.com>

ENV DEBIAN_FRONTEND=noninteractive \
    USER=root \
    REPO_DIR=/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    jq

COPY DO-dnsupdater.sh /DO-dnsupdater.sh
COPY DO-ENV /DO-ENV

RUN chmod 0700 /DO-*
CMD ["/bin/bash","/DO-dnsupdater.sh"] 
