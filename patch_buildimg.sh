#!/bin/bash

makefile_path="Makefile"

img_script_content=$(cat <<'EOF'
	dd if=boot/boot.bin of=a.img bs=512 count=1 conv=notrunc
	mcopy -o -i a.img boot/loader.bin ::/
	mcopy -o -i a.img kernel.bin ::/
EOF
)

# 使用sed替换Makefile中buildimg目标的内容
sed -i "/^buildimg :/,/^$/c\buildimg :\n$(echo "$img_script_content" | sed 's/$/\\n/' | tr -d '\n')" "$makefile_path"
