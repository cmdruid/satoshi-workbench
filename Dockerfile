FROM debian:bullseye-slim

## Define build arguments.
ARG HOME='/root/home'

## Install dependencies.
RUN apt-get update && apt-get install -y \
  curl git lsof man neovim netcat procps qrencode tmux

## Copy over runtime.
COPY image /
COPY config /config/
COPY home /root/home/

## Add bash aliases to .bashrc.
RUN BASHRC="$HOME/.bashrc" \
  && printf "\n[ -e $BASHRC ] && source $BASHRC\n\n" >> /root/.bashrc

## Uncomment this if you want to wipe all repository lists.
#RUN rm -rf /var/lib/apt/lists/*

## Setup Environment.
ENV PATH="$HOME/bin:/root/.local/bin:$PATH"

WORKDIR /root/home

ENTRYPOINT [ "entrypoint" ]
