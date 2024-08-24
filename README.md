# installGeant4

self-contain script to install geant4

# pinned version

 - v1
 ```
 OPENMPI_VERSION="4.1.4"
 ROOT_VERSION="6.28.12"
 CLHEP_VERSION="2.4.7.1"
 GEANT4_VERSION="10.7.3"
 PARAVIEW_VERSION="5.11.2"
 ```

# pre-requisite packages

## Ubuntu

 - essential
   ```
   sudo apt update
   sudo apt install build-essential
   ```
   
 - ROOT
   Dependencies: https://root.cern/install/dependencies/#ubuntu-and-other-debian-based-distributions
   
 - GEANT4
   ```
   sudo apt install libxerces-c-dev libexpat1-dev libcoin-dev libsoqt-dev libmotif-dev
   ```

 - PARAVIEW
   ```
   sudo apt install python3-dev libxcursor-dev qtbase5-dev qtdeclarative5-dev libqt5help5 libqt5x11extras5-dev libqt5help5 qttools5-dev qtxmlpatterns5-dev-tools libqt5svg5-dev
   ```

## Fedora

# Installation

In clean folder, do

```
./install.sh
```

that's it.
