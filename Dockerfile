FROM debian:buster-slim as base
MAINTAINER Matus Hajdu

ARG DOCKERIZE_VERSION=v0.6.1

ENV PYTHONUNBUFFERED 1 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    SHELL=/bin/bash

# mirror and base python and system requirements
RUN apt-get -y update \
    && apt-get -y install python3 \
    python3-pip \
    uwsgi-plugin-python3 \
    libpq-dev \
    virtualenv \
    locales \
    git-all \
    curl \
    wget \
    unixodbc \
    unixodbc-dev \
    graphviz-dev \
    graphviz \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /app

COPY ./requirements.txt /requirements.txt

ENV VENV=/opt/venv
RUN virtualenv --python=python3 $VENV
ENV PATH="$VENV/bin:$PATH"


RUN pip3 install -r /requirements.txt

COPY . /


RUN adduser --disabled-password --gecos '' user
USER user

