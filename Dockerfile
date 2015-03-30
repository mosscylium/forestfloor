FROM resin/rpi-raspbian

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y apache2 python sqlite3

ADD assets /assets

RUN mkdir -p /usr/lib/cgi-bin
RUN mv /assets/*.py /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*.py
RUN chown www-data:www-data /usr/lib/cgi-bin/*.py


ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

EXPOSE 80
