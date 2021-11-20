
@echo OFF
REM This script uses ffmpeg.exe to convert a RodeCaster Pro polyWAV file into single mon/stereo WAV files.
REM There are two versions: one with ALL channels being exported (rc_splitall.bat) and
REM one where only SUM, MIC1-4 and SoundBar are exported (rc_split.bat) as single files.

if "%1"=="" GOTO help

SET prefix=%2
if "%prefix%"=="" (
    SET prefix=".\out\split"
    )
echo Prefix: %prefix%

REM #############################################################
.\bin\ffmpeg -y -i %1 -hide_banner -loglevel error -stats -filter_complex ^
    "[0:a]pan=stereo|c0=c0|c1=c1[main];[0:a]pan=mono|c0=c2[m1];[0:a]pan=mono|c0=c3[m2];[0]pan=mono|c0=c4[m3];[0]pan=mono|c0=c5[m4];[0:a]pan=stereo|c0=c12|c1=c13[sp]" ^
    -map "[main]" %prefix%_main.wav -acodec pcm_s24le ^
    -map "[m1]" %prefix%_mic1.wav -acodec pcm_s24le ^
    -map "[m2]" %prefix%_mic2.wav -acodec pcm_s24le ^
    -map "[m3]" %prefix%_mic3.wav -acodec pcm_s24le ^
    -map "[m4]" %prefix%_mic4.wav -acodec pcm_s24le ^
    -map "[sp]" %prefix%_soundpad.wav -acodec pcm_s24lev

GOTO EOF

REM #############################################################
:help
echo Usage: splitpart.bat inputfile [prefix]
echo inputfile has to be a RodecasterPro PolyWAV
echo [prefix] is optional; used as a prefix for the split WAV files; default: 'split'
echo [prefix] can also include a path before the actual prefix, like '.\out\split'

REM #############################################################
:EOF