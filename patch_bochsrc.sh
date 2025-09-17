#! /bin/bash

bochsrc_path="bochsrc"

# 注释掉 keyboard_mapping 行
sed -i 's/^\(keyboard_mapping\s*:\s*\)/# \1/' "$bochsrc_path"