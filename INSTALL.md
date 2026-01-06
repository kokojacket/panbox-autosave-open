# PanBox 部署指南

## 快速安装

### 方式一：在线一键安装（推荐）

**国内用户推荐使用代理加速（优先尝试）：**

```bash
# 方法 1: gh-proxy.org 代理（推荐）
curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh | sudo bash

# 方法 2: 香港代理
curl -fsSL https://hk.gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh | sudo bash

# 方法 3: CDN 代理
curl -fsSL https://cdn.gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh | sudo bash
```

**海外用户或代理失败时使用原始地址：**

```bash
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh | sudo bash
```

### 方式二：下载后安装

```bash
# 国内用户推荐使用代理下载
curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh -o install.sh

# 或使用原始地址
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh -o install.sh

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
- 下载 `docker-compose.yml` 配置文件（**自动重试多个镜像源**）
- 自动检测可用端口（从 1888 开始，如占用则递增）
- 拉取 Docker 镜像
- 启动服务

**智能下载机制：**

脚本内置了 5 个备用下载源，会自动依次尝试：
1. gh-proxy.org 代理（国内加速）
2. 香港代理（hk.gh-proxy.org）
3. CDN 代理（cdn.gh-proxy.org）
4. EdgeOne 代理（edgeone.gh-proxy.org）
5. GitHub 原始地址（海外直连）

下载过程示例：
```
[INFO] 下载配置文件...
[INFO] [1/5] 尝试下载: gh-proxy.org 代理
[SUCCESS] 配置文件下载成功
```

**端口分配规则：**
- 默认尝试端口：`1888`
- 如果占用，自动尝试：`1889`、`1890`、`1891`...
- 最多尝试 100 个端口

**完成后显示：**

示例 1 - 双栈服务器（IPv4 + IPv6）：
```
访问地址：
  公网 IPv4: http://123.45.67.89:1888
  公网 IPv6: http://[2402:4e00:c030:7100::1]:1888
  内网: http://192.168.1.100:1888

提示：
  - 优先使用 IPv4 地址访问（兼容性更好）
  - IPv6 地址需要用方括号 [] 包裹
```

示例 2 - 仅 IPv6 服务器：
```
访问地址：
  公网 IPv6: http://[2402:4e00:c030:7100::1]:1888
  内网: http://10.0.4.2:1888

提示：
  - 当前服务器仅有 IPv6 公网地址
  - IPv6 地址需要用方括号 [] 包裹
  - 建议使用内网 IPv4 地址访问（兼容性更好）
```

示例 3 - 纯内网服务器：
```
访问地址：
  公网 IP: 无法获取（纯内网环境）
  内网: http://192.168.1.100:1888
```

**智能 IP 检测：**
- 公网：同时检测 IPv4 和 IPv6，显示所有可用地址
- 内网：仅显示 IPv4（实用性和兼容性最佳）
- 公网 IPv4：依次尝试 ipify.org、ifconfig.me、icanhazip.com、ip.sb
- 公网 IPv6：依次尝试 api64.ipify.org、icanhazip.com、ip.sb
- 内网 IPv4：使用 hostname、ip route、ifconfig 多种方法获取

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

### 1. 配置文件下载失败

**症状：**
```
[INFO] [1/5] 尝试下载: gh-proxy.org 代理
[WARNING] 下载失败，尝试下一个地址...
[INFO] [2/5] 尝试下载: 香港代理
...
[ERROR] 所有下载地址均失败，请检查网络连接或稍后重试
```

**解决方法：**

方法 1：检查网络连接
```bash
# 测试网络连通性
curl -I https://www.baidu.com
ping 8.8.8.8

# 如果是防火墙问题，临时关闭测试
sudo ufw disable  # Ubuntu/Debian
sudo systemctl stop firewalld  # CentOS/RHEL
```

方法 2：手动下载配置文件
```bash
# 创建目录
sudo mkdir -p /opt/panbox-autosave

# 手动下载（依次尝试以下地址）
sudo curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/docker-compose.yml -o /opt/panbox-autosave/docker-compose.yml

# 或使用 wget
sudo wget https://gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/docker-compose.yml -O /opt/panbox-autosave/docker-compose.yml

# 验证下载成功
ls -lh /opt/panbox-autosave/docker-compose.yml
```

方法 3：使用代理下载脚本
```bash
# 通过代理下载脚本
export https_proxy=http://your-proxy:port
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh | sudo bash
```

### 2. Docker 未安装

```bash
curl -fsSL https://get.docker.com | bash
```

### 3. 端口被占用

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

### 4. 无法获取公网 IP

**IPv4 查询服务：**
- https://api.ipify.org (强制 IPv4)
- https://ifconfig.me (强制 IPv4)
- https://icanhazip.com (强制 IPv4)
- https://api.ip.sb/ip (强制 IPv4)

**IPv6 查询服务：**
- https://api64.ipify.org (强制 IPv6)
- https://icanhazip.com (强制 IPv6)
- https://api.ip.sb/ip (强制 IPv6)

如果某个协议版本查询失败，会显示"无法获取"，但不影响使用另一个协议版本访问。

**常见情况：**
- 仅 IPv4：公网 IPv4 显示，IPv6 不显示
- 仅 IPv6：公网 IPv6 显示，IPv4 不显示（会提示优先使用内网 IPv4）
- 双栈：IPv4 和 IPv6 都显示（推荐使用 IPv4）
- 纯内网：显示"公网 IP: 无法获取（纯内网环境）"，仅显示内网 IPv4

### 5. 查看详细日志

```bash
cd /opt/panbox-autosave
docker-compose logs -f
```

### 6. 重新安装

```bash
# 停止服务
cd /opt/panbox-autosave
docker-compose down

# 删除旧数据（可选，会删除所有数据）
sudo rm -rf /opt/panbox-autosave

# 重新运行安装脚本（使用代理加速）
curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh | sudo bash
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

## 常见问题 FAQ

### Q1: 为什么需要使用代理加速？

**A:** GitHub Raw 文件在国内访问速度较慢或可能被限制，使用代理镜像可以显著提升下载速度和成功率。脚本已内置 5 个备用源，会自动重试，无需手动干预。

### Q2: 代理安全吗？

**A:** 本脚本使用的都是知名的 GitHub 代理服务（gh-proxy.org 等），这些服务仅做文件转发，不修改内容。为确保安全：
- 脚本从官方仓库 `kokojacket/panbox-autosave-open` 获取
- 下载后可以查看 `install.sh` 和 `docker-compose.yml` 确认内容
- 所有配置文件均开源可审计

### Q3: 如何验证安装是否成功？

**A:** 安装完成后：
```bash
# 检查容器运行状态
docker ps | grep panbox

# 预期输出：
# panbox-autosave   Up 2 minutes   0.0.0.0:1888->8000/tcp
# panbox-postgres   Up 2 minutes   5432/tcp

# 访问 Web 界面（替换为你的 IP 和端口）
curl http://localhost:1888
```

### Q4: 安装后如何更新到最新版本？

**A:**
```bash
# 方法 1: 使用管理脚本
sudo bash install.sh
# 选择菜单中的 "2) 更新 PanBox"

# 方法 2: 手动更新
cd /opt/panbox-autosave
docker pull kokojacket/panbox-autosave:latest
docker-compose up -d
```

### Q5: 多个备用源都失败了怎么办？

**A:** 按以下步骤排查：

1. 检查服务器网络连接
```bash
curl -I https://www.github.com
```

2. 尝试手动下载测试
```bash
curl -v https://gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/docker-compose.yml
```

3. 使用代理服务器
```bash
export https_proxy=http://your-proxy:port
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/deploy/install.sh | sudo bash
```

4. 联系技术支持并附上详细日志

---

## 技术支持

- **GitHub Issues**：https://github.com/kokojacket/panbox-autosave-open/issues
- **文档**：https://github.com/kokojacket/panbox-autosave-open
