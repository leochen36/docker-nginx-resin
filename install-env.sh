#!/bin/bash
## centos 自助安装脚本

NGINX_VERSION=1.9.15
TENGINE_VERSION=2.1.2
PHP_VERSION=5.6.9
REDIS_VERSION=3.0.7
ANT_VERSION=1.9.6
M2_VERSION=3.3.9
JDK_VERSION=1.8.0_77
JDK_PACKAGE=8u77-b03
JDK_FILE_NAME=jdk-8u77-linux-x64.tar.gz
NODE_VERSION=4.4.3
MYWEBSQL_VERSION=3.6
MAVEN_VERSION=3.3.9
#RESIN_VERSION=4.0.47
JETTY_VERSION=9.3.9.v20160517
#JETTY_FILE_NAME=jetty-9.3.8.tar.tz


##安装控制
INSTALL_BASE_ENVI=true   ##基础环境

INSTALL_JDK=true
INSTALL_NGINX=false
INSTALL_PHP=false
INSTALL_REDIS=true
INSTALL_MYSQL=false
INSTALL_RUBY=true
INSTALL_SAAS=true  #css自动化的构建
INSTALL_NODE=true
INSTALL_NODE_GRUNT=true
INSTALL_MYWEBSQL=false
INSTALL_MAVEN=true   #maven
INSTALL_JETTY=TRUE  #jetty


##删除文件方法,防止删除系统目录
function _rmdir(){
	local cLength=${#1}
	echo "_rmdir $1 $cLength"
	if [ $cLength -lt 13 ] 
	then
		echo "此目录名长度太短,要>10个"
	elif [ $1 = "/bin" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/lib" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/etc" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/sys" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/usr" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/mnt" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/opt" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/var" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/dev" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/sbin" ]
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/proc" ] 
	then 
		echo "此目录不能删除[$1]"
	elif [ $1 = "/usr/local" ] 
	then 
		echo "此目录不能删除[$1]"
	else 
		rm -rf $1
		echo "ok"
	fi
}



##install 基础环境 start ########################################

if [ "$INSTALL_BASE_ENVI" = "true" ]  
then 
	echo "start>>>"
	### 如果/sbin/service 丢失,执行下面命令安装
	yum install -y initscripts  
	
	##安装基础组件
	yum -y install make gcc gcc-c++ glibc make cmake automake bison-devel  ncurses-devel libtool lrzsz wget zip unzip openssh-clients expect
	##yum -y install ant
	echo "install jemalloc"
	yum -y install jemalloc
	
	
	##install openssl
	echo "install openssl"
	yum -y remove openssl
	yum -y install openssl openssl-devel
	
	##install pcre
	echo "install pcre"
	yum install -y pcre-devel 
	yum install -y perl perl-devel perl-ExtUtils-Embed
	
	
	yum -y install libmcrypt-devel mhash-devel libxslt-devel \
	libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel \
	zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel \
	ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel \
	krb5 krb5-devel libidn libidn-devel 
fi
##install 基础环境 end ########################################




##install jdk start ########################################
if [ "$INSTALL_JDK" = "true" ]  
then    
	echo "\r\n\r\n==============================="
	echo "install jdk start JDK_FILE_NAME=$JDK_FILE_NAME, JDK_PACKAGE=$JDK_PACKAGE"
	
	##安装路径
	installPath="/usr/local/jdk-$JDK_VERSION"
	##映射路径
	mapPath="/usr/local/java"
	
	echo "installPath:$installPath, mapPath:$mapPath"
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f  "$JDK_FILE_NAME" ]; then  
		echo "wget jdk $JDK_FILE_NAME http://download.oracle.com/otn-pub/java/jdk/$JDK_PACKAGE/$JDK_FILE_NAME"
		curl -L -b "oraclelicense=a" http://download.oracle.com/otn-pub/java/jdk/$JDK_PACKAGE/$JDK_FILE_NAME -O
	fi 
		
	rpm -qa | grep java 
	yum remove -y java*
	_rmdir "$installPath"
	tar zxf  $JDK_FILE_NAME
	_rmdir "$installPath"
	mv -f jdk$JDK_VERSION "$installPath"
	_rmdir "$mapPath" && ln -s "$installPath" "$mapPath"
	export PATH=$PATH:/usr/local/java/bin
	
	
	echo "install jdk end"
fi  
##install jdk end ########################################


##install jetty start ########################################
if [ "$INSTALL_JETTY" = "true" ]  
then    
	echo "\r\n\r\n==============================="
	echo "install jetty start "
	
	##安装路径
	installPath="/usr/local/jetty-distribution-$JETTY_VERSION"
	##映射路径
	mapPath="/usr/local/jetty"
	
	echo "installPath:$installPath, mapPath:$mapPath"
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f  "jetty-distribution-$JETTY_VERSION.tar.gz" ]; then  
		echo "wget jetty"
		wget "http://ftp.jaist.ac.jp/pub/eclipse/jetty/stable-9/dist/jetty-distribution-$JETTY_VERSION.tar.gz"  ###-O jetty-$JETTY_VERSION.tar.gz
	fi 
		
	_rmdir "$installPath"
	tar zxf jetty-distribution-$JETTY_VERSION.tar.gz
	mv -f jetty-distribution-$JETTY_VERSION "/usr/local/"
	_rmdir "$mapPath" && ln -s "$installPath" "$mapPath"	
	
	echo "install jetty end"
fi
##install jetty end ########################################




##install nginx start ########################################
if [ "$INSTALL_NGINX" = "true" ]  
then 	
	echo "install nginx  start"
	installPath="/usr/local/nginx-$NGINX_VERSION"
	mapPath="/usr/local/nginx"
	
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f "nginx-$NGINX_VERSION.tar.gz" ]; then  
		echo "wget nginx"
		wget "http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz"
	fi  
	tar -zxf nginx-$NGINX_VERSION.tar.gz
	cd nginx-$NGINX_VERSION
	./configure --prefix="$installPath" \
	--with-http_stub_status_module \
	--with-http_gzip_static_module \
  --with-http_perl_module \
	--with-http_ssl_module 
	make
	make install
	_rmdir "$mapPath" && ln -s "$installPath" "$mapPath"
	
	cd ../
	echo "install nginx end"

fi
##install nginx end ########################################
	
	


##install  nginx start ########################################
if [ "$INSTALL_TENGINE" = "true" ]  
then  
	echo "install tengine  start"
	installPath="/usr/local/tengine-$TENGINE_VERSION"
	mapPath="/usr/local/nginx"
	
	if [ ! -f "/etc/init.d/nginx" ]; then  
		echo "cp nginx"
		cp "nginx" "/etc/init.d/nginx"
	fi  
	chmod a+x "/etc/init.d/nginx"
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f "tengine-$TENGINE_VERSION.tar.gz" ]; then  
		echo "wget tengine"
		wget "http://tengine.taobao.org/download/tengine-$TENGINE_VERSION.tar.gz"
	fi  
	tar zxf tengine-$TENGINE_VERSION.tar.gz
	cd tengine-$TENGINE_VERSION
	##./configure --prefix="$installPath" --with-http_stub_status_module --without-http_gzip_module  --with-http_perl_module 
	./configure --prefix="$installPath" \
		--with-http_stub_status_module \
		--with-http_gzip_static_module \
	  --with-http_perl_module \
		--with-http_ssl_module 
	
	make
	
	_rmdir "$installPath"
	#这里的-d 参数判断$myPath是否存在  
	if [ ! -d "$installPath" ]; then  
		echo "mkdir $installPath"
		mkdir "$installPath"
	fi
	
	make install
	_rmdir "$mapPath" && ln -s "$installPath" "$mapPath"
	#export PATH=$PATH:/usr/local/nginx/sbin
	#chkconfig --del nginx
	#chkconfig --add nginx
	#chkconfig nginx on
	echo "install tengine  end"
fi
##install tengine end ########################################





##install maven start ########################################
if [ "$INSTALL_MAVEN" = "true" ]  
then  
	echo "install maven  start"
	##installPath="/usr/local/"
	mapPath="/usr/local/maven"

	#这里的-f参数判断$myFile是否存在  
	if [ ! -f "apache-maven-$TENGINE_VERSION-bin.tar.gz" ]; then  
		echo "wget maven"
		wget "http://mirrors.hust.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz"
	fi  
	tar zxf apache-maven-$MAVEN_VERSION-bin.tar.gz
	
	
	#这里的-d 参数判断$myPath是否存在  
	#if [ ! -d "$installPath" ]; then  
	#	echo "mkdir $installPath"
	#	mkdir "$installPath"
	#fi
	
	mv -f apache-maven-$MAVEN_VERSION "/usr/local/"
	_rmdir "$mapPath" && ln -s "/usr/local//apache-maven-$MAVEN_VERSION" "$mapPath"
	echo "install maven  end"
fi
##install maven end ########################################




##install php start ######################################## 
if [ "$INSTALL_PHP" = "true" ]  
then  
	echo "install php start"
	installPath="/usr/local/php-$PHP_VERSION"
	mapPath="/usr/local/php"
	
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f "php-$PHP_VERSION.tar.gz" ]; then  
		echo "wget php"
		wget http://cn2.php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror -O php-$PHP_VERSION.tar.gz
	fi  
	tar zxf php-$PHP_VERSION.tar.gz
	cd php-$PHP_VERSION
	./configure --prefix="$installPath"  --enable-fpm --with-mcrypt \
		--enable-mbstring --disable-pdo --with-curl --disable-debug  --disable-rpath \
		--enable-inline-optimization --with-bz2  --with-zlib --enable-sockets \
		--enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex \
		--with-mhash --enable-zip --with-pcre-regex --with-mysql --with-mysqli \
		--with-gd --with-jpeg-dir
	make
	_rmdir "$installPath"  && mkdir "$installPath"
	make install
	_rmdir "$mapPath" && ln -s "$installPath" "$mapPath"
	cd "$mapPath";
	cp "$mapPath/etc/php-fpm.conf.default" "$mapPath/etc/php-fpm.conf"
	groupadd www-data
	useradd -g www-data www-data
	usermod -L www-data 
	sed -i 's/\user = /d\user = www-data/i' "$mapPath/etc/php-fpm.conf"
	sed -i 's/\group = /d\group = www-data/i' "$mapPath/etc/php-fpm.conf"
	"$mapPath/sbin/php-fpm"
	echo "install php end"
fi
##install php end ######################################## 

##install redis start ########################################
if [ "$INSTALL_REDIS" = "true" ]  
then  
	echo "install redis start"
	installPath="/usr/local/redis-$REDIS_VERSION"
	mapPath="/usr/local/redis"
	
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f "redis-$REDIS_VERSION.tar.gz" ]; then  
		echo "wget redis"
		wget http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz
	fi  
	tar zxf redis-$REDIS_VERSION.tar.gz
	cd redis-$REDIS_VERSION
	make
	_rmdir "$installPath" && mkdir "$installPath"
	make PREFIX="$installPath" install 
	mkdir "$installPath/conf"
	cp redis.conf /usr/local/redis/conf/redis.conf
	_rmdir "$mapPath" && ln -s "$installPath" "$mapPath"
	cd ../
	echo "install redis end"
fi
##install redis end ########################################







##install redis start ########################################
if [ "$INSTALL_MYWEBSQL" = "true" ]  
then  
	echo "install mywebsql start"
	
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f "mywebsql-$MYWEBSQL_VERSION.zip" ]; then  
		echo "wget redis"
		wget http://nchc.dl.sourceforge.net/project/mywebsql/stable/mywebsql-$MYWEBSQL_VERSION.zip
	fi  
	unzip mywebsql-$MYWEBSQL_VERSION.zip 
	mv -r mywebsql /app/
	echo "install mywebsql end"
fi
##install redis end ########################################















##install ruby start ########################################
if [ "$INSTALL_RUBY" = "true" ]  
then  
	echo "安装ruby"
	yum -y install ruby
	
	echo "gem 换源"
	gem source -r https://rubygems.org/
	gem source -a https://ruby.taobao.org

fi
##install ruby end ########################################



##install saas start ########################################
if [ "$INSTALL_SAAS" = "true" ]  
then  
	echo "安装sass构建环境"
	gem install sass --pre
fi
##install saas end ########################################



##install node start ########################################
if [ "$INSTALL_NODE" = "true" ]  
then 
	echo "安装nodejs"
	mkdir /usr/local/node
	installPath="/usr/local/node/node-v$NODE_VERSION"
	mapPath="/usr/local/node/node"
	
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f "node-v$NODE_VERSION.tar.gz" ]; then  
		echo "wget node"
		wget https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz
	fi  
	yum -y remove nodejs
	tar zxf node-v$NODE_VERSION.tar.gz
	cd node-v$NODE_VERSION
	./configure --prefix="$installPath" 
	##mv -f node-v$NODE_VERSION /usr/local/node/
	make
	_rmdir "$installPath"
	make install
	sed -i '/export PATH=$PATH:\/usr\/local\/node\/node\/bin:\/usr\/local\/node\/npm_global\/bin/d' /etc/profile
	sed -i '/export PATH/a\export PATH=$PATH:\/usr\/local\/node\/node\/bin:\/usr\/local\/node\/npm_global\/bin' /etc/profile
	
	_rmdir "$mapPath" && ln -s "$installPath" "$mapPath"
	
	source /etc/profile
	npm config set cache "tmp/npm-cache"
	npm config set prefix "/usr/local/node/npm_global"
	
	##https://registry.npmjs.org/ 官方的npm源
	npm config set registry http://registry.cnpmjs.org  --global ##配置指向源
	##npm config set registry https://registry.npm.taobao.org --global

fi
##install node end ########################################


##install node-grunt start ########################################
if [ "$INSTALL_NODE_GRUNT" = "true" ]  
then 
	echo "清理grunt"
	npm uninstall -g grunt*
	npm uninstall -g cordova*
	npm uninstall -g express*
	
	echo "安装grunt"
	npm install -g grunt-cli
	
	echo "安装 uglify"
	npm install -g grunt-contrib-uglify
	
	echo "安装 cssmin"
	npm install -g grunt-contrib-cssmin
	
	echo "安装 concat"
	npm install -g grunt-contrib-concat
	
	echo "安装 qunit"
	npm install -g grunt-contrib-qunit
	
	echo "安装 clean"
	npm install -g grunt-contrib-clean 
	
	echo "安装cordova ionic"
	npm install -g cordova ionic
	
	echo "安装express4"npm install express -g
	npm install express-generator -g
	##npm install zmq -g  ##zeromq
	npm install bower -g
	
	
	## forever 
	#start:启动守护进程
	#stop:停止守护进程
	#stopall:停止所有的forever进程
	#restart:重启守护进程
	#restartall:重启所有的foever进程
	#list:列表显示forever进程
	#config:列出所有的用户配置项
	#set <key> <val>: 设置用户配置项
	#clear <key>: 清楚用户配置项
	#logs: 列出所有forever进程的日志
	#logs <script|index>: 显示最新的日志
	#columns add <col>: 自定义指标到forever list
	#columns rm <col>: 删除forever list的指标
	#columns set<cols>: 设置所有的指标到forever list
	#cleanlogs: 删除所有的forever历史日志
	##node 守护进徎  forever start|stop|restart app.js
	npm install -g forever
	
fi
##install node-grunt end ########################################





##install mysql start ########################################
if [ "$INSTALL_XXXX_mysql" = "true" ]  
then 
	echo "========================="
	echo "install mysql start"
	wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.24.tar.gz
	installPath="/usr/local/mysql-5.6.24"
	mapPath="/usr/local/mysql"
	
	rpm -qa | grep mysql
	yum remove -y mysql
	
	useradd -m  -p '@qmikcb!%as0#9823@' mysqlmkdir /usr/local/mysql-5.6.24
	groupadd mysql
	usermod -a -G mysql mysql
	mkdir /data/mysql/data
	mkdir /var/log/mariadb
	chown mysql /data/mysql/data /data/mysql
	chown mysql /var/log/mariadb
	tar xvf mysql-5.6.24.tar.gz
	cd mysql-5.6.24
	
	cmake -DCMAKE_INSTALL_PREFIX="$installPath" \
		-DDEFAULT_CHARSET=gbk \
		-DDEFAULT_COLLATION=gbk_chinese_ci \
		-DWITH_EXTRA_CHARSETS=all \
		-DWITH_MYISAM_STORAGE_ENGINE=1 \
		-DWITH_INNOBASE_STORAGE_ENGINE=1 \
		-DWITH_MEMORY_STORAGE_ENGINE=1 \
		-DWITH_READLINE=1 \
		-DENABLED_LOCAL_INFILE=1 \
		-DMYSQL_DATADIR=/data/mysql/data \
		-DMYSQL_USER=mysql
	
	make 
	_rmdir "$installPath" && mkdir "$installPath" 
	make install
	
	chmod u+x support-files/*
	chmod u+x scripts/*
	
	cp support-files/mysql.server /etc/rc.d/init.d/mysql
	cp support-files/my-default.cnf /etc/my.cnf
	chkconfig --del mysql
	chkconfig --add mysql
	chkconfig mysql on
	
	scripts/mysql_install_db.sh --defaults-file=/etc/my.cnf --basedir="$installPath" --datadir=/data/mysql/data --user=mysql
	##mkdir /data/mysql/mysql.sock
	##sed -i '/user=mysql/d' /etc/my.cnf
	##sed -i '/\[mysqld\]/a\user=mysql' /etc/my.cnf
	##sed -i '/datadir=\/var\/lib\/mysql/c\datadir=\/data\/mysql/data' /etc/my.cnf
	_rmdir "$mapPath" && ln -s "$installPath" "$mapPath"
	cd ../
	echo "install mysql end"
fi
##install mysql end ########################################


##install mysql start ########################################
if [ "$INSTALL_MYSQL" = "true" ]  
then 
	echo "========================="
	echo "install mysql start"
	
	##安装路径
	installPath="/usr/local/jetty-distribution-$JETTY_VERSION"
	##映射路径
	mapPath="/usr/local/jetty"
	
	#这里的-f参数判断$myFile是否存在  
	if [ ! -f  "mysql-community-release-el7-5.noarch.rpm" ]; then  
		echo "wget jetty"
		wget "http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm"  ###-O jetty-$JETTY_VERSION.tar.gz
	fi 
	rpm -ivh mysql-community-release-el7-5.noarch.rpm
		
	yum install -y mysql-server
	
	
	echo "install mysql end"
fi
##install mysql end ########################################






export PATH=$PATH:/usr/local/nginx/sbin:/usr/local/redis/bin:/usr/local/java/bin
export PATH=$PATH:/usr/local/node/node/bin:/usr/local/node/npm_global/bin




#JAVA_HOME=/usr/local/java
#MAVEN_HOME=/usr/local/maven

#PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin
