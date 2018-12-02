# 编译Nginx

### 下载Nginx源码
wget http://mirrors.sohu.com/nginx/nginx-1.9.9.tar.gz

### 解压源码
tar -zxvf nginx-1.9.9.tar.gz
cd nginx/

### 配置安装参数
./configure --prefix=/data/nginx --sbin-path=/data/nginx/sbin/nginx --conf-path=/data/nginx/conf/nginx.conf --error-log-path=/log/nginx/error.log --pid-path=/data/nginx/run/nginx.pid --lock-path=/data/nginx/run/nginx.lock --http-log-path=/log/nginx/access.log --user=www --group=www --with-http_ssl_module --with-http_dav_module --with-http_flv_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_stub_status_module --with-http_sub_module --with-http_random_index_module --with-http_degradation_module --with-http_secure_link_module --with-http_gzip_static_module --with-http_perl_module --with-pcre --with-file-aio --with-mail --with-mail_ssl_module --http-client-body-temp-path=/data/nginx/run/client_body --http-proxy-temp-path=/data/nginx/run/proxy --http-fastcgi-temp-path=/data/nginx/run/fastcgi --http-uwsgi-temp-path=/data/nginx/run/uwsgi --http-scgi-temp-path=/data/nginx/run/scgi --with-stream --with-ld-opt="-Wl,-E"  --with-debug

### 安装
make && make install && make clean


# 配置Nginx

### 添加用户及用户组
groupadd -g 80 www
useradd www -u 80 -g 80 -d /nonexistent -s /sbin/nologin

### 查看cpu核心数
cat /proc/cpuinfo

### 修改Nginx配置文件nginx.conf 
mv /data/nginx/conf/nginx.conf /data/nginx/conf/nginx_bak.conf
vi /data/nginx/conf/nginx.conf

### 修改网站配置文件localhost.conf
mkdir /data/nginx/conf/pub
vi /data/nginx/conf/pub/localhost.conf 

### 配置nginx的fastcgi.conf文件
mv /data/nginx/conf/fastcgi.conf /data/nginx/conf/fastcgi.conf.bak
vi /data/nginx/conf/fastcgi.conf

### 设置Nginx目录及权限
mkdir /log/domain
mkdir /log/domain/localhost
mkdir /site/domain/localhost
mkdir /site/domain/localhost/htdocs
chown -R www:www /log/domain
chown -R www:www /log/nginx


# 运行Nginx
/data/nginx/sbin/nginx