#### `mac`下使用`homebrew`安装`mysql`
##### 1.1 安装
```sh
brew install mysql
```
`mysql`会安装到`/usr/local/Cellar`目录，我安装的是`5.6.20`版本。

##### 1.2. 添加开机启动
```sh
cp /usr/local/Cellar/mysql/5.6.20/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents
```
##### 1.3 启动
```
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```
##### 1.4 停止
```sh
launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```
##### 1.5 修改运行地址
```
vim ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```
修改其中的`--bind-address`参数。