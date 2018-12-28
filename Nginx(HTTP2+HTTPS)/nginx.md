# 配置带有 HTTP2 和 HTTPS 的 Nginx
感谢 NGiИX configuration generator 的支持
[Github](https://github.com/valentinxxx/nginxconfig.io)
[官方网站](https://nginxconfig.io/)


## 配置安装参数
./configure --prefix=/data/nginx --sbin-path=/data/nginx/sbin/nginx --conf-path=/data/nginx/conf/nginx.conf --error-log-path=/log/nginx/error.log --pid-path=/data/nginx/run/nginx.pid --lock-path=/data/nginx/run/nginx.lock --http-log-path=/log/nginx/access.log --user=www --group=www --with-http_ssl_module --with-http_dav_module --with-http_flv_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_stub_status_module --with-http_sub_module --with-http_random_index_module --with-http_degradation_module --with-http_secure_link_module --with-http_gzip_static_module --with-http_perl_module --with-pcre --with-file-aio --with-mail --with-mail_ssl_module --http-client-body-temp-path=/data/nginx/run/client_body --http-proxy-temp-path=/data/nginx/run/proxy --http-fastcgi-temp-path=/data/nginx/run/fastcgi --http-uwsgi-temp-path=/data/nginx/run/uwsgi --http-scgi-temp-path=/data/nginx/run/scgi --with-stream --with-ld-opt="-Wl,-E" --with-http_v2_module

## Nginx 目录结构
```
/data/nginx/
|-- conf
|   |-- fastcgi.conf
|   |-- fastcgi.conf.default
|   |-- fastcgi_params
|   |-- fastcgi_params.default
|   |-- koi-utf
|   |-- koi-win
|   |-- mime.types
|   |-- mime.types.default
|   |-- nginx.conf
|   |-- nginx.conf.default
|   |-- pub
|   |   |-- nginxconfig.io
|   |   |   |-- general.conf
|   |   |   |-- letsencrypt.conf
|   |   |   `-- python_uwsgi.conf
|   |   |-- nginxconfig.io.conf
|   |-- scgi_params
|   |-- scgi_params.default
|   |-- uwsgi_params
|   |-- uwsgi_params.default
|   `-- win-utf
|-- html
|   |-- 50x.html
|   `-- index.html
|-- run
|   |-- client_body
|   |-- fastcgi
|   |-- nginx.pid
|   |-- proxy
|   |-- scgi
|   `-- uwsgi
`-- sbin
    |-- nginx
    `-- nginx.bak
```

## 使用"Let’s Encrypt"配置HTTPS(webroot方式)
#### 获取 Certbot 客户端
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto

#### 配置 nginx 、验证域名所有权
1. 创建 ACME-challenge 目录
mkdir -p /etc/letsencrypt/live/nginxconfig.io/ && chown www /etc/letsencrypt/live/nginxconfig.io/
2. 禁用SSL
sed -i -r 's/(listen .*443)/\1;#/g; s/(ssl_(certificate|certificate_key|trusted_certificate) )/#;#\1/g' /data/nginx/conf/pub/nginxconfig.io.conf
3. 运行 nginx
4. 获取证书
./certbot-auto certonly --webroot -d nginxconfig.io --email info@mail.com -w /var/www/_letsencrypt -n --agree-tos --force-renewal
5. 启用SSL
sed -i -r 's/#?;#//g' /data/nginx/conf/pub/nginxconfig.io.conf

