1. 安装`aclocal`依赖库
```
yum install -y libtool
```

2. 安装`notify-tools`
```
wget https://codeload.github.com/rvoicilas/inotify-tools/zip/v3.14
unzip v3.14 && cd inotify-tools-3.14
./autogen.sh
./configure --prefix=/usr/local/inotify-tools-3.14
make -j 8
make install
```

3. 监控文件创建、修改、移入事件
```sh
/usr/local/inotify-tools-3.14/bin/inotifywait -m -q -e CREATE -e MODIFY -e MOVED_TO -r /var/www --timefmt "%F %T" --format "%T %e %w%f" --outfile "notify-edit.log" --excludei '\.(jpg|png|gif)$'
```

4. 监控文件创建、修改、移入事件，并打包
```sh
/usr/local/inotify-tools-3.14/bin/inotifywait -m -q -e CREATE -e MODIFY -e MOVED_TO -r /var/www --timefmt "%F %T" --format "%T %e %w%f" --outfile "notify-edit.log" --excludei '\.(jpg|png|gif)$' |
    while read file
    do
        if [[ $file =~ \.(html|css|js|xml)$ ]];
        then
            gzip -f -c -1 $file > $file.gz
        fi
    done
```

5. 监控文件删除事件
```sh
/usr/local/inotify-tools-3.14/bin/inotifywait -m -q -e DELETE -r "/var/www" --timefmt "%F %T" --format "%T %e  %w%f" --outfile "notify-delete.log" --excludei '\.(jpg|png|gif)$'
```

6. 监控文件删除事件，并删除打包文件
```sh
/usr/local/inotify-tools-3.14/bin/inotifywait -m -q -e DELETE -r "/var/www" --timefmt "%F %T" --format "%T %e  %w%f" --outfile "notify-delete.log" --excludei '\.(jpg|png|gif)$' |
    while read file
    do
        if [[ -f $file.gz ]];
        then
            rm $file.gz
        fi
    done
```