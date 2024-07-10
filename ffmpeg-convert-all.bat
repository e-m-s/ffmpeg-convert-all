@echo off
rem Version 2023-02-16 22:53
if '%FFMPEG_PATH%'=='' set FFMPEG_PATH=%USERPROFILE%\Documents\_dalsi-data\fotky\_convert.ffmpeg
if not exist %FFMPEG_PATH%\ffmpeg set FFMPEG_PATH=

if not '%1'=='--help' goto BEGIN
echo Usage:   %0 [bitrate] [scaleX]
echo Example: %0 800k 720
echo   means: Convert to 800k/s and scale to 720px keeping aspect ratio. (Use -1 or -2 for some codecs.)
echo Example: %0 1200k 720:480
echo   means: Convert to 1200k/s and scale to 720:480.
echo Predefined settings:
echo  "- %0 mobil -> 400k 720 -2"
echo  "- %0 hd -> 800k 720 -2"
echo  "- %0 fhd -> 1600k 1920 -2"
goto END

:BEGIN
if not '%ffmpeg%'=='' goto SETUP
if exist .\ffmpeg.exe goto LOCAL
if exist %FFMPEG_PATH%\ffmpeg.exe goto VARIABLE
if exist %1\ffmpeg.exe goto PARAM
rem Otherwise expect that ffmpeg.exe is in PATH:
set ffmpeg=ffmpeg.exe
goto SETUP

:PARAM
set ffmpeg=%1\ffmpeg.exe
shift
goto SETUP

:VARIABLE
set ffmpeg=%FFMPEG_PATH%\ffmpeg.exe
goto SETUP

:LOCAL
set ffmpeg=.\ffmpeg.exe
goto SETUP

:SETUP
rem echo "%ffmpeg%"
if '%1'=='mobil' goto MOBIL_SETTINGS
if '%1'=='hd' goto HD_SETTINGS
if '%1'=='fhd' goto FHD_SETTINGS

set bitrate=800k
set scale=
set scalef=
if not '%1'=='' set bitrate=%1
if not '%2'=='' set scalef=%2
if not '%3'=='' set scale=-vf scale=%scalef%:%3
if not '%scalef%'=='' if '%3'=='' set scale=-vf scale=%scalef%:-2
if not '%scalef%'=='' set scalef=%scalef%x
goto RUN

:MOBIL_SETTINGS
set bitrate=400k
set scale=-vf scale=720:-2
set scalef=720x
goto RUN
:HD_SETTINGS
set bitrate=800k
set scale=-vf scale=720:-2
set scalef=hd
goto RUN
:FHD_SETTINGS
set bitrate=1600k
set scale=-vf scale=1920:-2
set scalef=fhd
goto RUN

:RUN
for %%x in (*.mp4 *.mov) do "%ffmpeg%" -i "%%x" -vcodec libx265 %scale% -b:v %bitrate% "%%x.%bitrate%.%scalef%.small.mp4"

:END