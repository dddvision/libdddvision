#!/bin/bash

palette="/tmp/palette.png"

ffmpeg -i $1.avi $1.gif
#ffmpeg -i $1.avi -vf "$filters,palettegen" -y $palette
#ffmpeg -i $1.avi -i $palette -lavfi "scale=iw:-1:flags=lanczos [x]; [x][1:v] paletteuse" -y $1.gif

if [ "$#" -ge 2 ]; then
    gifsicle --batch -O3 --delay $2 -i $1.gif
else
    gifsicle --batch -O3 -i $1.gif
fi
