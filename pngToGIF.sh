#!/bin/bash
# $1 image name stub without numbers or extension
# $2 frame delay in 1/100 seconds
ffmpeg -i $1%d.png -f image2pipe -vcodec ppm - | convert -delay $2 -loop 0 - $1.gif
