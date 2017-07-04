#!/bin/sh

./configure --prefix=${PREFIX}

make
if ! make check; then
  FAILURES=$(cat tests/testsuite.log | grep FAILED | wc -l | awk '{print $1}')
  if [[ ${FAILURES} > 5 ]]; then
    echo "Expected 5 failures from the libtool testsuite due to cyclic dependency between libtool and autoconf/automake. Got ${FAILURES}"
    echo "See: http://lists.linuxfromscratch.org/pipermail/lfs-dev/2014-December/069805.html"
    echo "The expected failures are:"
    echo "Standalone Libltdl."
    echo "122: compiling softlinked libltdl"
    echo "123: compiling copied libltdl"
    echo "124: installable libltdl"
    echo "125: linking libltdl without autotools"
    echo "Subproject Libltdl."
    echo "129: linking libltdl without autotools"
    exit 1
  fi
fi
make install
