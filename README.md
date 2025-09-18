# Docker Image for OSFS
这是一个主要为 [https://github.com/yyu/osfs00](https://github.com/yyu/osfs00) 系列课程准备的开发镜像，包含了编译课程代码所需的编译工具链。

本镜像包含以下工具：
- `gcc`, `make`, `nasm`, `bc`, `bochs`
- `mtools`: 用于替代 `mount` 来写入镜像文件。
- `bear`: 用于生成 `compile_commands.json`。如果你使用 `clangd` 或者 `vscode cpptools intellisense`，这可能会很有用。
- `git`

## 使用
1. 克隆本仓库，使用本仓库中的 `Dockerfile` 构建镜像。例如，
    ```bash
    docker build -t osfs_docker .
    ```
    或者，你也可以直接拉取预构建的镜像：
    ```bash
    docker pull ghcr.io/chenxiex/osfs_docker
    docker tag ghcr.io/chenxiex/osfs_docker osfs_docker
    ```
2. 你可以使用相应的镜像来编译运行课程代码了。例如：
    ```bash
    cd /path/to/osfsxx/a
    # 为了配合 osfs_docker，必须修改一些项目文件。patch_all.sh 脚本用于执行这些修改。关于 patch_all.sh 的更多说明，请参考注意事项。
    docker run --rm -v "$PWD":"$PWD" -w "$PWD" osfs_docker patch_all.sh
    docker run --rm -v "$PWD":"$PWD" -w "$PWD" osfs_docker make image
    # 受 docker 限制，这里的 bochs 需要使用 vnc 远程桌面连接到 localhost:5900 来查看图形界面。
    docker run -it --rm -v "$PWD":"$PWD" -w "$PWD" -p 5900:5900 osfs_docker bochs
    ```

## 注意事项
我们投入了很多努力来让 `osfs_docker` 开箱即用，例如修改了 gcc 的默认选项以绕过一些编译问题，这些修改可能导致这些编译工具不适合用来编译其它项目。查看 Dockerfile 以了解这些更改。

尽管如此，依然存在一些必须修改 `osfs` 项目文件才能正常运行的功能，我们编写了一系列 `patch_` 脚本来帮助进行这些修改。每次进入新的项目时，都需要重新执行脚本来修改项目文件。同时，可以使用 `revert_all.sh` 脚本来撤销这些修改。这些脚本包括：

1. `patch_all.sh`: 用于一次性应用所有修改。
2. `revert_all.sh`: 用于一次性撤销所有修改。
3. `patch_buildimg.sh`: 该脚本修改 `Makefile` 中有关镜像构建的目标，使用 `mtools` 替换原本的 `mount` 命令。同时需要注意，`osfs` 项目假设存在空的 `a.img` 镜像用于写入。在课程的开头，你应该已经学过如何创建这个空镜像。你还可以通过解压项目附带的 `a.img.gz` 来获得这个镜像。
4. `patch_bochsrc.sh`: 该脚本修改 `bochsrc` 文件，注释 `keyboard_mapping:` 行。该行与我们使用的 `bochs` 版本不兼容。