./configure --prefix=~/mplayer_build --codecsdir=~/mplayer_source/all-20110131 --win32codecsdir=~/mplayer_source/windows-all-20071007


faac --mpeg-vers 4 audiodump.wav

~/mplayer_build/bin/mencoder -vf format=i420 -nosound -ovc raw -of rawvideo -ofps 23.976 -o tmp.fifo.yuv 10193.mp4 2>&1 > /dev/null &

x264 -o max-video.mp4 --fps 23.976 --crf 26 --progress  tmp.fifo.yuv 720x480

 ~/mplayer_build/bin/x264 -o max-video.mp4 --fps 23.976 --bframes 2 --crf 26 --subme 6 --analyse p8x8,b8x8,i4x4,p4x4 tmp.fifo.yuv 720x480
 
 
 ./configure --prefix="$HOME/mplayer_build" --extra-cflags="-I$HOME/mplayer_build/include" --extra-ldflags="-L$HOME/mplayer_build/lib" --enable-static