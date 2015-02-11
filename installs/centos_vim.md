#### 安装`vim 7.4`

#### `TOOL`
```Bash
yum install -y git wget ctags cscope ncurses ncurses-devel
yum remove vim vim-enhanced vim-common vim-minimal
```

#### `VIM`
```Bash
cd /data/Download
wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
./configure --with-features=huge \
            --enable-multibyte \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib64/python2.6/config \
            --enable-cscope --prefix=/usr
make -j 6
make install
```

#### `YouCompleteMe`
> 首先要安装`clang`
```Bash
mkdir -p .vim/bundle
cd .vim/bundle
git clone https://github.com/Valloric/YouCompleteMe
cd YouCompleteMe
git submodule update --init --recursive
cd ~ && mkdir ycm_build && cd ycm_build
cmake -G "Unix Makefiles" -DEXTERNAL_LIBCLANG_PATH=/usr/local/lib/libclang.so . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/
make ycm_core
make ycm_support_libs
```
