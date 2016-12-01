#!/bin/bash

set -x

parallel -- ffmpeg -i {} -c:a libvorbis -b:a 64k -c:v libvpx -b:v 2000k {/.}.webm ::: "$@"
