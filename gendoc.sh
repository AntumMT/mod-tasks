#!/usr/bin/env bash

# change to source root
cd `dirname $0`

echo "Checking for mkdocs executable ..."

which mkdocs > /dev/null 2>&1
res=$?

if [ ${res} -ne 0 ]; then
	echo "ERROR: mkdocs executable not found, exiting ..."
	exit ${res}
fi

echo "Checking for Git repository ..."

git status > /dev/null 2>&1
res=$?

if [ ${res} -ne 0 ]; then
	echo "ERROR: Not in Git repository, exiting ..."
	exit ${res}
fi

tags=(`git tag`)
ref=${tags[0]}
if [ ! -x $1 ]; then
	ref=$1
	echo "Using Git ref specified with parameter \"${ref}\""
elif [ -x ${ref} ]; then
	ref=master
	echo "Using default Git ref \"${ref}\""
fi

echo "Cleaning up old files ..."

for item in *.html *.xml *.gz; do
	rm -f "${item}"
done
for item in `ls`; do
	if [ -d "${item}" ]; then
		rm -r "${item}"
	fi
done

echo "Building HTML documentation from Git ref \"${ref}\" ..."

git checkout ${ref} -- mkdocs.yml docs/ && git restore --staged -- ./

mkdocs build

if [ ! -d docs/html ]; then
	echo "ERROR: Build failed, \"docs/html\" directory not found, exiting ..."
	exit 2
fi

for item in `ls docs/html`; do
	mv "docs/html/${item}" ./
done

echo "Cleaning up ..."

rm -r mkdocs.yml docs/
