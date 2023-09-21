#!/bin/bash
echo "BUILDARGS=$C_BUILDARGS"
source /opt/sming/Tools/export.sh
cd /root/build
ls -l /dev/ttyUSB0
make $C_BUILDARGS 

