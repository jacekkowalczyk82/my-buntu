#!/bin/bash 
NAME="my-buntu-dwm-mate"
LOGFILE="${NAME}-`date '+%Y-%m-%d_%H%M%S'`.log"

bash docker.build.sh 2>&1 | tee ${LOGFILE}
