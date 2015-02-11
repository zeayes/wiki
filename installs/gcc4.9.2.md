#### centos gcc4.9.2
```Bash
yum install -y wget
wget ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.9.2/gcc-4.9.2.tar.bz2
tar xjf gcc-4.9.2.tar.bz2
cd gcc-4.9.2
./contrib/download_prerequisites
cd .. && mkdir gcc_build
cd gcc_build
../gcc-4.9.2/configure --prefix=/usr/local/gcc-4.9.2 --exec-prefix=/usr/local/gcc --enable-languages=c,c++ --disable-multilib --enable-checking=release 
```
