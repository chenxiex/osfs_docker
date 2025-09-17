#! /bin/bash

bochsrc_path="bochsrc"
bochsrc_bak_path="bochsrc.bak"

# 备份bochsrc
cp "$bochsrc_path" "$bochsrc_bak_path"

# 注释掉 keyboard_mapping 行
sed -i 's/^\(keyboard_mapping\s*:\s*\)/# \1/' "$bochsrc_path"