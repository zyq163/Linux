#!/bin/bash
#version:1.6, 日期:2019.5.23

#检查yum源
yum clean all
yum repolist
#使用yum安装基础依赖包
yum -y install gcc openssl-devel pcre-devel
if [ $? -eq 0 ];then
     echo -e "\033[32myum源正常\033[0m"
else
     echo -e "\033[31myum源不可用\033[0m";exit 1
fi
sleep 1

#这里将解压包放在根下
tar -xPf /lnmp_soft.tar.gz -C /
if [ $? -eq 0 ];then
     echo -e "\033[32m解压成功\033[0m"
else 
     echo -e "\033[31m解压失败\033[0m";exit 2
fi
sleep 1

tar -xPf /lnmp_soft/nginx-1.12.2.tar.gz -C /
if [ $? -eq 0 ];then
      echo -e "\033[32m解压成功\033[0m"
else 
      echo -e "\033[31m解压失败\033[0m";exit 3
fi
sleep 1

#源码安装Nginx
cd /nginx-1.12.2
useradd -s /sbin/nologin nginx
./configure --user=nginx --group=nginx --with-http_ssl_module --with-stream 
make && make install #编译并安装

#安装MariaDB数据库
yum -y install  mariadb  mariadb-server  mariadb-devel

#安装PHP
yum -y install  php  php-mysql
yum -y install  php-fpm

#重启服务
systemctl stop httpd
systemctl start mariadb
systemctl status mariadb
systemctl enable mariadb
systemctl start  php-fpm
systemctl status php-fpm
systemctl enable php-fpm

/usr/local/nginx/sbin/nginx
netstat -anptul | grep nginx


