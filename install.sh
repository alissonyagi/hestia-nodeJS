#!/bin/bash

source /etc/hestiacp/hestia.conf

NGINX="$HESTIA/data/templates/web/nginx/"

if [ ! -d "$NGINX" ]; then
	echo "Nginx templates directory not found. Is it installed?"
	exit 1
fi

NODE_MODULES="$HESTIA/data/nodeJS/"

if [ ! -d "$NODE_MODULES" ]; then
	mkdir "$NODE_MODULES"
fi

DIR=$(dirname "$(readlink -f "$0")")

chmod 644 "$DIR/node_modules/hestia-uds.js"
chmod 644 "$DIR/template/nodeJS.stpl"
chmod 644 "$DIR/template/nodeJS.tpl"
chmod 644 "$DIR/cron/hestia-nodeJS"
chmod 755 "$DIR/template/nodeJS.sh"
chmod 755 "$DIR/bin/v-start-pm2"

chown root:root "$DIR/node_modules/hestia-uds.js"
chown root:root "$DIR/template/nodeJS.sh"
chown root:root "$DIR/template/nodeJS.stpl"
chown root:root "$DIR/template/nodeJS.tpl"
chown root:root "$DIR/cron/hestia-nodeJS"
chown root:root "$DIR/bin/v-start-pm2"

cp "$DIR/node_modules/hestia-uds.js" "$NODE_MODULES"
cp "$DIR/template/nodeJS.sh" "$NGINX"
cp "$DIR/template/nodeJS.stpl" "$NGINX"
cp "$DIR/template/nodeJS.tpl" "$NGINX"
cp "$DIR/cron/hestia-nodeJS" /etc/cron.d/
cp "$DIR/bin/v-start-pm2" "$HESTIA/bin/"

echo "Done."
