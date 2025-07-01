FROM ubuntu:16.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y gcc-multilib make nasm bear bc mtools git libvncserver-dev libgcrypt-dev build-essential curl

RUN cd /tmp &&  curl -L# https://sourceforge.net/projects/bochs/files/bochs/2.8/bochs-2.8.tar.gz | tar xz --strip-components=1
RUN cd /tmp && ./configure --with-vncsrv --enable-debugger CXXFLAGS="-fpermissive" && make
RUN mkdir -p /usr/local/share/bochs && cp -r /tmp/bios/* /usr/local/share/bochs && cp /tmp/bochs /usr/bin/bochs

# 为gcc添加编译选项
RUN echo '#!/bin/bash\n/usr/bin/gcc -fno-stack-protector -m32 "$@"' > /usr/local/bin/gcc && chmod +x /usr/local/bin/gcc

# 为ld添加编译选项
RUN echo '#!/bin/bash\n/usr/bin/ld -m elf_i386 "$@"' > /usr/local/bin/ld && chmod +x /usr/local/bin/ld

# 添加patch_buildimg.sh
COPY ./patch_buildimg.sh /usr/local/bin/patch_buildimg.sh
RUN chmod +x /usr/local/bin/patch_buildimg.sh
RUN apt-get autoremove -y build-essential curl
RUN rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
EXPOSE 5900
WORKDIR /mnt
