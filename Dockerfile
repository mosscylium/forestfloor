FROM cannyos/ubuntu
MAINTAINER Peter Birley <petebirley@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DISTRO ubuntu

RUN apt-get update && \
	apt-get install -y nginx supervisor ca-certificates

ADD https://raw.githubusercontent.com/CannyOS/COS-Branding/master/Graphics/interface/errors/402.html /usr/share/nginx/html/402.html
ADD https://raw.githubusercontent.com/CannyOS/COS-Branding/master/Graphics/interface/errors/403.html /usr/share/nginx/html/403.html
ADD https://raw.githubusercontent.com/CannyOS/COS-Branding/master/Graphics/interface/errors/404.html /usr/share/nginx/html/404.html
ADD https://raw.githubusercontent.com/CannyOS/COS-Branding/master/Graphics/interface/errors/501.html /usr/share/nginx/html/501.html
ADD https://raw.githubusercontent.com/CannyOS/COS-Branding/master/Graphics/interface/errors/502.html /usr/share/nginx/html/502.html
ADD https://raw.githubusercontent.com/CannyOS/COS-Branding/master/Graphics/interface/errors/503.html /usr/share/nginx/html/503.html
ADD https://raw.githubusercontent.com/CannyOS/COS-Branding/master/Graphics/interface/errors/generic.html /usr/share/nginx/html/generic.html
RUN chown www-data /usr/share/nginx/html/*

ADD nginx/bedrock-proxy.nginx.conf /etc/nginx/sites-available/bedrock-proxy

ADD supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD /start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

EXPOSE 80
