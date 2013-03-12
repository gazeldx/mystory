DEMO: [我的故事网站](http://mystory.cc/)

如果要看详尽的内容，请[阅读WIKI](https://github.com/gazeldx/mystory/wiki/)。

基于欧美主流WEB架构[Ruby on Rails](http//rubyonrails.org/)搭建。目前的版本已经可以正常使用。代码在持续重构中。

很多站长用惯了php上传代码，看到DIY主机第一个想法就是“我不会”。如果你信得过我，请将你的主机IP和密码告诉我，我会帮你安装、配置好服务器 [查看详情](https://github.com/gazeldx/mystory/wiki/Install-host)。

你也可以参考下文自行搭建主机。

[Ruby语言](http://www.ruby-lang.org/en/ )如今是敏捷开发的主力，代码易懂！不信请看看mystory的代码，看是不是能看懂。

请按顺序进行以下操作。

### STEP 1： 申请一个域名和一台主机，并将域名解析到这台主机。
主机可以用[阿里云](http://www.aliyun.com/cps/rebate?from_uid=10HMVVRwi6QE1DS+vAgUA07z9lZ7NuFi)或者盛大云，建议用Ubuntu Server。域名解析用dnspod.cn，都是比较稳定的。

因为用二级域名作为用户的博客URL，需要做泛域名解析。将 *.yourdomain.com 解析你的主机。

远程登入云主机(Windows系统下要下载'[PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html/ )')：

    $ ssh root@YOUR_SERVER_IP
[查看更多“域名和主机”内容](https://github.com/gazeldx/mystory/wiki/Domain-And-Host)

以下操作均在云主机上进行。

### STEP 2： 安装软件
**用RVM来安装RUBY**

下文参考自https://rvm.io/rvm/install/

    $ sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config
    $ \curl -L https://get.rvm.io | bash -s stable --ruby
安装最后，会提示类似这样的一名话：

    * To start using RVM you need to run `source /usr/local/rvm/scripts/rvm`
你照着做。下面是一个例子：

    $ source /usr/local/rvm/scripts/rvm
创建gemset并将此gemset设为默认：

    $ rvm gemset create rails3.2.11
    $ rvm use 2.0.0@rails3.2.11 --default
**安装其它软件**

    $ sudo apt-get install libpq-dev imagemagick
[查看更多“安装软件”内容](https://github.com/gazeldx/mystory/wiki/Software)
### STEP 3： 下载源代码
    $ git clone http://github.com/gazeldx/mystory.git
    $ cd mystory
    $ bundle install
[查看更多“安装源代码”内容](https://github.com/gazeldx/mystory/wiki/Source-code)
### STEP 4: Postgresql数据库
因为Postgresql简单好用，性能可能比Mysql还要好，所以我没有用其它数据库。

**安装**

参考了http://www.postgresql.org/download/linux/debian/

    $ sudo apt-get install postgresql-9.1
**设置**

修改

    /etc/postgresql/9.1/main/postgresql.conf
去掉listen_addresses = 'localhost'前面的#

重启数据库

    $ sudo service postgresql restart
进入psql命令行

    $ sudo -u postgres psql
设置'postgres'用户的密码

    $ ALTER USER postgres PASSWORD 'yourpassword';
退出psql命令行

    \q
修改
    /etc/postgresql/9.1/main/pg_hba.conf
改为password(明文密码)：

    local   all         postgres                          password
重启数据库

    $ sudo service postgresql restart
**创建数据库**

    $ sudo -u postgres createdb mystory_production
修改config/database.yml，改为你创建的数据库名和postgres用户密码。

**创建表**

注意：本步骤的操作需要先完成 [下载源代码](https://github.com/gazeldx/mystory/wiki/Source-code)

    $ cd mystory
    $ rake db:setup RAILS_ENV=production
    $ rake db:seed RAILS_ENV=production
[查看更多“数据库”内容](https://github.com/gazeldx/mystory/wiki/Postresql)

    $ sudo apt-get install imagemagick

### STEP 5： 修改配置
修改config/config.yml

修改config/locales/zh.yml

### STEP 6： 启动WEB服务
    $ cd mystory
    $ unicorn_rails -p 80
现在你可以访问 http://yourdomain.com了。

    $ unicorn_rails -p 80 -D(-D是后台运行，-p指定端口)。还可以用Nginx，稍后我会写上如何配置Nginx。
    $ ps -ef|grep unicorn 可以查看到WEB的运行进程ID
    $ kill -9 进程ID（kill进程，也就是关闭了WEB服务。这里的进程ID是一个数字，如3456）
[查看更多“设置”内容](https://github.com/gazeldx/mystory/wiki/Settings)

任何问题可以在 https://github.com/gazeldx/mystory/issues 或者 http://mystory.cc/ 上向我发问。

我对使用源代码站长只有一个期待：和我一起做原创吧！做原创的站长将会获得我更多的技术支持哦！

最后，对代码的重构一直都在持续。因此，请点击"Star"关注下，或点"Fork"帮助我一起改善代码吧。谢谢！