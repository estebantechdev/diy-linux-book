## Installing devcontainers with DevPod for alternatives to VS Code

### Download website

References:

Website: <https://devpod.sh/>

### Install DevPod CLI

```shell
$ curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod
```

### Install DevPod Appimage

Download the Appimage for your OS and architecture.

```shell
$ cd ~/Downloads
$ sudo apt-get update
$ sudo apt-get install fuse libfuse2 libopengl0 libfribidi0 libgles2-mesa
$ chmod +x DevPod_linux_amd64.AppImage
$ ./DevPod_linux_amd64.AppImage
```

This opens the application.

Define a provider, for example, Docker.

Create a new workspace:

Select a provider, IDE and source.

Ecample:

Provider: Docker

IDE: VS Code

Source: /path/to/multiple-dev-container-vscode/

When the workspace is created, click on the button "Open" to start your devcontainer project with VS Code.

DevPod opens the devcontainer project using VS Code.

For the example project, notice that it will open the Node container by default.

Project files: **(docker stacks)/practical-docker/multiple-dev-container-vscode/**.
