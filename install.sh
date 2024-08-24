#!/usr/bin/env bash

# where are we:
NONE_NAME=$(uname -n | grep -q "ubuntu.pop-os"; echo $?)
NODE=$(uname -n | awk -F "." '{print $1}')
CWD=`pwd`

## OpenMPI, EPOCH, VISIT installation
# installation path
test -z "$BUILD_PREFIX" && BUILD_PREFIX="$CWD"
test -z "$INSTALL_PREFIX" && INSTALL_PREFIX="$CWD/local"
test -z "$MAKE" && MAKE="cmake --build . -- -j$(nproc)"
test -z "$INSTALL" && INSTALL="cmake --install ."

# installation switches
test -z "$INSTALL_OPENMPI" && INSTALL_OPENMPI="0"
test -z "$INSTALL_ROOT" && INSTALL_ROOT="1"
test -z "$INSTALL_CLHEP" && INSTALL_CLHEP="0"
test -z "$INSTALL_GEANT4" && INSTALL_GEANT4="0"
test -z "$INSTALL_PARAVIEW" && INSTALL_PARAVIEW="0"

# packages version
test -z "$OPENMPI_VERSION" && OPENMPI_VERSION="4.1.4"
test -z "$ROOT_VERSION" && ROOT_VERSION="6.28.12"
test -z "$CLHEP_VERSION" && CLHEP_VERSION="2.4.7.1"
test -z "$GEANT4_VERSION" && GEANT4_VERSION="10.7.3"
test -z "$PARAVIEW_VERSION" && PARAVIEW_VERSION="5.11.2"

test -n "$DEBUG" && set -x
mkdir -p $INSTALL_PREFIX

# Printout summary
echo
echo "OS platform       : $(uname -n)"
echo "INSTALL_OPENMPI   : $INSTALL_OPENMPI"
echo "INSTALL_ROOT      : $INSTALL_ROOT"
echo "INSTALL_CLHEP     : $INSTALL_CLHEP"
echo "INSTALL_GEANT4    : $INSTALL_GEANT4"
echo "INSTALL_PARAVIEW  : $INSTALL_PARAVIEW"
echo
sleep 5

# function
function checkcommand { if ! command -v $1 &> /dev/null; then echo "$1 could not be found"; exit 1; fi } 
function wget_untar { wget --progress=bar:force --no-check-certificate $1 -O- | tar xz; }
function conf { ../configure --prefix=$INSTALL_PREFIX "$@"; }
function conf2 { ./configure --prefix=$INSTALL_PREFIX "$@"; }
function Cmake { cmake -DCMAKE_GENERATOR=Ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX "$@"; }
function refresh { source ~/.bashrc; }
function mmi { $MAKE "$@" && $INSTALL; }
function nni { ninja-build "$@" && ninja-build install;  }
function addbashrc {
    TEST=$(grep -q "$@" ${HOME}/.bashrc; echo $?)
    if [[ "$TEST" -eq "1" ]]; then
	echo "" >> ~/.bashrc
        echo "$@" >> ~/.bashrc
    fi
}
################################################
checkcommand cmake
checkcommand ccmake

function addbashrc2 {
    [[ ":$PATH:" != *":$@:"* ]] && PATH="$@:\$PATH"
}

# populate the INSTALL_PREFIX to the system
addbashrc "export PATH=$INSTALL_PREFIX/bin:\$PATH"
addbashrc "export LD_LIBRARY_PATH=$INSTALL_PREFIX:\$LD_LIBRARY_PATH"
refresh

## Install OpenMPI                                                                          
if [[ "$INSTALL_OPENMPI" -eq "1" ]]; then
    
    echo "Installing OpenMPI : v${OPENMPI_VERSION}"; sleep 3    
    cd $BUILD_PREFIX
    test -d openmpi-$OPENMPI_VERSION || wget_untar https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION%??}/openmpi-$OPENMPI_VERSION.tar.gz
    cd openmpi-$OPENMPI_VERSION
    mkdir build; cd build
    conf
    mmi
    
    # enable oversubscribe                                                                  
    echo "${HOSTNAME} slots=$nproc" >> $INSTALL_PREFIX/etc/openmpi-default-hostfile

    # append to bash
    addbashrc "export MPI_ROOT=$INSTALL_PREFIX"
fi

# Install ROOT
if [[ "$INSTALL_ROOT" -eq "1" ]]; then
    echo "Installing root : v${ROOT_VERSION}"; sleep 3
    refresh
    cd $BUILD_PREFIX
    test -d root-$ROOT_VERSION || wget_untar https://root.cern/download/root_v${ROOT_VERSION}.source.tar.gz
    mkdir root; mv root-$ROOT_VERSION ./root; cd root
    mkdir build install; cd build
    cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../root-$ROOT_VERSION 
    cmake --build . --target install -- -j$(nproc)
    addbashrc "source $INSTALL_PREFIX/bin/thisroot.sh"
    echo "Done."; sleep 3
fi

# Install CLHEP
if [[ "$INSTALL_CLHEP" -eq "1" ]]; then

    echo "Installing clhep : v${CLHEP_VERSION}"; sleep 3
    refresh
    cd $BUILD_PREFIX
    test -d clhep-$CLHEP_VERSION || wget_untar https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-$CLHEP_VERSION.tgz
    mv $CLHEP_VERSION clhep-$CLHEP_VERSION
    cd clhep-$CLHEP_VERSION
    mkdir build; cd build
    Cmake $BUILD_PREFIX/clhep-$CLHEP_VERSION/CLHEP
    #nni
    mmi

    addbashrc "export CLHEP_DIR=$INSTALL_PREFIX"
    addbashrc "export CLHEP_INCLUDE_DIR=$CLHEP_DIR/include"
    addbashrc "export CLHEP_LIBRARY=$CLHEP_DIR/lib"
    echo "Done."; sleep 3
fi

# Install GEANT4
if [[ "$INSTALL_GEANT4" -eq "1" ]]; then
    
    echo "Installing GEANT4 : v${GEANT4_VERSION}"; sleep 3
    refresh
    cd $BUILD_PREFIX
    # LINK 1
    #test -d geant4-${GEANT4_VERSION} || wget_untar https://github.com/Geant4/geant4/archive/refs/tags/v${GEANT4_VERSION}.tar.gz
    # LINK 2
    test -d geant4-v${GEANT4_VERSION} || wget_untar https://gitlab.cern.ch/geant4/geant4/-/archive/v${GEANT4_VERSION}/geant4-v${GEANT4_VERSION}.tar.gz
    cd geant4-v${GEANT4_VERSION}
    # patch 1
    #patch 
    mkdir build; cd build
    Cmake \
	-DGEANT4_BUILD_MULTITHREADED=ON \
	-DGEANT4_INSTALL_DATA=ON \
	-DGEANT4_USE_GDML=ON \
	-DGEANT4_USE_INVENTOR_QT=ON \
	-DGEANT4_USE_OPENGL_X11=ON \
	-DGEANT4_USE_QT=ON \
	-DGEANT4_USE_RAYTRACER_X11=ON \
	-DGEANT4_USE_SYSTEM_CLHEP=ON \
	-DGEANT4_USE_SYSTEM_EXPAT=ON \
	-DGEANT4_USE_SYSTEM_ZLIB=ON \
	-DGEANT4_USE_TBB=OFF \
	-DGEANT4_USE_XM=ON \
	$BUILD_PREFIX/geant4-v${GEANT4_VERSION}
    #nni
    mmi

    # specific fix for v10.7.3
    patch $BUILD_PREFIX/local/lib64/Geant4-${GEANT4_VERSION}/Geant4PackageCache.cmake < $BUILD_PREFIX/patch/Geant4PackageCache.cmake.patch
    echo "Done."; sleep 3
fi

# Install PARAVIEW 
if [[ "$INSTALL_PARAVIEW" -eq "1" ]]; then

    echo "Installing paraview : v${PARAVIEW_VERSION}"; sleep 3
    refresh
    cd $BUILD_PREFIX
    mver=$(echo $PARAVIEW_VERSION | awk -F "." $'{print $1"."$2}')
    test -d ParaView-v${PARAVIEW_VERSION} || \
	wget_untar https://www.paraview.org/paraview-downloads/download.php?submit=Download\&version=v${mver}\&type=source\&os=Sources\&downloadFile=ParaView-v${PARAVIEW_VERSION}.tar.gz
    cd ParaView-v${PARAVIEW_VERSION}
    mkdir build; cd build
    # patch 1
    patch $BUILD_PREFIX/ParaView-v${PARAVIEW_VERSION}/VTK/ThirdParty/libproj/vtklibproj/src/proj_json_streaming_writer.hpp < $BUILD_PREFIX/proj_json_streaming_writer.patch
    Cmake \
	-DPARAVIEW_USE_PYTHON=ON \
	$BUILD_PREFIX/ParaView-v${PARAVIEW_VERSION}
    #nni
    mmi

    echo "Done."; sleep 3
fi
