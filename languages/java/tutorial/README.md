### `java`命令行入门
`java` 是一门编译型语言，所以`java`源代码需要先编译，然后再运行。

#### 1. 基本用法
1. `javac Test.java`会编译`Test.java`文件，编译后的中间码输出到`Test.class`文件。

2. `java Test` 会运行编译后的文件。

#### 2. 包管理
1. 创建包及包文件
```sh
mkdir -p com/zeayes/simple
cd com/zeayes/simple
touch Vector.java List.java
```

2. 在任意地方创建测试包文件的测试代码
```sh
touch LibTest.java
```
3. 打包`jar`
```
javac com/zeayes/simple/*.java
jar cvf com.zeayes.simple.jar com/zeayes/simple/*.class
```
4. 引入`jar`文件执行
```
cd test
avac -classpath .:../com.zeayes.simple.jar LibTest.java
java -classpath .:../com.zeayes.simple.jar LibTest
```