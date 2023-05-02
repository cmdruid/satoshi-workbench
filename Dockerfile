FROM debian:bullseye-slim

## Define build arguments.
ARG DATA_PATH="/data"
ARG SHARE_PATH='/root/share'

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

## Uncomment this if you want to wipe all repository lists.
#RUN rm -rf /var/lib/apt/lists/*

## Copy over runtime.
COPY image /
COPY config /config/
COPY shared $SHARE_PATH

## Add custom profile to bashrc.
RUN PROFILE="$SHARE_PATH/.profile" \
  && printf "\n[ -f $PROFILE ] && . $PROFILE\n\n" >> /root/.bashrc

## Setup Environment.
ENV PATH="$SHARE_PATH/bin:/root/.local/bin:$PATH"
ENV DATA_PATH=${DATA_PATH}
ENV SHARE_PATH=${SHARE_PATH}

WORKDIR /root

ENTRYPOINT [ "/entrypoint.sh" ]
