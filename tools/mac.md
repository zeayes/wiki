### `MAC`显示Finder完整路径
```sh
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
```

### `MAC`显示所有文件
```sh
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder AppleShowAllFiles -bool false
```
#### `MAC`开启`sshd`
```sh
sudo /usr/bin/ssh-keygen -t rsa -f /etc/ssh_host_rsa_key
sudo /usr/bin/ssh-keygen -t dsa -f /etc/ssh_host_dsa_key
sudo /usr/sbin/sshd
```
