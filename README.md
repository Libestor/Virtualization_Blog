### 一键创建虚拟化博客

#### 作者:libestor

>  邮箱：libestor@qq.com

### 简介

1. 使用虚拟化容器podman，同样的docker也可以使用
2. 有一键运行的功能，但是没有很强的矫正能力。
3. 镜像都一样的镜像，我的能运行的起，其他的也能运行的起
4. 能一键检查宿主机的配置是否符合（还在开发）
5. 需要自己下载部分文件（后期会写自动下载脚本）
6. 容器和本地都有建立卷，就放在用户目录下的nginx，php，mysql，wordpress里面包含日志和配置文件，mysql包含库

### 使用

1. 检查本地是否已经按安装docker或者podman以及对应的compose
2. 下载需要的文件 prce zlib sqlite3 openssl nginx php
3. 下载修改名字为上述名字，例如：`cp php-8.0 php`
4. 设置mysql的密码在compose文件中
5. 然后运行podman-compose up(或者docker-compose up) **在root用户下运行,不管是不是podman**
6. 等待亿会会（真的是亿会会）
7. 先进入mysql容器创建wordpress的数据库：`create databases wordpress;`
8. 然后访问80端口网站

### 注意事项

1. mysql默认开启了远程连接
2. php-fpm启动的时候需要指定php-fpm.conf
3. 部分文件的存在可能会导致密码的泄露
3. 没有写自动创建wordpress库的脚本，感觉好麻烦。

