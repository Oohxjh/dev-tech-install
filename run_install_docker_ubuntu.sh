#!/bin/bash

# ============================================================================
# Docker 安装包装脚本 - Ubuntu 版本
# ============================================================================
# 说明：
#   本脚本用于调用 install_docker_ubuntu.sh 完成 Docker 安装
#   并提供可选的 Portainer CE 容器管理界面安装
#
# 原作者：小傅哥 (xiaofuge)
# Ubuntu 适配：Oohxjh
# 版本：2.0
# ============================================================================

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
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

# 定义本地脚本文件名
LOCAL_SCRIPT_NAME="install_docker_ubuntu.sh"

info "====== Docker 自动化安装工具 (Ubuntu 版本) ======"
info "使用安装脚本: $LOCAL_SCRIPT_NAME"

# 检查本地脚本是否存在
if [ ! -f "$LOCAL_SCRIPT_NAME" ]; then
    error "本地脚本文件 $LOCAL_SCRIPT_NAME 不存在"
fi

# 设置可执行权限
info "设置可执行权限..."
chmod +x "$LOCAL_SCRIPT_NAME"

# 执行安装脚本
info "开始执行Docker安装脚本（Ubuntu版本）..."
info "注意：安装过程可能需要root权限，如果需要会自动请求"
echo "-----------------------------------------------------------"
./$LOCAL_SCRIPT_NAME

# 检查安装脚本的退出状态
if [ $? -eq 0 ]; then
    info "Docker安装脚本执行完成"
    
    echo ""
    info "====== Portainer CE 容器管理界面（可选）======"
    info "Portainer 提供友好的 Web 界面来管理 Docker 容器、镜像、网络和卷"
    echo ""
    
    # 询问用户是否安装Portainer
    read -p "是否安装Portainer CE？(y/n): " INSTALL_PORTAINER
    
    if [[ "$INSTALL_PORTAINER" =~ ^[Yy]$ ]]; then
        info "开始安装 Portainer CE (Community Edition) LTS 版本..."
        
        # 创建 Portainer 数据卷
        docker volume create portainer_data
        
        # 安装 Portainer CE (使用官方最新 LTS 镜像)
        docker run -d \
            -p 8000:8000 \
            -p 9443:9443 \
            --name portainer \
            --restart=always \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v portainer_data:/data \
            portainer/portainer-ce:lts
        
        if [ $? -eq 0 ]; then
            echo ""
            info "✅ Portainer CE 安装成功！"
            echo ""
            warning "⚠️  重要提示：请确保您的服务器防火墙已开放以下端口："
            echo "   - 9443 (HTTPS - Portainer Web 界面)"
            echo "   - 8000 (TCP - Edge Agent 通信，可选)"
            echo ""
            echo "=========================================================="
            echo "📌 Portainer CE 访问信息："
            echo "=========================================================="
            echo "🌐 Web 界面地址（推荐）："
            echo "   https://您的服务器IP:9443"
            echo "   或"
            echo "   https://$(hostname -I | awk '{print $1}'):9443"
            echo ""
            echo "⚙️  首次访问须知："
            echo "   1. 浏览器会提示安全警告（自签名证书），点击继续访问"
            echo "   2. 创建管理员账号和密码（密码至少12位）"
            echo "   3. 登录后即可通过 Web 界面管理 Docker 资源"
            echo ""
            echo "📚 功能说明："
            echo "   - 容器管理：启动、停止、重启、删除容器"
            echo "   - 镜像管理：拉取、删除、构建镜像"
            echo "   - 网络管理：创建、删除 Docker 网络"
            echo "   - 卷管理：管理数据卷"
            echo "   - 日志查看：实时查看容器日志"
            echo "=========================================================="
            echo ""
            info "提示：如需使用 HTTP（端口 9000），请手动修改容器配置"
        else
            warning "Portainer 安装失败，请手动安装或检查 Docker 状态"
            echo "手动安装命令："
            echo "  docker volume create portainer_data"
            echo "  docker run -d -p 8000:8000 -p 9443:9443 --name portainer \\"
            echo "    --restart=always \\"
            echo "    -v /var/run/docker.sock:/var/run/docker.sock \\"
            echo "    -v portainer_data:/data \\"
            echo "    portainer/portainer-ce:lts"
        fi
    else
        info "跳过 Portainer 安装"
        info "如需后续安装，请运行："
        echo "  docker volume create portainer_data"
        echo "  docker run -d -p 8000:8000 -p 9443:9443 --name portainer \\"
        echo "    --restart=always \\"
        echo "    -v /var/run/docker.sock:/var/run/docker.sock \\"
        echo "    -v portainer_data:/data \\"
        echo "    portainer/portainer-ce:lts"
    fi
else
    error "Docker安装脚本执行失败，请查看上面的错误信息"
fi
