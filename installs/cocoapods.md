### cocoapods

#### 1. `ruby` gem
```Bash
sudo gem update --system
gem sources -l
gem sources --remove https://rubygems.org/
gem sources -a http://ruby.taobao.org/
gem sources -l
```

#### 2. install
```Bash
sudo gem install cocoapods
pod setup
```

#### 3. 错误处理
```Bash
pod install
Analyzing dependencies
[!] There was an error reading '/Users/zeayes/.cocoapods/repos/master/CocoaPods-version.yml'.
Please consult http://blog.cocoapods.org/Repairing-Our-Broken-Specs-Repository/ for more information
```
解决方案
```
sudo gem uninstall psych
sudo gem install psych -v 2.0.0
```
