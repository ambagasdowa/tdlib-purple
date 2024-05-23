#!/bin/bash

set -e

JOBS="$(nproc || echo 1)"

rm -rf build
mkdir build
pushd build
  git clone https://github.com/tdlib/td.git
  pushd td
    git checkout 1d1bc07eded7d3ee7df7c567e008bbf926cba081 # spoilers
    mkdir build
    pushd build
      cmake -DCMAKE_BUILD_TYPE=Release ..
      make -j "${JOBS}"
      make install DESTDIR=destdir
    popd
  popd
  cmake -DAPI_ID="17349" -DAPI_HASH="344583e45741c457fe1862106095a5eb" -DTd_DIR="$(realpath .)"/td/build/destdir/usr/local/lib/cmake/Td/ -DNoVoip=True ..
  make -j "${JOBS}"
  echo "Now calling sudo make install"
  sudo make install
popd
