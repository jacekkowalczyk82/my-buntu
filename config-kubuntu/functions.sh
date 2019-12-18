#!/bin/bash 

install_custom_packages() { 
while IFS= read -r package_line ; do 

    package_name=$(echo $package_line | grep -v \# | xargs -n 1 ) 
    if [ ! -z $package_name ]; then 
		apt-get -y install $package_name 
    fi 
done < /packages.list
}
