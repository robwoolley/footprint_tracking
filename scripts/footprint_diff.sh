#!/bin/bash

FOOTPRINT_DATA_DIR="${FOOTPRINT_DATA_DIR:-footprint_data}"

if [ ! -d "${FOOTPRINT_DATA_DIR}" ]; then
	echo "ERROR: ${FOOTPRINT_DATA_DIR} is not a directory"
	exit 1
fi

# Describe the parent commit
git_version=$(git describe --abbrev=12)

for ver in $(ls -1 ${FOOTPRINT_DATA_DIR}); do
	git ls-files --error-unmatch ${FOOTPRINT_DATA_DIR}/${ver} &> /dev/null
	if [ $? -eq 1 ]; then
		echo "Adding   ${ver}"
		git add ${FOOTPRINT_DATA_DIR}/${ver}
		git commit -s -m "Adding ${ver} data"
	else
		echo "Skipping ${ver}"
	fi
done
