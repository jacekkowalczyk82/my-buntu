#!/bin/bash

continue_or_abort() {
	abort=0
	echo "y/Y  - continue"
	echo "n/N  - Abort build"
	while true 
	do 
		read -p "Please enter your option: " choice
		case $choice in
			n|N) abort=1; break;; 
			y|Y) echo "Lets build it "; break;; 
			*) echo "Invalid option, please try again";;
		esac
	done
	if [[ $abort -eq 1 ]]; then 
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

#NAME="my-buntu-dwm-mate"
#VERSION="18.04"    
#aws s3 --region us-east-2 cp $NAME-$VERSION-*.iso s3://jacekkowalczyk82.private.s3/my-buntu-images/  
#aws s3 --region us-east-2 cp $NAME-$VERSION-*.sha256.txt s3://jacekkowalczyk82.private.s3/my-buntu-images/  
#aws s3 --region us-east-2 cp $NAME-$VERSION-*.md5.txt s3://jacekkowalczyk82.private.s3/my-buntu-images/  

