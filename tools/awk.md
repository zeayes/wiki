## awk

[awk](http://www.gnu.org/software/gawk/)是一个文本处理语言，它把文件作为记录序列处理。

##### 说明

1.记录：以NS分割文件后的每一个单元称作记录，NS默认为换行符。

2.字段：以FS分割记录后的每一个单元称作字段，FS默认为空格或tab。

##### 用法
```
awk 'pattern {action}' {filenames}
```
* pattern：表示需匹配记录的规则。
* action：表示匹配到内容时，执行的命令。
* pattern可以是`BEGIN`或`END`，分别表示读取所有记录之前和之后。

【说明】

1. 没有pattern，则所有的记录都会执行action，如：```awk '{print $0}' filename```，输出filename中的所有记录。
2. 没有action，则输出匹配的记录，如：```awk '/pattern/' fliename```，输出filename中所有匹配 ***pattern*** 的记录。

##### 内置变量


变量名    |     说明
---------|---------------
 $n      | 当前记录的n个字段
 $0      | 整条记录
ARGC     | 命令行参数数量
ARGV     | 命令行参数数组
ENVIRON  | 环境变量
FILENAME | 文件名
FS       | 字段分隔符
RS       | 记录分隔符
OFS      | 输出字段分隔符
ORS      | 输出记录分隔符
OFMT     | 输出数字格式
NF       | 当前记录中字段数
NR       | 当前记录数

##### 常用内置函数
 函数            |  说明
----------------|------------------------------- 
gsub(r,s)       | 在整个$0中用s代替r
gsub(r,s,t)     | 在整个t中用s替代r
index(s,t)      | 返回s中字符串t的第一位置
length(s)       | 返回s长度
match(s,r)      | 测试s是否包含匹配r的字符串
split(s,a,fs)   | 在fs上将s分成序列a
sprint(fmt,exp) | 返回经fmt格式化后的exp
sub(r,s)        | 用$0中最左边最长的子串代替s
substr(s,p)     | 返回字符串s中从p开始的后缀部分
substr(s,p,n)   | 返回字符串s中从p开始长度为n的后缀部分
int(n)          | 取整

##### 运算符

运算符 | 说明
------|-----------
 +    | 加
 -    | 减
 *    | 乘
 /    | 除
 %    | 取余
 ^    | 幂
 ++   | 自加
 --   | 自减
 +=	  | 相加后赋值
 -=   | 想减后赋值
 *=   | 相乘后赋值
 /=   | 相除后复制
 %=   | 取余后赋值
 \>    | 大于
 <    | 小于
 \>=   | 大于等于
 <=   | 小于等于
 ==   | 等于
 !=   | 不等于
 ~    | 匹配
 !~   | 不匹配
 &&   | 与
 \|\|   | 或
 !    | 非
 in   | 数组成员


##### 控制语句
1. `if` 语法

   ```
    if (expression) {
    	statement;
    } else if {
    	statement;
    } else {
    	statement;
    }
    ```
2. `for` 语法

   ```
    for (i = 1; i < NF; i++) {
    	statement;
    }
    ```  
3. `while` 语法

   ```
    while (condition) {
    	statement;
    }
    ```
4. `do while` 语法

   ```
    do {
    	action;
    } while {
    	statement;
    }
    ```
    
##### 常见实例
1. 对第三列求和

	``` awk -F "," '{sum+=$3} END {print sum}' test.csv ```
2. 对第三列匹配求和
	
	``` awk -F "," ' $3 ~ /^CG/ {sum+=$5} END { print sum}' test.csv ```
3. 统计本机用户数量

	``` awk -F ":" 'BEGIN {count=0;} { if (NF == 7) count=count+1; } END{print "user count is ", count}' /etc/passwd ```
4. 显示本机的账户

	``` awk -F ':' 'BEGIN {count=0;} {name[count] = $1;count++;}; END{for (i = 0; i < NR; i++) print i, name[i]}'  /etc/passwd ```
5. 统计空白行总数量

	``` awk  '/^$/ {x+=1}  END {print x}' test.csv ```
