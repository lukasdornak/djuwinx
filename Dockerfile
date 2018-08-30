FROM python:3.7-slim-stretch

LABEL name="djuwinx"
LABEL maintainer="Lukáš Dorňák <lukasdornak@gmail.com>"

ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED 1

RUN apt-get update \
  && apt-get -y install build-essential libpcre3 libpcre3-dev python3-dev nginx sqlite3 \
  && apt-get -y autoremove \
  && apt-get -y clean

RUN pip3 install --no-cache-dir uwsgi Django==2.1.0

COPY djuwinx_nginx.conf /etc/nginx/sites-available/

RUN ln -s -f /etc/nginx/sites-available/djuwinx_nginx.conf /etc/nginx/sites-enabled/default \
  && mkdir -p /var/log/uwsgi/ && touch /var/log/uwsgi/djuwinx.log

COPY uwsgi_params djuwinx_uwsgi.ini /app/

EXPOSE 80
