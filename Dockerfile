FROM resin/rpi-raspbian

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y apache2 python sqlite3

ADD assets /assets

RUN mkdir -p /usr/lib/cgi-bin && \
  mv /assets/*.py /usr/lib/cgi-bin/ && \
  chmod +x /usr/lib/cgi-bin/*.py && \
  chown www-data:www-data /usr/lib/cgi-bin/*.py && \
  mv /assets/apache.conf /etc/apache2/sites-enabled/000-default.conf

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

EXPOSE 80
