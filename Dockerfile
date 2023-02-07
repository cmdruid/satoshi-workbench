FROM debian:bullseye-slim

## Define build arguments.
ARG ROOTHOME='/root/home'

## Install dependencies.
RUN apt-get update && apt-get install -y \
  curl git lsof man neovim netcat procps qrencode tmux

## Copy over binaries.
COPY build/out/* /tmp/bin/

WORKDIR /tmp

## Unpack and/or install binaries.
RUN for file in /tmp/bin/*; do \
  if ! [ -z "$(echo $file | grep .tar.)" ]; then \
    echo "Unpacking $file to /usr ..." \
    && tar --wildcards --strip-components=1 -C /usr -xf $file \
  ; else \
    echo "Moving $file to /usr/local/bin ..." \
    && chmod +x $file && mv $file /usr/local/bin/ \
  ; fi \
; done

## Clean up temporary files.
RUN rm -rf /tmp/* /var/tmp/*

## Copy over runtime.
COPY image /
COPY config /config/
COPY home /root/home/

## Add custom profile to bashrc.
RUN PROFILE="$ROOTHOME/.profile" \
  && printf "\n[ -f $PROFILE ] && . $PROFILE\n\n" >> /root/.bashrc

## Uncomment this if you want to wipe all repository lists.
#RUN rm -rf /var/lib/apt/lists/*

## Setup Environment.
ENV PATH="$ROOTHOME/bin:/root/.local/bin:$PATH"

WORKDIR /root/home

ENTRYPOINT [ "entrypoint" ]
