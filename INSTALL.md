# PanBox 部署指南

## 快速安装

### 方式一：在线一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh | sudo bash
```

### 方式二：下载后安装

```bash
# 下载安装脚本
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh -o install.sh

# 添加执行权限
chmod +x install.sh

# 运行脚本
sudo ./install.sh
```

---

## 管理菜单

运行脚本后会显示管理菜单：

```
  ____              ____
 |  _ \ __ _ _ __ | __ )  _____  __
 | |_) / _` | '_ \|  _ \ / _ \ \/ /
 |  __/ (_| | | | | |_) | (_) >  <
 |_|   \__,_|_| |_|____/ \___/_/\_\

     网盘自动转存系统 - 管理脚本
          Version 2.0

请选择操作：
  1) 安装 PanBox
  2) 更新 PanBox
  3) 重启 PanBox
  4) 停止 PanBox
  0) 退出
```

---

## 功能说明

### 1. 安装 PanBox

**功能：**
- 创建数据目录 `/opt/panbox-autosave/`
- 下载 `docker-compose.yml` 配置文件
- 自动检测可用端口（从 1888 开始，如占用则递增）
- 拉取 Docker 镜像
- 启动服务

**端口分配规则：**
- 默认尝试端口：`1888`
- 如果占用，自动尝试：`1889`、`1890`、`1891`...
- 最多尝试 100 个端口

**完成后显示：**
```
访问地址：
  公网: http://123.45.67.89:1888
  内网: http://192.168.1.100:1888
```

### 2. 更新 PanBox

**功能：**
- 拉取最新 Docker 镜像
- 重启服务应用更新

**操作：**
```bash
docker pull kokojacket/panbox-autosave:latest
docker-compose up -d
```

### 3. 重启 PanBox

**功能：**
- 重启所有服务（应用 + 数据库）

**操作：**
```bash
docker-compose restart
```

### 4. 停止 PanBox

**功能：**
- 停止并删除容器（数据保留）

**操作：**
```bash
docker-compose down
```

---

## 数据库配置

**固定配置（无需修改）：**
- 数据库名：`panbox-autosave`
- 用户名：`panbox-autosave`
- 密码：`panbox-autosave`

---

## 目录结构

```
/opt/panbox-autosave/
├── docker-compose.yml    # Docker Compose 配置文件
├── logs/                 # 应用日志目录
└── postgres/             # PostgreSQL 数据目录
```

---

## 前置要求

- **操作系统**：Linux（Ubuntu、Debian、CentOS 等）
- **Docker**：20.10+
- **Docker Compose**：1.29+ 或 Docker Compose V2
- **权限**：root 或 sudo

---

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

---

## 常用命令

```bash
# 进入安装目录
cd /opt/panbox-autosave

# 查看日志
docker-compose logs -f panbox-autosave
docker-compose logs -f postgres

# 查看服务状态
docker-compose ps

# 手动启动服务
docker-compose up -d

# 手动停止服务
docker-compose down

# 手动重启服务
docker-compose restart
```

---

## 故障排查

### 1. Docker 未安装

```bash
curl -fsSL https://get.docker.com | bash
```

### 2. 端口被占用

脚本会自动检测并使用下一个可用端口（1888 → 1889 → 1890...）

如需手动修改端口，编辑 `/opt/panbox-autosave/docker-compose.yml`：

```yaml
ports:
  - "8080:8000"  # 改为 8080
```

然后重启服务：

```bash
cd /opt/panbox-autosave
docker-compose down
docker-compose up -d
```

### 3. 无法获取公网 IP

脚本会尝试多个 IP 查询服务：
- https://api.ipify.org
- https://ifconfig.me
- https://icanhazip.com

如果都失败，会显示"无法获取"，但不影响使用内网 IP 访问。

### 4. 查看详细日志

```bash
cd /opt/panbox-autosave
docker-compose logs -f
```

### 5. 重新安装

```bash
# 停止服务
cd /opt/panbox-autosave
docker-compose down

# 删除旧数据（可选，会删除所有数据）
sudo rm -rf /opt/panbox-autosave

# 重新运行安装脚本
sudo bash install.sh
```

---

## 卸载

```bash
# 停止并删除容器
cd /opt/panbox-autosave
docker-compose down -v

# 删除数据目录（可选，会删除所有数据）
sudo rm -rf /opt/panbox-autosave

# 删除 Docker 镜像（可选）
docker rmi kokojacket/panbox-autosave:latest
docker rmi postgres:16-alpine
```

---

## 备份与恢复

### 备份数据库

```bash
# 备份到当前目录
docker exec panbox-autosave-postgres pg_dump -U panbox-autosave panbox-autosave > backup.sql

# 备份到指定目录
docker exec panbox-autosave-postgres pg_dump -U panbox-autosave panbox-autosave > /backup/panbox-$(date +%Y%m%d).sql
```

### 恢复数据库

```bash
# 停止应用（保留数据库）
cd /opt/panbox-autosave
docker-compose stop panbox-autosave

# 恢复数据
cat backup.sql | docker exec -i panbox-autosave-postgres psql -U panbox-autosave panbox-autosave

# 重启应用
docker-compose start panbox-autosave
```

---

## 安全建议

1. **修改数据库密码**（生产环境）

编辑 `/opt/panbox-autosave/docker-compose.yml`：

```yaml
environment:
  POSTGRES_PASSWORD: "your-strong-password"
  DB_PASSWORD: "your-strong-password"
```

重启服务：

```bash
docker-compose down
docker-compose up -d
```

2. **配置防火墙**

```bash
# 仅允许特定 IP 访问
sudo ufw allow from 192.168.1.0/24 to any port 1888

# 或使用 iptables
sudo iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 1888 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 1888 -j DROP
```

3. **使用 HTTPS**

建议使用 Nginx 反向代理 + Let's Encrypt 证书。

---

## 技术支持

- **GitHub Issues**：https://github.com/kokojacket/panbox-autosave-open/issues
- **文档**：https://github.com/kokojacket/panbox-autosave-open
