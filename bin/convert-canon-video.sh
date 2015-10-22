#!/usr/bin/env bash

set -x

parallel -- ffmpeg -i {} -c:a libvorbis -b:a 128k -c:v libvpx -b:v 2000k {/.}.webm ::: "$@"
