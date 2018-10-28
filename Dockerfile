FROM python:3.7-alpine3.8

LABEL name="djuwinx"
LABEL maintainer="Lukáš Dorňák <lukasdornak@gmail.com>"

ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED 1

RUN apk update; \
    apk add --update --no-cache nginx; \
    apk add --update --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		linux-headers \
		pcre \
		pcre-dev; \
	pip3 install uwsgi Django==2.1.0; \
	apk del .build-deps;

RUN mkdir -p /var/log/uwsgi/ \
    && touch /var/log/uwsgi/djuwinx.log \
    && mkdir -p /run/nginx \
    && rm /etc/nginx/conf.d/default.conf

COPY djuwinx_nginx.conf /etc/nginx/conf.d/djuwinx_nginx.conf

COPY djuwinx_uwsgi.ini /etc/uwsgi/djuwinx_uwsgi.ini

EXPOSE 80
