#!/bin/bash

DEBUG=1
set -e

while true; do
	git_version=$(git describe --abbrev=12)
	git_date=$(git show --format="%cD" -s)
	git_datebefore=$(date --date="${git_date} yesterday" "+%Y-%m-%d %H:%M:%S")
	if [ $DEBUG -eq 1 ]; then
		echo "Current:"
		echo "git_version: ${git_version}"
		echo "git_date: ${git_date}"
		echo "git_datebefore: ${git_datebefore}"
	fi

	rm -rf build
	#git checkout HEAD^
	git checkout $(git rev-list -n 1 --first-parent --before="${git_datebefore}" main)
	west update
	if [ $? != 0 ]; then
		echo "ERROR: git checkout failed" >&2
		exit 1;
	fi

	git_version=$(git describe --abbrev=12)
	git_date=$(git show --format="%cD" -s)
	if [ $DEBUG -eq 1 ]; then
		echo "New checkout:"
		echo "new git_version: ${git_version}"
		echo "new git_date: ${git_date}"
	fi

	if [ -d footprint_data/${git_version} ]; then 
		echo "Skipping $git_version}"
	else
		scripts/footprint/track.py -p scripts/footprint/plan.txt
	fi

done
