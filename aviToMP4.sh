#!/bin/bash
ffmpeg -i $1.avi -c:v libx264 -tune animation -crf 20 -preset veryslow -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" $1.mp4
#alternative
#ffmpeg -i $1.avi -c:v mpeg4 -vtag xvid -qscale:v 1 $1.mp4
