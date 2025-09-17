#!/bin/bash

user=$1
domain=$2
ip=$3
home=$4
docroot=$5

www="www-data"
app="${home}/${user}/web/${domain}/private/node"
base="${home}/${user}/web/${domain}/private/hestia-nodeJS"
ecosystem="${base}/ecosystem.config.js"
sockets="${home}/${user}/conf/web/${domain}/nginx-hestia-nodeJS-sockets.conf"

if [ ! -d "$app" ]; then
	mkdir "$app"
	chown $user:$user "$app"
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

if [ ! -f "$ecosystem" ]; then
	cat > "$ecosystem" <<EOL
module.exports = {
  apps: [{
    name: "${domain}",
    cwd: "${cwd}",
    script: "${entry}",
    instances: "1",
    exec_mode: "cluster",
    env: {
      "PORT": "${base}/${domain}-0.sock",
      "HOST": "127.0.0.1",
      "NODE_PATH": "${HESTIA}/data/nodeJS"
    }
  }]
}
EOL

	chown $user:$user "$ecosystem"
fi

readarray -t found < <(find "$base" -maxdepth 1 -type s -name '*.sock' -exec basename {} \; | grep -E "^(${domain}-)[0-9]+(.sock)$")

if [ "${#found[@]}" -eq 0 ]; then
	found=("${domain}-0.sock")
fi

rm "$sockets"

for sock in "${found[@]}"; do
	echo "server unix:${base}/${sock};" >> "$sockets"
done
