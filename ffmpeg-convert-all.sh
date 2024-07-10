#!/bin/bash
# Version 2024-07-10 15:19
# Quickfix version converted from original Windows batch file - thus plain and ugly
#
ffmpeg=`which ffmpeg`
if [[ ! -f $ffmpeg ]]; then 
    echo "FFMPEG was not installed? Install using: brew install ffmpeg"
    exit
fi

if [[ $1 == "--help" ]]; then
    echo "Usage:   $0 [bitrate] [scaleX]"
    echo "Example: $0 800k 720"
    echo "  means: Convert to 800k/s and scale to 720px keeping aspect ratio. (Use -1 or -2 for some codecs.)"
    echo "Example: $0 1200k 720:480"
    echo "  means: Convert to 1200k/s and scale to 720:480."
    echo "Predefined settings:"
    echo " - $0 mobil -> 400k 720 -2"
    echo " - $0 hd -> 800k 720 -2"
    echo " - $0 fhd -> 1600k 1920 -2"
    exit
fi

#if not '%ffmpeg%'=='' goto SETUP
#if exist .\ffmpeg.exe goto LOCAL
#if exist %FFMPEG_PATH%\ffmpeg.exe goto VARIABLE
#if exist %1\ffmpeg.exe goto PARAM
#rem Otherwise expect that ffmpeg.exe is in PATH:
#set ffmpeg=ffmpeg.exe
#goto SETUP

#:PARAM
#set ffmpeg=%1\ffmpeg.exe
#shift
#goto SETUP

#:VARIABLE
#set ffmpeg=%FFMPEG_PATH%\ffmpeg.exe
#goto SETUP

#:LOCAL
#set ffmpeg=.\ffmpeg
#goto SETUP

#:SETUP
# echo "%ffmpeg%"
bitrate=800k
scale=
scalef=

if [[ $1 == 'mobil' ]]; then
    bitrate="400k"
    scale="-vf scale=720:-2"
    scalef=".720x"
elif [[ $1 == 'hd' ]]; then
    bitrate="800k"
    scale="-vf scale=720:-2"
    scalef=".hd"
elif [[ $1 == 'fhd' ]]; then
    bitrate="1600k"
    scale="-vf scale=1920:-2"
    scalef=".fhd"
fi


#if not '%1'=='' set bitrate=%1
#if not '%2'=='' set scalef=%2
#if not '%3'=='' set scale=-vf scale=%scalef%:%3
#if not '%scalef%'=='' if '%3'=='' set scale=-vf scale=%scalef%:-2
#if not '%scalef%'=='' set scalef=%scalef%x
#goto RUN


for file in *.mp4 *.mov; do $ffmpeg -i $file -vcodec libx265 $scale -b:v $bitrate "${file%\.*}.$bitrate$scalef.small.mp4"; done

