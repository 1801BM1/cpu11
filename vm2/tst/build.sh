#!/bin/bash -e
function usage()
{
  cat <<EOF
Batch file to compile and copy built images to project folders
PDP-11 Simulator and original MACRO-11 on RT-11 is used to compile

Environment variables should be set:
  cpu11_tmp=%cpu11_tmp%
  cpu11_sim=%cpu11_sim%

Usage: built filename_without_extension
Example: build t401
EOF
  exit 1
}
if [ $# -eq 0 ] ; then
  usage
fi
if ! type -path rt11-build-lda.sh >/dev/null; then
  echo "Can't find rt11-build-lda.sh script. Exit" >&2
  exit 2
fi
rt11-build-lda.sh $1
mkdir -p out
mv *.{mem,hex,mif,lda,bin,lst} build.log out/

mkdir -p ../../xen/tst
cp -p out/*.{mif,mem} ../../xen/tst
