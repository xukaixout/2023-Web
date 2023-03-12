# 高级Web技术Lab 1： Docker部署

## 使用Docker

实验要求：成功配置Docker并部署给出的项目

Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的镜像中，然后发布到任何流行的Linux或Windows机器上，也可以实现虚拟化。

> 准备Docker环境

可以查阅Docker的[官方配置文档](https://docs.docker.com/engine/install/ubuntu/)

Ubuntu系统一般已经在包管理器种添加了Docker的位置，可以直接使用以下命令进行安装：

``` bash
sudo apt install docker-ce 
```

安装完成后，使用以下命令判断docker是否安装成功：

``` bash
sudo docker run hello-world
```

> 编写dockerfile

``` bash
mkdir maven_tomcat
cd maven_tomcat
vim Dockerfile
```

在vim中按i进入编辑模式，输入以下内容：（或根据对应demo给出的dockerfile）

``` dockerfile
FROM maven:3.6.3-jdk-8
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME
ENV TOMCAT_VERSION 8.5.87
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-8/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
RUN set -x \
&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
&& tar -xvf tomcat.tar.gz --strip-components=1 \
&& rm bin/*.bat \
&& rm tomcat.tar.gz*
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

解释：在一个maven基础镜像上叠加tomcat，最终运行java项目时只需要这一个镜像即可完成编译+打包+部署。

执行以下命令以build此基础镜像

``` bash
sudo docker build -t maven_tomcat .
```

使用 -t 参数指定镜像名称:标签， . 表示使用当前目录下的 Dockerfile, 还可以通过-f 指定 Dockerfile 所在路径。

此时执行`sudo docker images`，可以看到一个叫`maven_tomcat`的镜像。

> MySQL安装与配置

参见[MySQL文档](MySQL.md)

> 运行容器

``` bash
sudo docker run -idt --name demo -p <outter_port>:<inner_port> maven_tomcat
```

`outter_port`和`inner_port`是宿主机和docker的端口映射关系，如`10080:80`表示宿主机将10080端口监听到的数据转发给docker容器中的80端口，此时docker容器中应当对80端口设置监听。

> 部署项目

``` bash
sudo docker exec -it demo /bin/bash # 进入容器
git https://github.com/xukaixout/2023-Web.git
cd 2023-Web/lab1/demo/ssm # 或html5_websocket
```

按照对应项目的需求进行配置即可。

## 错误排除

