#!/bin/bash
set -e


export BEDROCK_PROXY_PORT=80
export BEDROCK_PROXY_NAME=surface
echo "CannyOS: Bedrock: Proxy: Port: $BEDROCK_PROXY_PORT"
echo "CannyOS: Bedrock: Proxy: Name: $BEDROCK_PROXY_NAME"


BEDROCK_CRUST_HOST_PORT_ARRAY=${BEDROCKCRUST_PORT_80_TCP#tcp://}
BEDROCK_CRUST_HOST_PORT_ARRAY=(${BEDROCK_CRUST_HOST_PORT_ARRAY//:/ })
while ! echo 'CannyOS_Bedrock:Crust is  now UP' | nc ${BEDROCK_CRUST_HOST_PORT_ARRAY[0]} ${BEDROCK_CRUST_HOST_PORT_ARRAY[1]}; do sleep 1; done
export BEDROCK_CRUST_HOST=${BEDROCK_CRUST_HOST_PORT_ARRAY[0]}
export BEDROCK_CRUST_PORT=${BEDROCK_CRUST_HOST_PORT_ARRAY[1]}
echo "CannyOS: Bedrock: Crust: Up: $BEDROCK_CRUST_HOST:$BEDROCK_CRUST_PORT"


export BEDROCK_STATIC_HOST=${BEDROCK_CRUST_HOST_PORT_ARRAY[0]}
export BEDROCK_STATIC_PORT=${BEDROCK_CRUST_HOST_PORT_ARRAY[1]}


BEDROCK_TERMINAL_HOST_PORT_ARRAY=${BEDROCKTERMINAL_PORT_8000_TCP#tcp://}
BEDROCK_TERMINAL_HOST_PORT_ARRAY=(${BEDROCK_TERMINAL_HOST_PORT_ARRAY//:/ })
while ! echo 'CannyOS_Bedrock:Terminal is  now UP' | nc ${BEDROCK_TERMINAL_HOST_PORT_ARRAY[0]} ${BEDROCK_TERMINAL_HOST_PORT_ARRAY[1]}; do sleep 1; done
export BEDROCK_TERMINAL_HOST=${BEDROCK_TERMINAL_HOST_PORT_ARRAY[0]}
export BEDROCK_TERMINAL_PORT=${BEDROCK_TERMINAL_HOST_PORT_ARRAY[1]}
echo "CannyOS: Bedrock: Terminal: Up: $BEDROCK_TERMINAL_HOST:$BEDROCK_TERMINAL_PORT"

BEDROCK_GIT_HOST_PORT_ARRAY=${BEDROCKGIT_PORT_80_TCP#tcp://}
BEDROCK_GIT_HOST_PORT_ARRAY=(${BEDROCK_GIT_HOST_PORT_ARRAY//:/ })
while ! echo 'CannyOS_Bedrock:Git is  now UP' | nc ${BEDROCK_GIT_HOST_PORT_ARRAY[0]} ${BEDROCK_GIT_HOST_PORT_ARRAY[1]}; do sleep 1; done
export BEDROCK_GIT_HOST=${BEDROCK_GIT_HOST_PORT_ARRAY[0]}
export BEDROCK_GIT_PORT=${BEDROCK_GIT_HOST_PORT_ARRAY[1]}
echo "CannyOS: Bedrock: Git: Up: $BEDROCK_GIT_HOST:$BEDROCK_GIT_PORT"


BEDROCK_BROWSER_HOST_PORT_ARRAY=${BEDROCKBROWSER_PORT_80_TCP#tcp://}
BEDROCK_BROWSER_HOST_PORT_ARRAY=(${BEDROCK_BROWSER_HOST_PORT_ARRAY//:/ })
while ! echo 'CannyOS_Bedrock:Browser is  now UP' | nc ${BEDROCK_BROWSER_HOST_PORT_ARRAY[0]} ${BEDROCK_BROWSER_HOST_PORT_ARRAY[1]}; do sleep 1; done
export BEDROCK_BROWSER_HOST=${BEDROCK_BROWSER_HOST_PORT_ARRAY[0]}
export BEDROCK_BROWSER_PORT=${BEDROCK_BROWSER_HOST_PORT_ARRAY[1]}
echo "CannyOS: Bedrock: Browser: Up: $BEDROCK_BROWSER_HOST:$BEDROCK_BROWSER_PORT"

if [ ! -f /etc/nginx/sites-enabled/bedrock-proxy ]; then
	echo "CannyOS: Bedrock: Proxy: Preparing Nginx config"
	sed -i "s/{{BEDROCK_PROXY_NAME}}/$BEDROCK_PROXY_NAME/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_PROXY_PORT}}/$BEDROCK_PROXY_PORT/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_CRUST_HOST}}/$BEDROCK_CRUST_HOST/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_CRUST_PORT}}/$BEDROCK_CRUST_PORT/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_STATIC_HOST}}/$BEDROCK_STATIC_HOST/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_STATIC_PORT}}/$BEDROCK_STATIC_PORT/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_TERMINAL_HOST}}/$BEDROCK_TERMINAL_HOST/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_TERMINAL_PORT}}/$BEDROCK_TERMINAL_PORT/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_GIT_HOST}}/$BEDROCK_GIT_HOST/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_GIT_PORT}}/$BEDROCK_GIT_PORT/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_BROWSER_HOST}}/$BEDROCK_BROWSER_HOST/" /etc/nginx/sites-available/bedrock-proxy
	sed -i "s/{{BEDROCK_BROWSER_PORT}}/$BEDROCK_BROWSER_PORT/" /etc/nginx/sites-available/bedrock-proxy
	ln -s /etc/nginx/sites-available/bedrock-proxy /etc/nginx/sites-enabled/bedrock-proxy
	rm /etc/nginx/sites-enabled/default
fi

echo "CannyOS: Bedrock: Proxy: Printing Nginx config"
cat /etc/nginx/sites-enabled/bedrock-proxy
echo "CannyOS: Bedrock: Proxy: Printing Nginx done"


echo "CannyOS: Bedrock: Proxy: Launching Supervisord"
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
