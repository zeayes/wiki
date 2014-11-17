#### centos安装ffmpeg

`ffmpeg`官网安装[文档](https://trac.ffmpeg.org/wiki/CompilationGuide/Centos)。

1、安装依赖
```sh
yum install autoconf automake gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel
```

2、创建安装相关目录
```
mkdir ~/ffmpeg_sources ~/mplayer_build
```

3、`yasm`
```
cd ~/ffmpeg_sources
wget -c http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
#wget -c https://github.com/yasm/yasm/archive/v1.3.0.tar.gz -O "yasm-1.3.0.tar.gz"
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/mplayer_build" --enable-shared
make -j 4
make install
make distclean
export PATH=$PATH:/root/mplayer_build/bin
```


4、
```
wget http://people.redhat.com/~dhowells/keyutils/keyutils-1.5.9.tar.bz2
tar xjf keyutils-1.5.9.tar.bz2

# 修改Makefile
PREFIX      := $HOME/mplayer_build
DESTDIR     := $PREFIX
ETCDIR      := $PREFIX/etc
BINDIR      := $PREFIX/bin
SBINDIR     := $PREFIX/sbin
SHAREDIR    := $PREFIX/share/keyutils
MANDIR      := $PREFIX/share/man
INCLUDEDIR  := $PREFIX/include
```

```
wget http://web.mit.edu/kerberos/dist/krb5/1.13/krb5-1.13-signed.tar
tar xf krb5-1.13-signed.tar
tar xzf krb5-1.13.tar.gz
cd krb5-1.13/src/
./configure  --prefix=$HOME/mplayer_build --disable-shared  --enable-static

```


```
wget http://sourceforge.net/projects/openjpeg.mirror/files/2.1.0/openjpeg-2.1.0.tar.gz

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.6.17
```

```
wget http://sourceforge.net/projects/libpng/files/libpng16/1.6.13/libpng-1.6.13.tar.gz/download
./configure --prefix=$HOME/mplayer_build --disable-shared
```

```
wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz

make
make install PREFIX=$HOME/mplayer_build

```

```
 wget http://sourceforge.net/projects/freetype/files/freetype2/2.5.3/freetype-2.5.3.tar.gz
 tar xzf freetype-2.5.3.tar.gz
 cd freetype-2.5.3
./configure --prefix=$HOME --disable-shared  CFLAGS="-I$HOME/mplayer_build/include" LDFLAGS="-L$HOME/mplayer_build/lib" 
 ```
 
 ```
 wget http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
 tar xzf libogg-1.3.2.tar.gz
 cd libogg-1.3.2
 /configure --prefix=$HOME/mplayer_build --disable-shared
 make -j 8
 make install
 ```
 
 ```
 wget http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.3.tar.gz
 tar xzf opencore-amr-0.1.3.tar.gz
cd opencore-amr-0.1.3
./configure --prefix=$HOME/mplayer_build --disable-shared
make -j 8
make install
 ```

```
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2
tar xjf libtheora-1.1.1.tar.bz2
cd libtheora-1.1.1
sed -i 's/png_sizeof/sizeof/g' examples/png2theora.c
./configure --prefix=$HOME/mplayer_build --disable-shared --with-ogg=$HOME/mplayer_build
make -j 8
make install
```

```
wget http://downloads.xiph.org/releases/speex/speex-1.2rc1.tar.gz
tar xzf speex-1.2rc1.tar.gz
cd speex-1.2rc1
./configure --prefix=$HOME/mplayer_build --disable-shared
make -j 8
make install
```

```
wget http://sourceforge.net/projects/opencore-amr/files/vo-aacenc/vo-aacenc-0.1.3.tar.gz
tar xzf vo-aacenc-0.1.3.tar.gz
cd vo-aacenc-0.1.3
./configure --prefix=$HOME/mplayer_build --disable-shared
make -j 8
make install
```

```
wget http://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/vo-amrwbenc-0.1.3.tar.gz
tar xzf vo-amrwbenc-0.1.3.tar.gz
cd vo-amrwbenc-0.1.3
./configure --prefix=$HOME/mplayer_build --disable-shared
make -j 8
make install
```

```
git clone --depth 1 https://github.com/webmproject/libvpx.git
./configure --prefix=$HOME/mplayer_build --disable-shared
make -j 8
make install
```

```
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
./configure --prefix=$HOME/mplayer_build --disable-shared --with-ogg=$HOME/mplayer_build
make -j 8
make install
```


```
wget http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz
tar xzf xvidcore-1.3.2.tar.gz
cd xvidcore
cd build/generic/
./configure --prefix=$HOME/mplayer_build
```


3、 `gpac`
```
wget http://sourceforge.net/projects/gpac/files/GPAC/GPAC%200.5.0/gpac-0.5.0.tar.gz
tar xzf gpac-0.5.0.tar.gz
unzip gpac_extra_libs-0.5.0.zip
cd gpac
cp -r ../extra_libs/* extra_lib/
./configure --prefix=$HOME/mplayer_build
```



4、`x264`
>H.264 视频编码器。

```
cd ~/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --prefix="$HOME/mplayer_build" --enable-static --enable-shared
make -j 4
make install
make distclean
```

5、`fdk-acc`
> ACC音频编码器。

```
cd ~/ffmpeg_sources
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/mplayer_build" --enable-shared
make -j 4
make install
make distclean
```

6、`lame`
```
cd ~/ffmpeg_sources
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$HOME/mplayer_build" --enable-shared --enable-nasm
make -j 4
make install
make distclean
```

7、`opus`
> Opus音频编码、解码器。

```
cd ~/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzvf opus-1.1.tar.gz
cd opus-1.1
./configure --prefix="$HOME/mplayer_build" --enable-shared
make -j 4
make install
make distclean
```
8、`libogg`
> Ogg字节流库。

```
cd ~/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar xzvf libogg-1.3.1.tar.gz
cd libogg-1.3.1
./configure --prefix="$HOME/mplayer_build" --enable-shared
make -j 4
make install
make distclean
```

9、`libvorbis`
> Vorbis音频编码器。

```
cd ~/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
./configure --prefix="$HOME/mplayer_build" --with-ogg="$HOME/mplayer_build" --enable-shared
make -j 4
make install
make distclean
```

10、`libvpx`
> VP8/VP9 视频编码器。

```
cd ~/ffmpeg_sources
#wget -c http://anduin.linuxfromscratch.org/sources/other/libvpx-v1.3.0.tar.xz
#tar xvf libvpx-v1.3.0.tar.xz
#cd libvpx-v1.3.0
git clone --depth 1 https://github.com/webmproject/libvpx.git
cd libvpx
./configure --prefix="$HOME/mplayer_build" --enable-shared
make -j 4
make install
make clean
```

11、更改`ffmpeg`源代码
> `ffmpeg`不支持`SAR`、`DAR`为负数的视频。

```
# 更改ffmpeg源代码
# 目前最小化更改，不过直接用if (o->min > num) num=abs(num);也没有问题
# libavutil/opt.c:188

if (o->min > num && strcmp(o->name, "pixel_aspect") == 0) {                                                                                                                                                     
    num = abs(num);
}
```

12、`ffmpeg`
```
cd ~/ffmpeg_sources
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$HOME/mplayer_build/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$HOME/mplayer_build" --extra-cflags="-I$HOME/mplayer_build/include" --extra-ldflags="-L$HOME/mplayer_build/lib" --extra-libs=-ldl --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264
make -j 4
make install
make distclean
```

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
--extra-cflags="-I$HOME/mplayer_build/include --static" \
--extra-ldflags="-L$HOME/mplayer_build/lib" \
--extra-libs='-static -lpng -lbz2 -lm -lz -lkrb5 -lkrb5support -lk5crypto -lcom_err -lkeyutils -lresolv'


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
--extra-cflags="-I$HOME/mplayer_build/include --static" \
--extra-ldflags="-L$HOME/mplayer_build/lib" \
--extra-libs=-ldl

