## 安装`sentry`

```sh
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-7.0.tar.gz#md5=6245d6752e2ef803c365f560f7f2f94
tar xzf setuptools-7.0.tar.gz && cd setuptools-7.0
python setup.py install
easy_install pip
pip install virtualenv
```

#### 1. 
```sh
useradd sentry
su - sentry
```

#### 2. 安装`python`依赖环境
```sh
virtuanlenv 
pip install sentry
```

#### 3. 初始化管理员密码
```sh
sentry --config=.sentry/sentry.conf.py createsuperuser
sentry -–config=.sentry/sentry.conf.py repair –owner=
```