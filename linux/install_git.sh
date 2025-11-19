#!/bin/bash

# author: Nine
# create: 2021-05-23
# note: git 安装脚本

dir=/usr/local/git
git_v='2.45.0'

# 安装依赖
function check_os() {
	# CentOS
	if test -e "/etc/redhat-release"; then
		yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker wget autoconf automake libtool
		[ $? -ne 0 ] && echo "yum 安装依赖失败，请手动安装" && exit 0
	# Debian
	elif test -e "/etc/debian_version"; then
		apt-get -y install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev gcc make wget dh-autoreconf
		[ $? -ne 0 ] && echo "apt-get 安装依赖失败，请手动安装" && exit 0
	else
		echo "该脚本不适用当前系统！" && exit 0
	fi
}

# 编译安装
function install() {
	yum -y remove git
	if [ ! -d "$dir" ]; then
		mkdir -p $dir && "目录$dir创建成功"
	fi
	if [ ! -f "git-$git_v.tar.gz" ]; then
		wget https://github.com/git/git/archive/refs/tags/git-$git_v.tar.gz
		[ $? -ne 0 ] && echo "git-$git_v.tar.gz 文件下载失败" && exit 1
	fi
	tar -zxvf git-$git_v.tar.gz
	cd git-$git_v || exit
	make configure && ./configure --prefix=$dir
	make -j2 all && make -j2 install

	echo "GIT_HOME=$dir" >> /etc/profile
	echo "PATH=\$PATH:\$GIT_HOME/bin" >> /etc/profile
	echo "export PATH" >> /etc/profile

	printf '%.0s-' {1..100}
	echo "git-$git_v installed successfully."
	echo "* To start using git you need to run: source /etc/profile"
}

check_os
install
