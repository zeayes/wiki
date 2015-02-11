#### 安装`clang`

```Bash
yum install -y git svn cmake gcc gcc-c++ glibc-static
wget http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz
wget http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz
wget http://llvm.org/releases/3.3/clang-tools-extra-3.3.src.tar.gz
wget http://llvm.org/releases/3.3/compiler-rt-3.3.src.tar.gz
wget http://llvm.org/releases/3.3/libcxx-3.3.src.tar.gz
tar xzf *.tar.gz
mv cfe-3.3.src clang
mv clang llvm-3.3.src/tools/
mv clang-tools-extra-3.3.src extra
mv extra/ llvm-3.3.src/tools/clang/
mv compiler-rt-3.3.src compiler-rt
mv compiler-rt llvm-3.3.src/projects/
mkdir build-3.3
cd build-3.3/
../llvm-3.3.src/configure --enable-optimized --enable-targets=host-only
make -j 6
make install
```
