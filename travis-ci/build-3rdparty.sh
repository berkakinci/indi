#!/bin/bash

set -x -e

if [ ! -z $BUILD_THIRD_PARTY ]; then
  echo "==> BUILD_THIRD_PARTY activated"
  mkdir -p build/3rdparty
  pushd build/3rdparty
  # bash ../../3rdparty/make_libraries
  
  if [ ${TRAVIS_OS_NAME}="linux" ] ; then 
    LIBS="libapogee libfishcamp libfli libfli libqhy libqsi libsbig"
  else
    LIBS="libapogee libfishcamp libfli libfli libqhy libqsi"
  fi

  for lib in $LIBS ; do
  (
    echo "Building $lib ..."
    mkdir build_$lib
    cd build_$lib
    cmake -DCMAKE_INSTALL_PREFIX=/usr . ../../../3rdparty/$lib
    make
    sudo make install
  )
  done

  if [ ${TRAVIS_OS_NAME}="linux" ] ; then 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/ -DWITH_NSE:OPTION=ON -DWITH_MI:OPTION=OFF -DWITH_QHY:OPTION=OFF . ../../3rdparty/
  else 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/ -DWITH_NSE:OPTION=ON -DWITH_SBIG:OPTION=OFF . ../../3rdparty/
  fi
  sudo make install
  popd
else
  echo "==> BUILD_THIRD_PARTY not specified"
fi

exit 0

