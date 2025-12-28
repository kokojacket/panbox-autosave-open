# PanBox AutoSave - 一键部署

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/docker-ready-brightgreen.svg" alt="Docker">
</p>

网盘自动转存系统 - 开箱即用的 Docker 部署方案

## ✨ 核心功能

- 🔗 **多网盘支持** - 支持百度网盘、夸克网盘、UC网盘
- ⏰ **定时转存** - 基于 Cron 表达式的灵活定时任务
- 📁 **智能管理** - 自定义目标目录、文件过滤、重命名规则
- 📊 **状态追踪** - 详细的转存记录和执行日志
- 🎯 **批次通知** - 智能聚合通知，文件树展示
- 🔐 **License 管理** - 完整的用户认证和套餐限制

## 🚀 快速开始

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh | sudo bash
```

安装脚本会自动：
- ✅ 检查 Docker 环境
- ✅ 创建数据目录
- ✅ 配置数据库密码（支持自动生成）
- ✅ 下载配置文件
- ✅ 拉取镜像并启动服务

详细安装说明请查看：[INSTALL.md](./INSTALL.md)

### 手动部署

<details>
<summary>点击展开手动部署步骤</summary>

#### 1. 创建数据目录

```bash
sudo mkdir -p /opt/panbox-autosave/logs
sudo mkdir -p /opt/panbox-autosave/postgres
```

#### 2. 下载配置文件

```bash
cd /opt/panbox-autosave
wget https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/docker-compose.yml
```

#### 3. 修改数据库密码

编辑 `docker-compose.yml`，修改以下两处密码：

```yaml
# PostgreSQL 服务
POSTGRES_PASSWORD: "your-secure-password"

# PanBox 服务
DB_PASSWORD: "your-secure-password"
```

⚠️ **确保两处密码一致！**

#### 4. 启动服务

```bash
docker-compose up -d
```

#### 5. 访问应用

浏览器打开：http://localhost:8000

</details>

## 💎 套餐体系

| 套餐 | 最大账号数 | 每账号任务数 | 价格 | 有效期 |
|------|-----------|-------------|------|--------|
| Free | 1 | 3 | 免费 | 永久 |
| Basic | 1 | 20 | ¥29 | 1年 |
| Pro | 3 | 80 | ¥99 | 1年 |
| Ultra | 10 | 200 | ¥299 | 1年 |

## 🔧 常用命令

```bash
# 查看日志
cd /opt/panbox-autosave && docker-compose logs -f

# 停止服务
cd /opt/panbox-autosave && docker-compose down

# 重启服务
cd /opt/panbox-autosave && docker-compose restart

# 查看状态
cd /opt/panbox-autosave && docker-compose ps

# 备份数据库
docker exec panbox-postgres pg_dump -U panbox panbox > backup.sql
```

## 📦 数据备份

### 完整备份（推荐）

```bash
sudo tar -czf panbox_backup_$(date +%Y%m%d).tar.gz /opt/panbox-autosave/
```

### 数据库备份

```bash
docker exec panbox-postgres pg_dump -U panbox panbox > backup.sql
```

### 恢复数据

```bash
# 恢复完整备份
sudo tar -xzf panbox_backup_20251228.tar.gz -C /

# 恢复数据库
cat backup.sql | docker exec -i panbox-postgres psql -U panbox -d panbox
```

## 🐛 故障排查

### 容器无法启动

```bash
# 查看日志
docker-compose logs panbox

# 检查端口占用
sudo lsof -i :8000

# 检查数据目录权限
ls -la /opt/panbox-autosave/
```

### 数据库连接失败

```bash
# 检查 PostgreSQL 状态
docker-compose ps postgres

# 查看 PostgreSQL 日志
docker-compose logs postgres

# 验证密码配置
grep -E "POSTGRES_PASSWORD|DB_PASSWORD" docker-compose.yml
```

## 🛠️ 技术栈

### 后端
- Python 3.12+
- FastAPI - 现代化 Web 框架
- SQLAlchemy - ORM
- PostgreSQL - 数据库
- APScheduler - 定时任务

### 前端
- Vue 3 - 渐进式框架
- TypeScript - 类型系统
- Vite - 构建工具
- Ant Design Vue - UI 组件库
- Tailwind CSS - 原子化样式

### 部署
- Docker & Docker Compose
- 多架构支持（amd64/arm64）

## 📄 开源协议

[MIT License](./LICENSE)

## 📮 联系方式

- 项目主页：https://github.com/kokojacket/panbox-autosave-open
- 问题反馈：https://github.com/kokojacket/panbox-autosave-open/issues
- 完整源码：https://github.com/kokojacket/panbox-autosave

---

<p align="center">
  Made with ❤️ by PanBox Team
</p>
