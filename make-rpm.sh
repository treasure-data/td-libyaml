#!/bin/bash
version=0.1.4
dst=td-libyaml-$version
cur=`pwd`

# user defined revision
if [ ! -z "$1" ]; then
  rev=$1
  rpm_dist=$(echo $rev | cut -c1-10)
fi

# install required packages
yum install -y emacs zlib-devel automake autoconf libtool auto-buildrequires openssl-devel

# setup td-libyaml-$version.tar.gz
rm -fR $dst*
wget 'http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz'
tar vzxf yaml-0.1.4.tar.gz
mv yaml-0.1.4 $dst
mv yaml-0.1.4.tar.gz $dst.tar.gz

# setup rpmbuild env
echo "%_topdir $cur/rpmbuild/" > ~/.rpmmacros
rm -fR rpmbuild
mkdir rpmbuild
pushd rpmbuild
mkdir BUILD RPMS SOURCES SPECS SRPMS
# locate spec
cp ../redhat/td-libyaml.spec SPECS
# locate source tarball
mv ../$dst.tar.gz SOURCES
# build
if [ -z "$rpm_dist" ]; then
  rpmbuild -v -ba --clean SPECS/td-libyaml.spec
else
  rpmbuild -v -ba --define "dist .${rpm_dist}" --clean SPECS/td-libyaml.spec
fi
popd
