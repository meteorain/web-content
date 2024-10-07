---
title: Untitled
---
## root ssh login


## static ip




## debian install docker

在Debian系统上安装Docker和Docker Compose，可以按照以下步骤进行：

### 安装Docker

1. **更新包索引**：
   首先，更新Debian的包索引：

   ```sh
   sudo apt update
   ```

2. **安装必要的软件包**：
   安装一些允许`apt`通过HTTPS使用的软件包：

   ```sh
   apt install apt-transport-https ca-certificates curl gnupg lsb-release
   ```

3. **添加Docker的官方GPG密钥**：
   运行以下命令添加Docker的官方GPG密钥：

   ```sh
   curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   ```

4. **设置稳定的Docker存储库**：
   使用以下命令设置Docker的存储库：

   ```sh
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

5. **更新包索引并安装Docker Engine**：
   更新包索引，并安装最新版本的Docker Engine：

   ```sh
   apt update
   apt install docker-ce docker-ce-cli containerd.io
   ```

6. **启动并启用Docker服务**：
   启动Docker服务，并设置其在系统引导时启动：

   ```sh
   systemctl start docker
   systemctl enable docker
   ```

7. **验证Docker安装**：
   运行以下命令验证Docker是否正确安装：

   ```sh
   sudo docker --version
   ```

### 运行简单的测试

1. **创建一个测试目录**：

   ```sh
   mkdir my_docker_test
   cd my_docker_test
   ```

2. **创建一个`docker-compose.yml`文件**：
   在测试目录中创建一个名为`docker-compose.yml`的文件，并添加以下内容：

   ```yaml
   version: '3'
   services:
     web:
       image: nginx
       ports:
         - "8080:80"
   ```

3. **启动服务**：
   在`docker-compose.yml`所在目录运行以下命令启动服务：

   ```sh
   sudo docker-compose up -d
   ```

4. **验证服务运行**：
   打开浏览器，访问`http://localhost:8080`，你应该能够看到Nginx的默认欢迎页面。

5. **停止并移除服务**：

   ```sh
   sudo docker-compose down
   ```

通过这些步骤，你已经在Debian上成功安装了Docker和Docker Compose，并进行了简单的测试。