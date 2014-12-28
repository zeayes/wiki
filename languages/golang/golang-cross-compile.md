### `Golang`交叉编译

#### 1. 编译目标平台的`Golang`版本
```Bash
GOOS=linux GOARCH=amd64 cd $(GOROOT)/src; ./make.bash --no-clean
```
编译完成后，会有一下目录：
```Bash
$(GOROOT)/pkg/linux_amd64
```


#### 2. 编译目标平台可执行文件
```Bash
GOOS=linx GOARCH=amd64 go build main.go -o target
```


