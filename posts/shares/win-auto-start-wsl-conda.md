---
id: fax
title: 'windows在WSL+CONDA环境自启动'
title-en: 'windows auto start WSL+CONDA'
pubDate: 2020-12-22T08:32:33.000Z
isDraft: false
tags: ['python']
categories: ['shares']
---

自己做了个python应用，因为依赖相对复杂，所以使用WSL（-ubuntu）的方式部署。

在配置服务随Windows系统自动化启动的时候遇到问题。

因为需要切换环境，所以在使用以下语句，执行启动脚本时：

```powershell
wsl -d ubuntu-18.04 -u chen "/etc/init.d/start-script"
```

最直接的想法，使用start-script脚本内容如下：

```bash
#! /bin/bash
conda activate env_name
cd /mnt/e/path/to/script
python test.py
```

但是，在使用conda activate命令切换环境，会因为conda环境没有初始化的问题，无法进入相应环境。

```powershell
CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'.
To initialize your shell, run

    $ conda init <SHELL_NAME>

Currently supported shells are:
  - bash
  - fish
  - tcsh
  - xonsh
  - zsh
  - powershell

See 'conda init --help' for more information and options.

IMPORTANT: You may need to close and restart your shell after running 'conda init'.
```

这时候使用下面语句切换环境即可：

```bash
source /home/user_name/miniconda3/bin/activate env_name
# 或者
source /home/user_name/anaconda3/bin/activate env_name
```

修改后的启动脚本为：

```bash
#! /bin/bash
source /home/user_name/miniconda3/bin/activate env_name
cd /mnt/e/path/to/script
python test.py
```

参考

[calling-conda-source-activate-from-bash-script](https://stackoverflow.com/a/51695997)
