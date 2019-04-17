# docker安装lnmp环境
### 1.docker安装mysql
```php
1. 拉取镜像
docker pull mysql:5.7
2. 运行容器
# -e: 设置初始密码
docker run \
-d \
-p 3306:3306
-e MYSQL_ROOT_PASSWORD=12345678910 \
--name m_mysql mysql:5.7
3.开启mysql远程连接
mysql -uroot -p1234567890
use mysql
> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
> FLUSH PRIVILEGES;
4.重启
service mysqld restart
```
### 2. 部署php
```php
1. 拉取镜像
docker pull bitnami/php-fpm:7.0
2. 运行容器
docker run \
-d \
-p 9000:9000 \
-v /data/wwwroot:/usr/local/nginx/html \
--link m_mysql:mysql \
--name m_phpfpm bitnami/php-fpm:7.0
```
### 3.部署nginx
```php
1. 拉取镜像
docker pull centos:latest
2. 运行dockerfile
docker build -t m_nginx:v1 .
3. 运行容器
docker run \
-d \
-p 8080:8080 \
-p 8081:8081 \
-p 8082:8082 \
-p 8083:8083 \
-v /data/wwwroot:/usr/local/nginx/html \
-v /data/nginx/nginx.conf:/usr/local/nginx/conf/nginx.conf:ro \
-v /data/nginx/conf:/usr/local/nginx/conf/conf.d \
-v /data/wwwlogs:/usr/local/nginx/logs \
--link m_phpfpm:phpfpm \
--name my_nginx m_nginx:v1 nginx -g "daemon off;"
```




