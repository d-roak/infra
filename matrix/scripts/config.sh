#!/bin/sh

DIRNAME=`dirname $0`
cd $DIRNAME/..

# generate config.yaml
docker compose up mautrix-discord

echo `pwd`

sed -i '' 's/matrix.example.com/example.com/g' ./data/mautrix-discord/config.yaml
sed -i '' 's/example.com/matrix.kaizokulabs.com/g' ./data/mautrix-discord/config.yaml
sed -i '' 's/localhost/mautrix-discord/g' ./data/mautrix-discord/config.yaml

sed -i '' 's/type: postgres/type: sqlite3-fk-wal/g' ./data/mautrix-discord/config.yaml
sed -i '' 's/uri: postgres.*/uri: file:\/data\/database.db?_txlock=immediate/g' ./data/mautrix-discord/config.yaml

# generate registration.yaml
docker compose up mautrix-discord -d

docker compose up mautrix-telegram

sed -i '' 's/example.com/matrix.kaizokulabs.com/g' ./data/mautrix-telegram/config.yaml
sed -i '' 's/localhost/mautrix-telegram/g' ./data/mautrix-telegram/config.yaml

sed -i '' 's/database: .*/database: sqlite:\/data\/database.db/g' ./data/mautrix-telegram/config.yaml

sed -i '' "s/api_id: .*/api_id: $TELEGRAM_API_ID/g" ./data/mautrix-telegram/config.yaml
sed -i '' "s/api_hash: .*/api_hash: $TELEGRAM_API_HASH/g" ./data/mautrix-telegram/config.yaml

docker compose up mautrix-telegram -d
