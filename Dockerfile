FROM ubuntu:16.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y gcc-multilib make nasm bear bc mtools git

# 为gcc添加编译选项
RUN echo '#!/bin/bash\n/usr/bin/gcc -fno-stack-protector -m32 "$@"' > /usr/local/bin/gcc && chmod +x /usr/local/bin/gcc

# 为ld添加编译选项
RUN echo '#!/bin/bash\n/usr/bin/ld -m elf_i386 "$@"' > /usr/local/bin/ld && chmod +x /usr/local/bin/ld