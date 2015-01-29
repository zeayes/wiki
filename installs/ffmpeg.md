#### centos安装ffmpeg

`ffmpeg`官网安装[文档](https://trac.ffmpeg.org/wiki/CompilationGuide/Centos)。

####1、安装依赖

```Bash
yum install autoconf automake gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel
```

####2、创建安装相关目录

```Bash
mkdir ~/ffmpeg_sources ~/ffmpeg_build
```

####3、`yasm`

```Bash
cd ~/ffmpeg_sources
wget -c http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make -j 4
make install
make distclean
export PATH=$PATH:/root/ffmpeg_build/bin
```

####4、 `gpac`

```Bash
wget http://sourceforge.net/projects/gpac/files/GPAC/GPAC%200.5.0/gpac-0.5.0.tar.gz
./configure --prefix="$HOME/ffmpeg_build"
make -j 8
make install
make lib
make install-lib
```



####5、`x264`
>H.264 视频编码器。

```Bash
cd ~/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --prefix="$HOME/ffmpeg_build" --enable-static --enable-shared
make -j 4
make install
make distclean
```

####6、`fdk-acc`
> ACC音频编码器。

```Bash
cd ~/ffmpeg_sources
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make -j 4
make install
make distclean
```

####7、`lame`

```Bash
cd ~/ffmpeg_sources
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$HOME/ffmpeg_build" --enable-shared --enable-nasm
make -j 4
make install
make distclean
```

####8、`opus`
> Opus音频编码、解码器。

```Bash
cd ~/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzvf opus-1.1.tar.gz
cd opus-1.1
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make -j 4
make install
make distclean
```

####9、`libogg`
> Ogg字节流库。

```Bash
cd ~/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar xzvf libogg-1.3.1.tar.gz
cd libogg-1.3.1
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make -j 4
make install
make distclean
```

####10、`libvorbis`
> Vorbis音频编码器。

```
cd ~/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --enable-shared
make -j 4
make install
make distclean
```

####11、`libvpx`
> VP8/VP9 视频编码器。

```
cd ~/ffmpeg_sources
#wget -c http://anduin.linuxfromscratch.org/sources/other/libvpx-v1.3.0.tar.xz
#tar xvf libvpx-v1.3.0.tar.xz
#cd libvpx-v1.3.0
git clone --depth 1 https://github.com/webmproject/libvpx.git
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make -j 4
make install
make clean
```

####12、 `webp`
> webp 支持格式

```Bash
cd ~/ffmpeg_sources
wget http://downloads.webmproject.org/releases/webp/libwebp-0.4.1.tar.gz
tar xzf libwebp-0.4.2.tar.gz
cd libwebp-0.4.2
./configure --prefix=$HOME/ffmpeg_build
make -j 12
make install
```

####13、更改`ffmpeg`源代码
> `ffmpeg`不支持`SAR`、`DAR`为负数的视频。

```
# 更改ffmpeg源代码
# 目前最小化更改，不过直接用if (o->min > num) num=abs(num);也没有问题
# libavutil/opt.c:188

if (o->min > num && strcmp(o->name, "pixel_aspect") == 0) {                                                                                                                                                     
    num = abs(num);
}
```

####14、`ffmpeg`

```
cd ~/ffmpeg_sources
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --disable-ffserver --extra-libs=-ldl --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libwebp
make -j 16
make install
make distclean
```

####15、其他编译

```Bash
./configure --prefix=$HOME \
--disable-ffserver --enable-gpl --enable-version3 --enable-nonfree \
--enable-postproc --enable-pthreads --enable-libfaac --enable-libmp3lame \
--enable-libvorbis --enable-libtheora --enable-libx264 --enable-libvpx \
--enable-librtmp --enable-libfdk_aac --enable-openssl \
--enable-runtime-cpudetect --enable-libspeex --enable-libfreetype \
--enable-libvo-aacenc --enable-libvo-amrwbenc --enable-gray \
--enable-libopenjpeg --enable-libopencore-amrnb --enable-libopencore-amrwb \
--enable-filter=movie --enable-frei0r --enable-libxvid \
--arch=x86_64 --enable-static --disable-shared --disable-debug \
--extra-cflags="-I$HOME/ffmpeg_build/include --static" \
--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
--extra-libs='-static -lpng -lbz2 -lm -lz -lkrb5 -lkrb5support -lk5crypto -lcom_err -lkeyutils -lresolv'
```

```Bash
./configure --prefix=$HOME \
--disable-ffserver --enable-gpl --enable-version3 --enable-nonfree \
--enable-postproc --enable-pthreads --enable-libfaac --enable-libmp3lame \
--enable-libvorbis --enable-libtheora --enable-libx264 --enable-libvpx \
--enable-libfdk_aac --enable-openssl \
--enable-runtime-cpudetect --enable-libspeex \
--enable-libvo-aacenc --enable-libvo-amrwbenc --enable-gray \
--enable-libopencore-amrnb --enable-libopencore-amrwb \
--enable-filter=movie --enable-libxvid \
--arch=x86_64 --enable-static --disable-shared --disable-debug \
--extra-cflags="-I$HOME/ffmpeg_build/include --static" \
--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
--extra-libs=-ldl
```
