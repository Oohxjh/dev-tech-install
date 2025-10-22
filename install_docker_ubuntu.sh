#!/bin/bash

# ============================================================================
# Docker 自动化安装脚本 - Ubuntu 版本
# ============================================================================
# 原作者：小傅哥 (xiaofuge)
# Ubuntu 适配：Oohxjh
# 版本：2.0-ubuntu
# 最后更新：2025-01-22
# 
# 说明：
#   本脚本用于在 Ubuntu 系统上自动化安装 Docker Engine 和 Docker Compose
#   支持 Ubuntu 18.04/20.04/22.04/24.04 LTS 版本
#   遵循 Docker 官方安装文档的最佳实践
#
# 参考文档：
#   https://docs.docker.com/engine/install/ubuntu/
# ============================================================================

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 输出带颜色的信息函数
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# 检查是否以root用户运行
if [ "$(id -u)" -ne 0 ]; then
    warning "此脚本需要root权限运行，将尝试使用sudo"
    # 如果不是root用户，则使用sudo重新运行此脚本
    exec sudo "$0" "$@"
    exit $?
fi

info "Docker 环境自动化安装脚本 (Ubuntu 版本)"
info "原作者：xiaofuge | Ubuntu 适配：Oohxjh"

# 显示系统信息
info "开始安装 Docker 环境..."
info "检查系统信息..."
echo "内核版本: $(uname -r)"
echo "操作系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2)"

# 检查是否为Ubuntu系统
if ! grep -qi "ubuntu" /etc/os-release; then
    warning "检测到非Ubuntu系统，此脚本专为Ubuntu设计"
    read -p "是否继续安装？(y/n): " CONTINUE_INSTALL
    if [[ ! "$CONTINUE_INSTALL" =~ ^[Yy]$ ]]; then
        info "用户取消安装"
        exit 0
    fi
fi

# 检查是否已安装Docker
if command -v docker &> /dev/null; then
    INSTALLED_DOCKER_VERSION=$(docker --version | cut -d ' ' -f3 | cut -d ',' -f1)
    warning "检测到系统已安装Docker，版本为: $INSTALLED_DOCKER_VERSION"
    
    # 询问用户是否卸载已安装的Docker
    read -p "是否卸载已安装的Docker并安装新版本？(y/n): " UNINSTALL_DOCKER
    
    if [[ "$UNINSTALL_DOCKER" =~ ^[Yy]$ ]]; then
        info "开始卸载已安装的Docker..."
        systemctl stop docker &> /dev/null
        apt-get remove -y docker-ce docker-ce-cli containerd.io docker docker-engine docker.io containerd runc &> /dev/null
        apt-get purge -y docker-ce docker-ce-cli containerd.io &> /dev/null
        apt-get autoremove -y &> /dev/null
        rm -rf /var/lib/docker
        rm -rf /var/lib/containerd
        info "Docker卸载完成"
    else
        info "用户选择保留已安装的Docker，退出安装程序"
        exit 0
    fi
fi

# 更新系统包索引
info "更新系统包索引..."
apt-get update -y || error "系统更新失败"

# 安装依赖包
info "安装Docker依赖包..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release || error "依赖包安装失败"

# 添加Docker官方GPG密钥
info "添加Docker官方GPG密钥..."
mkdir -p -m 0755 /etc/apt/keyrings
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || error "下载GPG密钥失败"
chmod a+r /etc/apt/keyrings/docker.asc || error "设置GPG密钥权限失败"

# 设置Docker仓库（使用阿里云镜像）
info "添加Docker仓库（阿里云镜像）..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null || error "添加Docker仓库失败"

# 更新apt包索引
info "更新apt包索引..."
apt-get update -y || error "更新包索引失败"

# 安装Docker Engine
info "安装Docker CE、CLI和相关插件..."
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin || error "Docker安装失败"

# 安装独立的Docker Compose（可选，提供传统的docker-compose命令）
info "安装 Docker Compose 独立版本（兼容性）..."
info "注意：推荐使用 'docker compose' (插件版本，已随 Docker 安装)"
info "独立版本仅为保持向后兼容性，适用于旧脚本"
curl -L https://gitee.com/fustack/docker-compose/releases/download/v2.24.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose 2>/dev/null || {
    warning "Docker Compose 独立版本下载失败（可选组件，不影响使用）"
}
if [ -f /usr/local/bin/docker-compose ]; then
    chmod +x /usr/local/bin/docker-compose
    info "Docker Compose 独立版本安装成功"
fi

# 启动Docker服务
info "启动Docker服务..."
systemctl start docker || error "Docker服务启动失败"

# 设置Docker开机自启
info "设置Docker开机自启..."
systemctl enable docker || error "设置Docker开机自启失败"

# 配置Docker镜像加速
info "配置 Docker 镜像加速（国内服务器优化）..."
info "说明：海外服务器可跳过此步骤，Docker 会自动使用官方源"

# 检查 daemon.json 是否已存在
if [ -f /etc/docker/daemon.json ]; then
    warning "检测到已存在的 daemon.json 配置文件"
    cp /etc/docker/daemon.json /etc/docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)
    info "已备份原配置文件"
fi

mkdir -p /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": [
    "https://docker.1ms.run",
    "https://docker.1panel.live",
    "https://docker.ketches.cn"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

info "镜像加速配置已写入 /etc/docker/daemon.json"

# 重启Docker服务以应用配置
info "重启 Docker 服务以应用配置..."
systemctl restart docker || error "Docker 重启失败"

# 验证Docker安装
info "验证Docker安装..."
DOCKER_VERSION=$(docker --version)
echo "Docker版本: $DOCKER_VERSION"

# 验证Docker Compose
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_VERSION=$(docker-compose --version)
    echo "Docker Compose版本（独立）: $DOCKER_COMPOSE_VERSION"
fi

# 验证Docker Compose Plugin
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE_PLUGIN_VERSION=$(docker compose version)
    echo "Docker Compose版本（插件）: $DOCKER_COMPOSE_PLUGIN_VERSION"
fi

# 验证Docker运行
info "验证 Docker 运行状态..."
echo -n "正在运行 hello-world 测试容器... "
if docker run --rm hello-world &> /tmp/docker-test.log; then
    echo "✅"
    info "Docker 运行测试成功！"
else
    echo "❌"
    warning "Docker 运行测试失败，但安装已完成"
    warning "请检查日志: /tmp/docker-test.log"
fi

echo ""
echo "=========================================================="
echo "✅ Docker 环境安装完成！"
echo "=========================================================="
echo ""
echo "📦 已安装组件："
echo "   ✓ Docker Engine: $DOCKER_VERSION"
if docker compose version &> /dev/null; then
    echo "   ✓ Docker Compose Plugin: $(docker compose version --short 2>/dev/null || echo '已安装')"
fi
if command -v docker-compose &> /dev/null; then
    echo "   ✓ Docker Compose (独立): $(docker-compose --version 2>/dev/null | awk '{print $NF}')"
fi
echo "   ✓ Docker Buildx Plugin"
echo "   ✓ containerd.io"
echo ""

echo "🚀 常用命令："
echo "   docker --version              # 查看 Docker 版本"
echo "   docker compose version        # 查看 Compose 版本（推荐）"
echo "   docker ps                     # 查看运行中的容器"
echo "   docker images                 # 查看本地镜像"
echo "   docker run hello-world        # 测试 Docker"
echo "   systemctl status docker       # 查看 Docker 服务状态"
echo ""

echo "⚡ 镜像加速源："
echo "   ✓ https://docker.1ms.run"
echo "   ✓ https://docker.1panel.live"
echo "   ✓ https://docker.ketches.cn"
echo ""
echo "   配置文件: /etc/docker/daemon.json"
echo "   如镜像源失效，请访问: https://status.1panel.top/status/docker"
echo ""

echo "📚 帮助文档："
echo "   Docker 官方文档: https://docs.docker.com/"
echo "   Compose 官方文档: https://docs.docker.com/compose/"
echo ""

info "提示：重新登录终端或运行 'newgrp docker' 以应用用户组权限"
echo "=========================================================="
