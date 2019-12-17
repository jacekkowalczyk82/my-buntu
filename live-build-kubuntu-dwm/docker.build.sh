#!/bin/bash

continue_or_abort() {
	abort=0
	echo "y/Y  - continue"
	echo "n/N  - Abort build"
	while true 
	do 
		read -p "Please enter your option" choice
		case $choice in
			n|N) abort=1; break;; 
			y|Y) echo "Lets build it "; break;; 
			*) echo "Invalid option, please try again";;
		esac
	done
	if [[ $abort -eq 1]]; then 
		exit 1
	fi
}
	
cp -r -v ../backgrounds ./config/includes.chroot/opt/ 

continue_or_abort
docker run --privileged -i \
    -v /proc:/proc \
    -v ${PWD}/artifacts:/artifacts \
    -v ${PWD}:/working_dir \
    -w /working_dir \
    debian:latest \
    /bin/bash < build.sh


