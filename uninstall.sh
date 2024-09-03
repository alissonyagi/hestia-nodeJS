#!/bin/bash

source /etc/hestiacp/hestia.conf

# Check if nodeJS template is being used by some user

IFS=$'\n'

INUSE=""

for u in `v-list-users plain | cut -f1`; do
	home=$(grep "^$u:" /etc/passwd | cut -d":" -f6)

	for d in `v-list-web-domains $u plain | cut -f1,18 | grep "nodeJS$" | cut -f1`; do
		INUSE="${INUSE}$u"$'\t'"$d"$'\n'
	done
done

if [ -n "$INUSE" ]; then
	echo "NodeJS template is still active for the following users/domains:"
	echo $INUSE
	exit 1
fi

NGINX="$HESTIA/data/templates/web/nginx/"

if [ ! -d "$NGINX" ]; then
	echo "Nginx templates directory not found. Is it installed?"
	exit 1
fi

NODE_MODULES="$HESTIA/data/nodeJS/"

rm -f "$NGINX"/nodeJS.stpl
rm -f "$NGINX"/nodeJS.tpl
rm -f "$NGINX"/nodeJS.sh
rm -f /etc/cron.d/hestia-nodeJS
rm -f "$HESTIA/bin"/v-start-pm2
rm -f "$NODE_MODULES/hestia-uds.js"
rmdir "$NODE_MODULES"

echo "Done."
