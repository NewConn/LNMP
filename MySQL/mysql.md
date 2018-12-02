# MySQL安装环境准备

### 是否安装了mysql
rpm -qa | grep mysql

##### 普通删除模式
rpm -e mysql

##### 强力删除模式，如果使用上面命令删除时，提示有依赖的其它文件，则用该命令可以对其进行强力删除
rpm -e --nodeps mysql

### 添加用户及用户组 
groupadd -g 3306 mysql 
useradd mysql -u 3306 -g 3306 -d /nonexistent -s /sbin/nologin


# 编译MySQL

### 下载源码
wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.29.tar.gz

### 解压源码
tar xvf mysql-5.6.29.tar.gz
cd mysql-5.6.29

### 配置安装参数
cmake . -DCMAKE_INSTALL_PREFIX=/data/mysql -DMYSQL_UNIX_ADDR=/data/mysql/run/mysql.sock  -DDEFAULT_CHARSET=utf8  -DDEFAULT_COLLATION=utf8_general_ci  -DWITH_INNOBASE_STORAGE_ENGINE=1  -DWITH_READLINE=1  -DENABLED_LOCAL_INFILE=1  -DMYSQL_DATADIR=/data/mysql/data  -DMYSQL_USER=mysql  -DMYSQL_TCP_PORT=3306  -DWITH_EXTRA_CHARSETS=all
###安装MySQL
make && make install && make clean

### mysql 8.0之后依赖boost解决方案
下载mysql-boost源码并解压, cmake时加上 * -DWITH_BOOST=./boost/ * , 无需编译boost


# 配置MySQL

### 配置my.cnf
rm /etc/my.cnf
vi /data/mysql/my.cnf

### 设置MySQL目录及权限
mkdir /log/mysql/
mkdir /data/mysql/run
chown -R mysql:mysql /data/mysql/

### 初始化MySQL, 输入密码的时候，直接回车
/data/mysql/scripts/mysql_install_db --user=mysql --basedir=/data/mysql --datadir=/data/mysql/data & 
/data/mysql/bin/mysqld_safe &

### 设置MySQL密码
/data/mysql/bin/mysql -uroot -p
mysql> use mysql;
mysql> UPDATE `user` SET `Password`=PASSWORD('123456') WHERE `User`='root';
mysql> flush privileges;

### 查找MySQL的pid
ps -ef | grep mysql
* mysql     54778  54702  0 15:59 pts/1    00:00:00 /data/mysql/bin/mysqld *

cat /data/mysql/run/mysql.pid
* 54778 *
### 结束mysql进程
kill 54778      
ps -aux | grep mysql


# 配置MySQL系统服务

### 创建mysqld
support-files目录下有一个mysql.server，可以通过该文件启动MySQL服务器./support-files/mysql.server start。更常用的是将MySQL配置为系统服务，首先将其复制到/etc/init.d/目录并重命名为mysqld：

cp support-files/mysql.server /etc/init.d/mysqld

### 添加开机启动服务
##### 使用chkconfig将mysqld添加为开机自启动服务：
chkconfig --add mysqld

##### 检查添加是否成功：
chkconfig --list mysqld
mysqld         	0:关闭	1:关闭	2:启用	3:启用	4:启用	5:启用	6:关闭

### 启动MySQL服务器
##### 添加为系统服务后，就可以通过service命令来启动MySQL服务器：
service mysqld start

#####检查启动是否成功：
netstat -anp|grep mysqld
tcp        0      0 0.0.0.0:3306                0.0.0.0:*                   LISTEN      17307/mysqld        
unix  2      [ ACC ]     STREAM     LISTENING     831113 17307/mysqld        /tmp/mysql.sock


# 注意事项
1. 在启动MySQL服务时，会按照一定次序搜索my.cnf，先在/etc目录下找，找不到则会搜索"$basedir/my.cnf"，在本例中就是 /data/mysql/my.cnf，这是新版MySQL的配置文件的默认位置！

2. 在CentOS 6.4版操作系统的最小安装完成后，在/etc目录下会存在一个my.cnf，需要将此文件更名为其他的名字，如：/etc/my.cnf.bak，否则，该文件会干扰源码安装的MySQL的正确配置，造成无法启动。

3. 在使用"yum update"更新系统后，需要检查下/etc目录下是否会多出一个my.cnf，如果多出，将它重命名成别的。否则，MySQL将使用这个配置文件启动，可能造成无法正常启动等问题。