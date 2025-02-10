FROM ubuntu:16.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y gcc-multilib make nasm bear bc mtools

RUN echo '#!/bin/bash\n/usr/bin/gcc -fno-stack-protector -m32 "$@"' > /usr/local/bin/gcc && chmod +x /usr/local/bin/gcc

RUN echo '#!/bin/bash\n/usr/bin/ld -m elf_i386 "$@"' > /usr/local/bin/ld && chmod +x /usr/local/bin/ld