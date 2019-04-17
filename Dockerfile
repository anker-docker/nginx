# base image(指定所创建镜像的基础镜像)
FROM centos

# Maintainer(维护者)
LABEL maintainer docker_user<lizengcai_vip@sina.com>

# put nginx-1.14.2.tar.gz into /usr/local/src and unpack nginx(添加本地内容到镜像)
ADD nginx-1.14.2.tar.gz /usr/local/src
ADD v0.61.tar.gz /usr/local/src

#running required command(创建新的镜像)
RUN yum install -y gcc gcc-c++ glibc make autoconf openssl openssl-devel
RUN yum install -y libxslt-devel gd gd-devel GeoIP GeoIP-devel pcre pcre-devel
RUN useradd -M -s /sbin/nologin nginx 
RUN mkdir -p /usr/local/nginx/conf/conf.d

# change dir to /usr/local/src/nginix-1.14.2(为后续的RUN, CMD, ENTRYPOINT指令配置工作目录)
WORKDIR /usr/local/src/nginx-1.14.2

# execute command to compile nginx
RUN ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-file-aio --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module --add-module=../echo-nginx-module-0.61
RUN make && make install

# 配置环境变量
ENV PATH /usr/local/nginx/sbin:$PATH
EXPOSE 80

# 容器启动时运行
CMD ["nginx", "-c", "/usr/local/nginx/conf/nginx.conf"]
