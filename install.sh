#!/bin/bash

#==============================================================================
# PanBox 一键部署脚本
# 版本：1.0
# 用途：自动化部署 PanBox 网盘自动转存系统
#==============================================================================

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
INSTALL_DIR="/opt/panbox-autosave"
COMPOSE_URL="https://raw.githubusercontent.com/kokojacket/panbox-autosave/main/docker-compose.yml"
DOCKER_IMAGE="kokojacket/panbox-autosave:latest"

#==============================================================================
# 工具函数
#==============================================================================

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
}

#==============================================================================
# 检查函数
#==============================================================================

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "请使用 root 权限运行此脚本"
        echo "使用方法: sudo bash install.sh"
        exit 1
    fi
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "未检测到 Docker，请先安装 Docker"
        echo ""
        echo "安装方法："
        echo "  curl -fsSL https://get.docker.com | bash"
        exit 1
    fi
    print_success "Docker 已安装: $(docker --version)"
}

check_docker_compose() {
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "未检测到 Docker Compose，请先安装"
        echo ""
        echo "安装方法（Docker Compose V2）："
        echo "  已包含在 Docker 中，使用: docker compose"
        exit 1
    fi

    # 检测使用的是哪个版本
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
        print_success "Docker Compose 已安装: $(docker-compose --version)"
    else
        DOCKER_COMPOSE_CMD="docker compose"
        print_success "Docker Compose 已安装: $(docker compose version)"
    fi
}

#==============================================================================
# 主要功能函数
#==============================================================================

create_directories() {
    print_header "创建数据目录"

    mkdir -p "$INSTALL_DIR/logs"
    mkdir -p "$INSTALL_DIR/postgres"

    print_success "数据目录创建完成:"
    echo "  - $INSTALL_DIR/logs"
    echo "  - $INSTALL_DIR/postgres"
}

generate_password() {
    # 生成随机密码（20位，包含字母数字特殊字符）
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-20
}

get_database_password() {
    print_header "配置数据库密码"

    echo -e "${YELLOW}请选择密码配置方式：${NC}"
    echo "  1) 自动生成强密码（推荐）"
    echo "  2) 手动输入密码"
    echo ""

    while true; do
        read -p "请选择 [1/2]: " choice
        case $choice in
            1)
                DB_PASSWORD=$(generate_password)
                print_success "已生成强密码"
                echo ""
                echo -e "${YELLOW}⚠️  请妥善保存以下密码！${NC}"
                echo -e "${GREEN}数据库密码: $DB_PASSWORD${NC}"
                echo ""
                read -p "按 Enter 键继续..."
                break
                ;;
            2)
                while true; do
                    read -sp "请输入数据库密码: " DB_PASSWORD
                    echo ""

                    if [ -z "$DB_PASSWORD" ]; then
                        print_error "密码不能为空"
                        continue
                    fi

                    if [ ${#DB_PASSWORD} -lt 8 ]; then
                        print_error "密码长度不能少于 8 位"
                        continue
                    fi

                    read -sp "请再次输入密码确认: " DB_PASSWORD_CONFIRM
                    echo ""

                    if [ "$DB_PASSWORD" != "$DB_PASSWORD_CONFIRM" ]; then
                        print_error "两次密码不一致，请重新输入"
                        continue
                    fi

                    print_success "密码设置成功"
                    break
                done
                break
                ;;
            *)
                print_error "无效选择，请输入 1 或 2"
                ;;
        esac
    done
}

download_compose_file() {
    print_header "下载配置文件"

    print_info "正在从 GitHub 下载 docker-compose.yml..."

    if curl -fsSL "$COMPOSE_URL" -o "$INSTALL_DIR/docker-compose.yml"; then
        print_success "配置文件下载成功"
    else
        print_error "下载失败，请检查网络连接"
        exit 1
    fi
}

update_compose_passwords() {
    print_header "更新配置文件密码"

    cd "$INSTALL_DIR"

    # 使用 sed 替换密码（兼容 Linux 和 macOS）
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/POSTGRES_PASSWORD: \".*\"/POSTGRES_PASSWORD: \"$DB_PASSWORD\"/g" docker-compose.yml
        sed -i '' "s/DB_PASSWORD: \".*\"/DB_PASSWORD: \"$DB_PASSWORD\"/g" docker-compose.yml
    else
        # Linux
        sed -i "s/POSTGRES_PASSWORD: \".*\"/POSTGRES_PASSWORD: \"$DB_PASSWORD\"/g" docker-compose.yml
        sed -i "s/DB_PASSWORD: \".*\"/DB_PASSWORD: \"$DB_PASSWORD\"/g" docker-compose.yml
    fi

    print_success "密码配置完成"
}

pull_docker_image() {
    print_header "拉取 Docker 镜像"

    print_info "正在拉取镜像: $DOCKER_IMAGE"
    print_info "这可能需要几分钟，请耐心等待..."

    if docker pull "$DOCKER_IMAGE"; then
        print_success "镜像拉取成功"
    else
        print_error "镜像拉取失败，请检查网络连接"
        exit 1
    fi
}

start_services() {
    print_header "启动服务"

    cd "$INSTALL_DIR"

    print_info "正在启动 PanBox 服务..."

    if $DOCKER_COMPOSE_CMD up -d; then
        print_success "服务启动成功！"
    else
        print_error "服务启动失败"
        exit 1
    fi

    echo ""
    print_info "等待服务健康检查..."
    sleep 5

    # 显示服务状态
    $DOCKER_COMPOSE_CMD ps
}

show_final_info() {
    print_header "部署完成"

    echo -e "${GREEN}🎉 PanBox 已成功部署！${NC}"
    echo ""
    echo "访问地址:"
    echo -e "  ${BLUE}http://localhost:8000${NC}"
    echo -e "  ${BLUE}http://$(hostname -I | awk '{print $1}'):8000${NC}"
    echo ""
    echo "数据目录:"
    echo "  $INSTALL_DIR/logs      - 日志文件"
    echo "  $INSTALL_DIR/postgres  - 数据库文件"
    echo ""
    echo "常用命令:"
    echo "  查看日志:    cd $INSTALL_DIR && $DOCKER_COMPOSE_CMD logs -f"
    echo "  停止服务:    cd $INSTALL_DIR && $DOCKER_COMPOSE_CMD down"
    echo "  重启服务:    cd $INSTALL_DIR && $DOCKER_COMPOSE_CMD restart"
    echo "  查看状态:    cd $INSTALL_DIR && $DOCKER_COMPOSE_CMD ps"
    echo ""
    echo -e "${YELLOW}⚠️  重要提醒：${NC}"
    echo "  - 数据库密码已保存在: $INSTALL_DIR/docker-compose.yml"
    echo "  - 请妥善保管密码，如需修改请编辑该文件"
    echo "  - 备份数据库: docker exec panbox-postgres pg_dump -U panbox panbox > backup.sql"
    echo ""
}

#==============================================================================
# 主流程
#==============================================================================

main() {
    clear

    cat << "EOF"
  ____              ____
 |  _ \ __ _ _ __ | __ )  _____  __
 | |_) / _` | '_ \|  _ \ / _ \ \/ /
 |  __/ (_| | | | | |_) | (_) >  <
 |_|   \__,_|_| |_|____/ \___/_/\_\

     网盘自动转存系统 - 一键部署脚本
          Version 1.0
EOF

    echo ""
    echo -e "${BLUE}此脚本将自动完成以下操作：${NC}"
    echo "  1. 检查系统环境（Docker、Docker Compose）"
    echo "  2. 创建数据目录 ($INSTALL_DIR)"
    echo "  3. 配置数据库密码"
    echo "  4. 下载配置文件"
    echo "  5. 拉取 Docker 镜像"
    echo "  6. 启动服务"
    echo ""

    read -p "按 Enter 键开始安装，或 Ctrl+C 取消..."

    # 执行安装步骤
    check_root
    check_docker
    check_docker_compose
    create_directories
    get_database_password
    download_compose_file
    update_compose_passwords
    pull_docker_image
    start_services
    show_final_info
}

# 运行主函数
main
