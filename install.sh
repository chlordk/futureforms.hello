#! /bin/bash
# vim: ts=4 :
#set -x
set -e

if ! which git > /dev/null
then
	echo Install git
	sudo apt install git
fi

if ! which unzip > /dev/null
then
	echo Install unzip
	sudo apt install unzip
fi

if ! which npm > /dev/null
then
	echo Install npm
	sudo apt install npm
fi

if ! which tsc > /dev/null
then
	echo Install tsc
	sudo apt install node-typescript
fi

if ! which java > /dev/null
then
	echo Install Java
	sudo apt install openjdk-19-jre
fi

if ! which psql > /dev/null
then
	echo Install PostgreSQL
	sudo apt install postgresql
fi

if [ ! -d core ]
then
	git clone https://github.com/miracle-42/forms42.core core
	(
		cd core
		git checkout version-2.1-dev
		npm install
		npm run build
	)
fi

if [ ! -d hello ]
then
	git clone https://github.com/chlordk/futureforms.hello hello
	(
		cd hello
		npm install
		npm run build
	)
fi

echo Check \'hr\' database exists:
if ! sudo -u postgres psql -qAt -d hr -c 'SELECT 1' 
then
	sudo -u postgres psql -c "CREATE USER hello WITH PASSWORD 'hello'"
	sudo -u postgres psql -c "CREATE DATABASE hello OWNER hello"
	export PGPASSWORD=hello
	psql -h localhost -U hello -d hello < hello/data/data.sql
fi

if [ ! -d database.js ]
then
	if [ ! -d database.js.git ]
	then
		git clone https://github.com/miracle-42/database.js database.js.git
	fi
	mkdir database.js
	(
		cd database.js
		unzip ../database.js.git/downloads/database.js.zip
		sed -i 's|"path": "./app"|"path": "../hello/dist"|' conf/config.json
	)
fi

if [ ! -e database.js/logs/inst00/server.log.0.lck ]
then
	echo Starting database.js...
	# Start must be done from this directory:
	( cd database.js && bin/database.js start )
fi
database.js/bin/database.js status

echo
echo Stop database.js command: ./database.js/bin/database.js stop
echo
echo Start the demo with a browser at: http://localhost:9002/
