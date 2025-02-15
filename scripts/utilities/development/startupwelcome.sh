#!/bin/sh

searchresult=$(googler -C -n 100 --np -t h12 -x -w https://music.youtube.com "")
urls=$(echo "$searchresult" | grep -o "https://music.youtube.com/watch?v=...........")
url=$(shuf -e -n 1 $urls)
echo "$url"
#omxplayer -o hdmi $(youtube-dl -f mp4 -g "$url")
    
