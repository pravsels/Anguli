#!/bin/bash

#############################################################################
# Setup X server permissions
#############################################################################
# Allow container's root user to connect to X server
# Without this, GUI applications in the container cannot display windows
# This adds an entry to the X server's access control list
xhost +local:root

#############################################################################
# Container Configuration and Launch
#############################################################################
# Detailed explanation of options:
#
# --net=host: 
#   Gives container direct access to host's network interfaces
#   Required for proper X11 display forwarding
#
# --ipc=host:
#   Shares host's inter-process communication namespace with container
#   Needed for X11's shared memory operations
#   Without this, applications might fail to allocate shared memory segments
#
# -e DISPLAY=$DISPLAY:
#   Passes host's display environment variable to container
#   Tells GUI applications which X server display to connect to
#
# -e QT_X11_NO_MITSHM=1:
#   Tells Qt to not use the MIT-SHM extension
#   Setting to 1 explicitly DISABLES the shared memory usage in Qt
#
# -e _X11_NO_MITSHM=1:
#   General X11 setting to disable MIT-SHM
#   Setting to 1 explicitly DISABLES the shared memory extension
#
# -v /tmp/.X11-unix:/tmp/.X11-unix:
#   Mounts X11 socket directory from host into container
#   This Unix domain socket enables communication between X clients and X server
#   Format is host-path:container-path
#
# -v "$(pwd)/../../../fingerprint_generation/":/app:
#   Mounts application directory into container
#   $(pwd) gets current directory path
#   ../../../fingerprint_generation/ navigates to application root
#   :/app is where it's mounted in the container
#
docker run -it \
  --net=host \
  --ipc=host \
  -e DISPLAY=$DISPLAY \
  -e QT_X11_NO_MITSHM=1 \
  -e _X11_NO_MITSHM=1 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$(pwd)":/app \
  anguli_ws

#############################################################################
# Cleanup
#############################################################################
# Remove container's root user access from X server
# Important security measure to prevent unauthorized access after container exits
# Removes the entry previously added to X server's access control list
xhost -local:root

