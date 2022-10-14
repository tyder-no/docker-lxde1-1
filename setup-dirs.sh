#!/bin/bash
# Script for setting up directories for Lxde1 container adm
#
# Create directory structure that will be used for mounting in the container setup
# New directories added here as needed - don't have to mount all
[ -d c0 ] || mkdir c0
[ -d c0/cp_store ] || mkdir c0/cp_store
[ -d c0/cp_home ] || mkdir c0/cp_home





# Copy the basic structure with eventual content - this will always be executed
for i in {1..9}
do	 
   sudo rsync -axu c0/* c$i
done
