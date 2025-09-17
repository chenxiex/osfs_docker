#!/bin/bash

# patch_buildimg.sh
makefile_path="Makefile"
makefile_bak_path="Makefile.bak"
# patch_bochsrc.sh
bochsrc_path="bochsrc"
bochsrc_bak_path="bochsrc.bak"

# 恢复所有 patch_ 脚本修改的文件
cp "$makefile_bak_path" "$makefile_path"
cp "$bochsrc_bak_path" "$bochsrc_path"
