# Docker Image for OSFS
这是一个主要为 [https://github.com/yyu/osfs00](https://github.com/yyu/osfs00) 系列课程准备的开发镜像，包含了编译课程代码所需的编译工具链。

本镜像包含以下工具：
- `gcc`, `make`, `nasm`, `bc`: 基本的编译工具。这些编译工具都已经过优化以确保可以直接用来编译课程代码。
    <details>
    <summary>编译选项</summary>
    为了保证成功编译课程代码，默认设置了部分编译选项。查阅 Dockerfile 以了解更多。
    </details>
- `mtools`: 用于替代 `mount` 来写入镜像文件。必须配合 `patch_buildimg.sh` 使用。
- `bear`: 用于生成 `compile_commands.json`。如果你使用 `clangd` 或者 `vscode cpptools intellisense`，这可能会很有用。

本镜像不包含以下工具：
- `bochs`: 我拼尽全力也无法让 `bochs` 在 Docker 容器里跑起来。如果有任何人知道该怎么做，欢迎提出 PR。

## 使用
1. 克隆本仓库，使用本仓库中的 `Dockerfile` 构建镜像。例如，
    ```bash
    docker build -t osfs_docker .
    ```
    你也可以直接拉取预构建的镜像：
    ```bash
    docker pull ghcr.io/chenxiex/osfs_docker
    ```
3. 如果希望在 Docker 环境内执行 `buildimg` 构建目标，你需要将 `patch_buildimg.sh` 移动至 `Makefile` 同级目录下，然后执行 `patch_buildimg.sh`。原 `Makefile` 中的 `buildimg` 任务无法在 Docker 环境中执行。如果你没有安装 `bash`，你可以在 Docker 容器中执行该脚本，参考下一条。
4. 你可以使用相应的镜像来编译课程代码了。例如，以下代码创建一个一次性容器，并将当前工作目录挂载到容器内，然后执行 `make` 命令。
    ```bash
    docker run --rm -v "$PWD":"$PWD" -w "$PWD" osfs_docker make
    ```
    你也可以在容器中开启一个 `shell`，从而直接在命令行中执行你想要的命令。
    ```bash
    docker run --rm -it -v "$PWD":"$PWD" -w "$PWD" osfs_docker bash
    ```
    <details>
    <summary>注意，该容器是一次性的，对于在工作目录外做的更改（例如额外安装软件包）都会丢失。</summary>
    你也可以不使用一次性容器，请自行学习相关内容。但需要注意，容器创建时仅仅挂载了当前目录；如果你后续切换了工作目录，**不要**使用原来的容器。
    </details>
