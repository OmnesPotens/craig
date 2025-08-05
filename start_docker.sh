#!/bin/bash
set -x
env
yarn prisma:deploy
yarn run sync

DOWNLOAD_DOMAIN=$(echo $API_HOMEPAGE|awk -F'://' '{print $2}')
sed -z -E -i'' "s/(dexare:.*token:\s*)('')(.*applicationID:\s*)('')(.*downloadDomain:\s*)('localhost:5029')/\
\1'${DISCORD_BOT_TOKEN}'\3'${DISCORD_APP_ID}'\5'${DOWNLOAD_DOMAIN//\//\\/}'/" \
"/app/apps/bot/config/default.js"

 pm2 start /app/apps/ecosystem.config.js
 pm2 save
 pm2 logs
