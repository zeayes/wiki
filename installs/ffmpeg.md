#### centos安装ffmpeg

`ffmpeg`官网安装[文档](https://trac.ffmpeg.org/wiki/CompilationGuide/Centos)。

1、安装依赖
```sh
yum install autoconf automake gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel
```

2、创建安装相关目录
```
mkdir ~/ffmpeg_sources ~/ffmpeg_build
```

3、`yasm`
````
cd ~/ffmpeg_sources
wget -c http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
#wget -c https://github.com/yasm/yasm/archive/v1.3.0.tar.gz -O "yasm-1.3.0.tar.gz"
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make -j 4
make install
make distclean
export PATH=$PATH:/root/ffmpeg_build/bin
```

4、`x264`
>H.264 视频编码器。

```
cd ~/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --prefix="$HOME/ffmpeg_build" --enable-static --enable-shared
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
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
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
./configure --prefix="$HOME/ffmpeg_build" --enable-shared --enable-nasm
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
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
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
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
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
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --enable-shared
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
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
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
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --extra-libs=-ldl --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264
make -j 4
make install
make distclean
```
