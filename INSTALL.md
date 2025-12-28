# PanBox 一键部署

## 快速安装（推荐）

```bash
# 下载并运行安装脚本
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh | sudo bash
```

或者分步执行：

```bash
# 1. 下载安装脚本
wget https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh

# 2. 添加执行权限
chmod +x install.sh

# 3. 运行安装
sudo ./install.sh
```

## 安装脚本功能

✅ 自动检查 Docker 环境
✅ 创建数据目录 `/opt/panbox-autosave/`
✅ 配置数据库密码（支持自动生成或手动输入）
✅ 下载并配置 docker-compose.yml
✅ 拉取 Docker 镜像
✅ 一键启动服务

## 安装过程

```
1. 环境检查
   ├─ 检查 root 权限
   ├─ 检查 Docker
   └─ 检查 Docker Compose

2. 创建目录
   ├─ /opt/panbox-autosave/logs
   └─ /opt/panbox-autosave/postgres

3. 配置密码
   ├─ 选项 1: 自动生成强密码（推荐）
   └─ 选项 2: 手动输入密码

4. 下载配置
   └─ docker-compose.yml

5. 拉取镜像
   └─ kokojacket/panbox-autosave:latest

6. 启动服务
   ├─ panbox-autosave
   └─ postgres
```

## 卸载

```bash
# 停止并删除容器
cd /opt/panbox-autosave
docker-compose down -v

# 删除数据目录（可选，会删除所有数据）
sudo rm -rf /opt/panbox-autosave
```

## 常用命令

```bash
# 进入安装目录
cd /opt/panbox-autosave

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down

# 启动服务
docker-compose up -d

# 重启服务
docker-compose restart

# 查看状态
docker-compose ps
```

## 前置要求

- Linux 系统（Ubuntu、Debian、CentOS 等）
- Docker 20.10+
- Docker Compose 1.29+ 或 Docker Compose V2
- root 权限

## 安装 Docker（如未安装）

```bash
# 使用官方一键安装脚本
curl -fsSL https://get.docker.com | bash

# 启动 Docker 服务
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
docker --version
docker-compose --version
```

## 访问应用

安装完成后，浏览器访问：

```
http://localhost:8000
http://YOUR_SERVER_IP:8000
```

## 故障排查

### 1. Docker 未安装

```bash
curl -fsSL https://get.docker.com | bash
```

### 2. 端口被占用

```bash
# 检查端口占用
sudo lsof -i :8000

# 修改端口（编辑 docker-compose.yml）
ports:
  - "8080:8000"  # 改为 8080
```

### 3. 查看详细日志

```bash
cd /opt/panbox-autosave
docker-compose logs -f panbox
docker-compose logs -f postgres
```

### 4. 重新安装

```bash
# 停止服务
cd /opt/panbox-autosave
docker-compose down

# 删除旧数据（可选）
sudo rm -rf /opt/panbox-autosave

# 重新运行安装脚本
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh | sudo bash
```
