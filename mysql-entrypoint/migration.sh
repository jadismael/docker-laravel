#!/bin/bash

cd /_migration

for ms in *; do
	if [ -d "$ms/dump" ]; then
		for dmp in $(ls -1 "$ms"/dump/* | sort -V  -t'_' -k1,1); do
			# echo ""
			echo "$dmp"
			mysql --default-character-set=utf8 -uroot -p"${MYSQL_ROOT_PASSWORD}" < "$dmp"
		done
	fi
	
	if [ -d "$ms/release" ]; then
		if [ ! -z "$(ls -1 $ms/release/)"  ]; then #dir is not empty
			for rel in $(ls -1 "$ms"/release | sort -V  -t'_' -k1,1); do
				# echo ""
				echo "/_migration/$ms/release/$rel"
				mysql --default-character-set=utf8 -uroot -p"${MYSQL_ROOT_PASSWORD}" -D"$ms" < "/_migration/$ms/release/$rel"
			done
		fi
		if [ -f "$ms/create_trigger.sql" ]; then
			mysql --default-character-set=utf8 -uroot -p"${MYSQL_ROOT_PASSWORD}" -D"$ms" < "/_migration/$ms/create_trigger.sql"
		fi
	fi


done
