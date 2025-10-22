# Docker 环境配置 + 软件（一键安装）- Ubuntu 适配版

> **本仓库基于小傅哥的原始项目进行 Ubuntu 系统适配**  
> 原作者：小傅哥  
> 原项目地址：[https://github.com/fuzhengwei/xfg-dev-tech-docker-install](https://github.com/fuzhengwei/xfg-dev-tech-docker-install)  
> 博客：[https://bugstack.cn](https://bugstack.cn)

**适配者：Oohxjh**  
**适配内容：** 在保留原有 CentOS 版本的基础上，新增 Ubuntu 系统的完整支持

---

## 📢 版本说明

本仓库是对小傅哥原始项目的**定制化扩展版本**，主要改动：

✅ **新增 Ubuntu 支持** - 创建 `install_docker_ubuntu.sh` 和 `run_install_docker_ubuntu.sh`  
✅ **保留 CentOS 版本** - 原有脚本完全不变，CentOS 用户可继续使用  
✅ **双系统兼容** - 同一仓库支持 CentOS 和 Ubuntu 两种系统  
✅ **镜像加速优化** - 保留国内镜像加速配置，海外服务器自动回退官方源

**感谢小傅哥的开源贡献！** 🙏

> 沉淀、分享、成长，让自己和他人都能有所收获！😄

## 📖 项目简介

本项目提供了一套完整的 Docker 开发环境自动化部署脚本，支持 **Ubuntu** 和 **CentOS** 双系统。通过简单的命令即可在云服务器或本地虚拟机上快速搭建 Docker 环境，包括 Docker CE、Docker Compose 以及常用的开发软件栈（MySQL、Redis、RabbitMQ 等）。

**适用场景：**
- 🚀 快速搭建开发测试环境
- 🐳 容器化应用部署
- 📦 微服务架构开发
- 🎓 Docker 学习实践

## 🌱 目录

- 一、快速开始（Ubuntu / CentOS 双系统支持）
- 二、一键部署脚本
   1. 脚本权限设置
   2. JDK 安装脚本
   3. Docker 安装脚本（CentOS 版本）
   4. Docker 安装脚本（Ubuntu 版本）🆕
   5. 软件安装脚本
   6. 常见问题
   7. 执行顺序建议

## 一、快速开始（Ubuntu / CentOS 双系统支持）

### 🎯 根据您的系统选择对应的脚本

#### Ubuntu 用户（推荐 Ubuntu 22.04 LTS）

```bash
# 1. 克隆仓库
git clone https://github.com/Oohxjh/dev-tech-install.git
cd dev-tech-install

# 2. 添加执行权限
chmod +x run_install_docker_ubuntu.sh
chmod +x install_docker_ubuntu.sh

# 3. 执行安装
./run_install_docker_ubuntu.sh
```

#### CentOS 用户（CentOS 7.9）

```bash
# 1. 克隆仓库
git clone https://github.com/Oohxjh/dev-tech-install.git
cd dev-tech-install

# 2. 添加执行权限
chmod +x run_install_docker_local.sh
chmod +x install_docker.sh

# 3. 执行安装
./run_install_docker_local.sh
```

### 📋 系统支持

| 系统类型 | 支持版本 | 脚本文件 | 状态 |
|---------|---------|---------|------|
| **Ubuntu** | 24.04 / 22.04 / 20.04 LTS | `run_install_docker_ubuntu.sh` | ✅ 已支持 |
| **CentOS** | 7.9 | `run_install_docker_local.sh` | ✅ 已支持 |

---

## 二、一键部署脚本

这里为你准备一键安装 Docker 环境的脚本文件，你可以非常省心的完成 Docker 部署。使用方式如下。

<div align="center">
    <img src="https://bugstack.cn/images/roadmap/tutorial/road-map-docker-install-02.png" width="650px">
</div>

**仓库地址：**
- **本仓库（Ubuntu 适配版）**：<https://github.com/Oohxjh/xfg-dev-tech-docker-install>
- **原始仓库（CentOS 版本）**：<https://github.com/fuzhengwei/xfg-dev-tech-docker-install>
- **原 Gitcode 镜像**：<https://gitcode.com/Yao__Shun__Yu/xfg-dev-tech-docker-install>

本文档介绍如何执行项目中的各个脚本，包括权限设置和执行步骤。

**参考资料：**
- 操作视频（原始版本）：[https://www.bilibili.com/video/BV1oaNazEEf5](https://www.bilibili.com/video/BV1oaNazEEf5)

### 1. 脚本权限设置

在执行任何脚本之前，需要先为脚本文件添加可执行权限：

```bash
# CentOS 版本脚本
chmod +x environment/jdk/install-java.sh
chmod +x environment/jdk/remove-java.sh
chmod +x run_install_docker_local.sh
chmod +x install_docker.sh
chmod +x run_install_software.sh
chmod +x environment/maven/install-maven.sh
chmod +x environment/maven/remove-maven.sh

# Ubuntu 版本脚本 🆕
chmod +x run_install_docker_ubuntu.sh
chmod +x install_docker_ubuntu.sh
```

或者一次性为所有脚本添加权限：

```bash
find . -name "*.sh" -type f -exec chmod +x {} \;
```

### 2. JDK 安装脚本

#### 2.1 安装 JDK

脚本位置： environment/jdk/install-java.sh

功能： 支持安装 JDK 8 和 JDK 17

执行方式：

```
# 交互式安装（推荐）
sudo ./environment/jdk/install-java.sh

# 指定版本安装
sudo ./environment/jdk/install-java.sh -v 8    # 安装 JDK 8
sudo ./environment/jdk/install-java.sh -v 17   # 安装 JDK 17

# 强制安装（覆盖已有安装）
sudo ./environment/jdk/install-java.sh -f -v 8

# 静默安装
sudo ./environment/jdk/install-java.sh -q -v 8

# 自定义安装目录
sudo ./environment/jdk/install-java.sh -d /opt/java -v 8
```
注意事项：

- 需要 root 权限执行
- 脚本会提示手动下载 JDK 包到 /dev-ops/java 目录
- 支持的版本：JDK 8 (1.8.0_202) 和 JDK 17 (17.0.14)
- 安装完成后环境变量会自动配置

#### 2.2 卸载 JDK

脚本位置： environment/jdk/remove-java.sh

功能： 彻底清理 JDK 安装和环境配置

执行方式：

```
# 交互式删除（推荐）
sudo ./environment/jdk/remove-java.sh

# 强制删除
sudo ./environment/jdk/remove-java.sh -f

# 静默删除
sudo ./environment/jdk/remove-java.sh -f -q

# 指定安装目录删除
sudo ./environment/jdk/remove-java.sh -d /opt/java

# 删除时不备份配置文件
sudo ./environment/jdk/remove-java.sh --no-backup
```
注意事项：

- 需要 root 权限执行
- 会自动备份配置文件（除非使用 --no-backup）
- 清理系统和用户级环境变量配置

#### 2.3 Maven 安装脚本

##### 2.3.1 安装 Maven

脚本位置：`environment/maven/install-maven.sh`

功能：自动安装 Apache Maven 3.8.8

执行方式：

```bash
# 交互式安装（推荐）
sudo ./environment/maven/install-maven.sh

# 自定义安装目录
sudo ./environment/maven/install-maven.sh -d /opt/maven

# 使用本地Maven包
sudo ./environment/maven/install-maven.sh -p /path/to/apache-maven-3.8.8.zip

# 强制安装（覆盖已有安装）
sudo ./environment/maven/install-maven.sh -f

# 静默安装
sudo ./environment/maven/install-maven.sh -q

# 强制静默安装
sudo ./environment/maven/install-maven.sh -f -q
```

##### 2.3.2 卸载 Maven

```bash
# 交互式删除（推荐）
sudo ./environment/jdk/remove-maven.sh

# 强制删除
sudo ./environment/jdk/remove-maven.sh -f

# 静默删除
sudo ./environment/jdk/remove-maven -f -q
```

### 3. Docker 安装脚本（CentOS 版本）

**脚本位置：** `run_install_docker_local.sh`

**功能：** 使用本地的 `install_docker.sh` 脚本安装 Docker（适用于 CentOS 7.9）

**执行方式：**

```bash
# 执行 Docker 安装（CentOS）
./run_install_docker_local.sh
```

**注意事项：**

- 脚本会自动检查 `install_docker.sh` 文件是否存在
- 如果需要 root 权限会自动请求
- 安装完成后会询问是否安装 Portainer 容器管理界面
- Portainer 访问地址： http://服务器IP:9000
- **仅支持 CentOS 系统**，使用 yum 包管理器

---

### 4. Docker 安装脚本（Ubuntu 版本）🆕

**脚本位置：** `run_install_docker_ubuntu.sh`

**功能：** 使用本地的 `install_docker_ubuntu.sh` 脚本安装 Docker（适用于 Ubuntu）

**执行方式：**

```bash
# 执行 Docker 安装（Ubuntu）
./run_install_docker_ubuntu.sh
```

**支持的 Ubuntu 版本：**
- Ubuntu 24.04 LTS (Noble)
- Ubuntu 22.04 LTS (Jammy) ✅ **推荐**
- Ubuntu 20.04 LTS (Focal)
- Ubuntu 18.04 LTS (Bionic)

**安装内容：**
- Docker CE（Community Edition）
- Docker CLI
- containerd.io
- Docker Buildx Plugin
- Docker Compose Plugin（官方插件，`docker compose` 命令）
- Docker Compose 独立版本（兼容版，`docker-compose` 命令）

**特色功能：**
- ✅ 自动检测系统是否为 Ubuntu
- ✅ 使用阿里云镜像源加速下载
- ✅ 添加 GPG 密钥验证
- ✅ 自动配置 Docker 镜像加速（国内优化）
- ✅ 完整的卸载清理功能
- ✅ 运行 hello-world 验证安装
- ✅ 可选安装 Portainer Web 管理界面

**注意事项：**

- 脚本会自动检查 `install_docker_ubuntu.sh` 文件是否存在
- 如果需要 root 权限会自动请求
- 使用 apt 包管理器（Ubuntu 专用）
- 安装完成后会询问是否安装 Portainer 容器管理界面
- Portainer 访问地址： http://服务器IP:9000

---

### 5. 软件安装脚本

脚本位置： run_install_software.sh

功能： 使用 Docker Compose 安装各种开发软件

执行方式：

```
# 执行软件安装
sudo ./run_install_software.sh
```

支持的软件：

- nacos - 服务注册与发现
- mysql - 数据库
- phpmyadmin - MySQL 管理界面
- redis - 缓存数据库
- redis-admin - Redis 管理界面
- rabbitmq - 消息队列
- elasticsearch - 搜索引擎
- logstash - 日志处理
- kibana - 日志分析界面
- xxl-job-admin - 任务调度
- prometheus - 监控系统
- grafana - 监控面板
- ollama - AI 模型服务
- pgvector - 向量数据库
- pgvector-admin - 向量数据库管理界面
  注意事项：

- 需要 root 权限执行
- 需要先安装 Docker 和 docker-compose
- 脚本会检查磁盘空间并显示预计占用
- 支持选择原始配置或阿里云镜像配置
- 可以多选软件进行批量安装

### 6. 常见问题

#### 6.1 权限问题

如果遇到权限拒绝错误：

```bash
# 确保脚本有执行权限
ls -la *.sh
# 如果没有 x 权限，重新添加
chmod +x script_name.sh
```

#### 6.2 环境变量生效

JDK 安装后，环境变量在当前会话中已生效，新开终端需要：

```bash
# 重新加载配置
source /etc/profile
# 或者重新登录
```

#### 6.3 Docker 相关

确保 Docker 服务正在运行：

```bash
# 检查 Docker 状态
sudo systemctl status docker
# 启动 Docker 服务
sudo systemctl start docker
```

#### 6.4 系统选择问题

**问：我应该选择 Ubuntu 还是 CentOS？**

- **Ubuntu 22.04 LTS** - 推荐现代云原生应用、容器化环境、快速开发
- **CentOS 7.9** - 推荐企业级应用、传统架构、长期稳定性需求

**问：我的系统是 Debian，可以用 Ubuntu 脚本吗？**

可以尝试，但建议手动验证。Debian 和 Ubuntu 都使用 apt，理论上兼容。

---

### 7. 执行顺序建议

#### 🐧 Ubuntu 系统安装顺序

```bash
# 1. 安装 JDK（如果需要）
sudo ./environment/jdk/install-java.sh -v 8

# 2. 安装 Docker（Ubuntu 版本）
./run_install_docker_ubuntu.sh

# 3. 安装 Maven（如果需要）
sudo ./environment/maven/install-maven.sh

# 4. 安装开发软件
sudo ./run_install_software.sh
```

#### 🔴 CentOS 系统安装顺序

```bash
# 1. 安装 JDK（如果需要）
sudo ./environment/jdk/install-java.sh -v 8

# 2. 安装 Docker（CentOS 版本）
./run_install_docker_local.sh

# 3. 安装 Maven（如果需要）
sudo ./environment/maven/install-maven.sh

# 4. 安装开发软件
sudo ./run_install_software.sh
```

#### 📝 说明

- **JDK** - 如果只需要 Docker 环境可跳过
- **Maven** - 如果只需要 Docker 环境可跳过
- **Docker** - 核心组件，必须安装
- **开发软件** - 根据需要选择安装（MySQL、Redis、RabbitMQ 等）

按照以上步骤，您就可以成功执行所有脚本并搭建完整的开发环境。

---

## 📄 许可证

本项目基于原作者小傅哥的开源项目进行 Ubuntu 适配，遵循原项目的开源协议。

**原始项目：** [xfg-dev-tech-docker-install](https://github.com/fuzhengwei/xfg-dev-tech-docker-install)

**适配版本：** [xfg-dev-tech-docker-install (Ubuntu适配)](https://github.com/Oohxjh/xfg-dev-tech-docker-install)

感谢小傅哥的开源贡献！❤️


