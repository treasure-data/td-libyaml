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
rm -fR yaml-0.1.4*
wget 'http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz'
tar vzxf yaml-0.1.4.tar.gz
cp Makefile.am yaml-0.1.4/src
cd yaml-0.1.4 && libtoolize --force && aclocal && automake && autoconf && cd ..
rm yaml-0.1.4.tar.gz
tar cvf yaml-0.1.4.tar.gz yaml-0.1.4
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
