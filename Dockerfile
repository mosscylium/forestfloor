FROM resin/rpi-raspbian

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

ADD /start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

EXPOSE 80
