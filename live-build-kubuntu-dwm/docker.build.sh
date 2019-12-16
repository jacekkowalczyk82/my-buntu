#!/bin/bash


docker run --privileged -i \
    -v /proc:/proc \
    -v ${PWD}/artifacts:/artifacts \
    -v ${PWD}:/working_dir \
    -w /working_dir \
    debian:latest \
    /bin/bash < build.sh


