FROM ubuntu:16.04

MAINTAINER 16yuki0702

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
	git \
	vim \
	curl \
	sudo \
	apt-transport-https \
	lsb-release \
	golang \
	python3 \
	python3-dev \
	python3-setuptools \
	python3-pip \
	language-pack-ja-base \
	language-pack-ja \
	nginx \
	supervisor \
	wget \
	libncurses-dev && \
	pip3 install -U pip setuptools && \
	rm -rf /var/lib/apt/lists/*

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY supervisor.conf /etc/supervisor/conf.d/

ENV LANG=ja_JP.UTF-8

#vim
RUN cd /usr/local/src/ && \
	wget http://tamacom.com/global/global-6.5.6.tar.gz && \
	tar zxvf global-6.5.6.tar.gz && \
	cd global-6.5.6 && \
	./configure && \
	make && \
	make install && \
	mkdir -p ~/.vim/plugin/ && \
	cp /usr/local/share/gtags/gtags.conf /etc/ && \
	cp /usr/local/share/gtags/gtags.vim ~/.vim/plugin/gtags.vim && \
	pip install pygments && \
	sed -i -e 's/\*min\.css/\*min\.css,\*.mo/g' /etc/gtags.conf && \
	sed -i -e 's/\/usr\/bin\/python/\/usr\/bin\/env python3/g' /usr/local/share/gtags/script/pygments_parser.py
COPY vimrc /root/.vimrc

# 2 docker source reading
RUN cd /usr/local/src && \
	git clone https://github.com/moby/moby.git && \
	cd moby && \
	gtags --gtagslabel=pygments -v

Run cd /usr/local/src && \
	git clone https://github.com/containerd/containerd.git && \
	cd containerd && \
	gtags --gtagslabel=pygments -v

Run cd /usr/local/src && \
	git clone https://github.com/opencontainers/runc.git && \
	cd runc && \
	gtags --gtagslabel=pygments -v

EXPOSE 80
CMD ["supervisord", "-n"]
