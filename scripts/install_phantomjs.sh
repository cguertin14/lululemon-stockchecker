#!/bin/bash

arch=$CPU_ARCH
if [ "$arch" = "arm64" ]; then
	wget https://github.com/ApioLab/phantomjs-2.1.1-linux-arm/raw/master/phantomjs-2.1.1-linux-arm.tar.bz2
	tar -xvf phantomjs-2.1.1-linux-arm.tar.bz2
	cp ./phantomjs-2.1.1-linux-arm/bin/phantomjs /usr/local/bin/phantomjs
else
	wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
	tar -xvf phantomjs-2.1.1-linux-x86_64.tar.bz2
	cp ./phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
fi

# cleanup
rm -rf phantomjs*