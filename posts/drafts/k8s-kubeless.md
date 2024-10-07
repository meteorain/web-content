---
id: bRk
title: 'Kubernetes Kubeless Deploys Function (centOS 8)'
pubDate: 2020-02-17T08:01:59.000Z
isDraft: true
tags: ['kubernetes', 'serverless']
categories: ['笔记']
---

昨天看到了开源的对象存储项目`MINio`,自己的毕设对于影像的存储是解决了，对亚马逊的S3和Lambda的生态很有兴趣，就准备搭建一个开源的服务，用于遥感影像上传后自动获取影像头文件的小型服务。

对于性能一般的阿里云，选择用`kubeadmin`安装。

## 1.关闭SWAP

```bash
$ vim /etc/fstab   #将UUID的行注释掉

#
# /etc/fstab
# Created by anaconda on Wed Dec 25 03:29:46 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
#UUID=e32cfa7a-df48-4031-8fdf-5eec92ee3039 /              xfs     defaults        0 0
```

## 2.安装Kubeadm、kubelet、kubectl

-   `kubeadm`: the command to bootstrap the cluster.
-   `kubelet`: the component that runs on all of the machines in your cluster and does things like starting pods and containers.
-   `kubectl`: the command line util to talk to your cluster.

```bash
$ cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

$ yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

$ systemctl enable --now kubelet
```

## 3.初始化

```bash
$ kubeadm init <args>
$ kubead init --image-repository='registry.cn-hangzhou.aliyuncs.com/google_containers' #使用国内源
```

## 4.安装网络插件

```bash
# 1 初始化时使用
$ kubead init --image-repository='registry.cn-hangzhou.aliyuncs.com/google_containers' --pod-network-cidr=192.168.0.0/16
# 2 通过kubeadm配置
$ kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml
```

## 5.解除主节点隔离

控制面板的节点默认被隔离起来，而我要在该节点计划`Pods`，所以先`taint`这个节点。

```shell
$ kubectl taint nodes --all node-role.kubernetes.io/master-
```

## 6.添加节点

```shell
$ kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
# 也就是使用 kubeadm init 之后生成的一段
```

## 7.安装kubeless

没什么坑，照官方文档即可。

```shell
$ export RELEASE=$(curl -s https://api.github.com/repos/kubeless/kubeless/releases/latest | grep tag_name | cut -d '"' -f 4)
$ kubectl create ns kubeless
$ kubectl create -f https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless-$RELEASE.yaml

$ kubectl get pods -n kubeless
NAME                                           READY     STATUS    RESTARTS   AGE
kubeless-controller-manager-567dcb6c48-ssx8x   1/1       Running   0          1h

$ kubectl get deployment -n kubeless
NAME                          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kubeless-controller-manager   1         1         1            1           1h

$ kubectl get customresourcedefinition
NAME                          AGE
cronjobtriggers.kubeless.io   1h
functions.kubeless.io         1h
httptriggers.kubeless.io      1h
```

```shell
$ export OS=$(uname -s| tr '[:upper:]' '[:lower:]')
$ curl -OL https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless_$OS-amd64.zip && \
  unzip kubeless_$OS-amd64.zip && \
  sudo mv bundles/kubeless_$OS-amd64/kubeless /usr/local/bin/
```

现在github有点半身不遂，可以手动下载下来再手动将执行文件放到/usr/local/bin/目录下。

## 8.测试部署functions

```shell
$ vi test.py # 写入下面内容
$ def hello(event, context):
  print event
  return event['data']
```

```shell
$ kubeless function deploy hello --runtime python2.7 \
                                --from-file test.py \
                                --handler test.hello
INFO[0000] Deploying function...
INFO[0000] Function hello submitted for deployment
INFO[0000] Check the deployment status executing 'kubeless function ls hello'
```

查看一下`functions`的状态

```shell
$ kubectl get functions
NAME         AGE
hello        1h

$ kubeless function ls
NAME            NAMESPACE   HANDLER       RUNTIME   DEPENDENCIES    STATUS
hello           default     helloget.foo  python2.7                 1/1 READY
```

如果成功：

```shell
$ kubeless function call hello --data 'Hello world!'
hello world！
```

## 问题

### 1. Pod status 显示 pending

```shell
$ kubectl describe pod POD-UID
$ kubectl describe pod -n kubeless # 查看pod详细信息 拖到 最下面的 events 查看日志排查错误
```

### 2. cannot get customresourcedefinitions.apiextensions.k8s.io at the cluster scope

有可能是在部署了一个`non-rbac`版本，但是`cluster` 的 `RBAC` enabled，只需要换回默认的`RBAC`版本。

```shell
$ kubectl apply -f https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless-$RELEASE.yaml
```

##
