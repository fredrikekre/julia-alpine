#!/bin/sh
if [ "$1" = "v1.2.0-rc1" ]; then
    patch -p1 -i "patches/fix-rpath.diff"
    patch -p1 -i "patches/fix-getopt.diff"
    patch -p1 -i "patches/revert-disable-BB-for-gmp-and-mpfr.diff"
    patch -p1 -i "patches/binarybuilder-for-dSFMT.diff"
    patch -p1 -i "patches/binarybuilder-for-Objconv.diff";
    patch -p1 -i "patches/disable-libunwind-test.diff";
fi
echo 'override USE_BINARYBUILDER_LIBUNWIND=0' >> Make.user
echo 'override USE_BINARYBUILDER_UNWIND=0' >> Make.user
echo 'override TAGGED_RELEASE_BANNER="github.com/fredrikekre/julia-alpine build"' >> Make.user