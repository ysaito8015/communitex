FROM elixir:1.10.1

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

RUN apt-get update && apt-get -y install apt-file && apt-file update
RUN apt-get -y upgrade

RUN apt-get -y install bash git vim sudo curl inotify-tools imagemagick

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

RUN apt-get -y install nodejs

ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID devel
RUN useradd -u $UID -g devel -m devel
RUN echo "devel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY --chown=devel:devel . /app

USER devel

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
