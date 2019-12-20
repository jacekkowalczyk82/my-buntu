#!/bin/bash 
NAME="my-buntu-dwm-kde"
LOGFILE="${NAME}-`date '+%Y-%m-%d_%H%M%S'`.log"

bash docker.build.sh 2>&1 | tee ${LOGFILE}
