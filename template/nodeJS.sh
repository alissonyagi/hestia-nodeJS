#!/bin/bash

user=$1
domain=$2
ip=$3
home=$4
docroot=$5

www="www-data"
app="$home/$user/web/$domain/private/node"
base="$home/$user/web/$domain/private/hestia-nodeJS"
ecosystem="$base/ecosystem.config.js"

if [ ! -d "$app" ]; then
	mkdir "$app"
fi

if [ ! -d "$base" ]; then
	mkdir "$base"
fi

chown $user:$www "$base"
chmod g+rws,o= "$base"

# Attempt to find package.json from node app
json=$(find "$app" -maxdepth 2 -name package.json -printf "%d %p\n" | sort -n | head -n 1 | cut -d" " -f2-)

if [ -z "$json" ]; then
	entry="[entry-point-here]"
	cwd="[path-to-entry-point]"
else
	entry=$(jq -r ".main" "$json")
	cwd=$(dirname "$json")
fi

cat > "$ecosystem" <<EOL
module.exports = {
    apps: [{
        name: "$domain",
        cwd: "$cwd",
        script: "$entry",
        instances: "1",
        env: {
            "PORT": "$base/hestia-nodeJS.sock",
            "HOST": "127.0.0.1",
            "NODE_PATH": "$HESTIA/data/nodeJS"
        }
    }]
}
EOL

chown $user:$user "$ecosystem"

if [ -z "$json" ]; then
	runuser -l $user "pm2 delete \"$ecosystem\""
	runuser -l $user "pm2 start \"$ecosystem\""
fi
