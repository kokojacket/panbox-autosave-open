# PanBox - 网盘自动转存系统

<div align="center">

![PanBox Logo](./docs/public/logo.svg)

**定时、批量、智能地将分享的网盘资源保存到你的网盘**

[![Docker Pulls](https://img.shields.io/docker/pulls/kokojacket/panbox)](https://hub.docker.com/r/kokojacket/panbox)
[![GitHub Stars](https://img.shields.io/github/stars/kokojacket/panbox-autosave?style=social)](https://github.com/kokojacket/panbox-autosave)
[![License](https://img.shields.io/github/license/kokojacket/panbox-autosave)](./LICENSE)

[快速开始](#快速开始) · [在线文档](https://docs.panbox.online) · [问题反馈](https://github.com/kokojacket/panbox-autosave/issues)

</div>

---

## ✨ 功能特性

- 🌐 **多网盘支持** - 支持百度网盘、夸克网盘、UC网盘
- ⏰ **定时任务** - 灵活的 Cron 定时配置，自动执行转存
- 📁 **智能管理** - 自定义目录、正则过滤、精准转存
- 📊 **状态追踪** - 详细的执行记录和日志
- 🔔 **批次通知** - PushPlus 多渠道聚合推送
- 🐳 **一键部署** - Docker Compose 快速部署
- 🔐 **License 管理** - 多套餐支持，Free 套餐永久免费

## 🚀 快速开始

### 一键安装

**国内用户（使用代理加速）：**

```bash
curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh | sudo bash
```

**海外用户：**

```bash
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh | sudo bash
```

### 使用 Docker Compose

```yaml
services:
  panbox:
    image: kokojacket/panbox:latest
    container_name: panbox
    ports:
      - "8000:8000"
    volumes:
      - ./data:/app/data
    environment:
      - PANBOX_LICENSE_BASE_URL=https://license.panbox.online
      - PANBOX_LICENSE_PRODUCT_NAME=panbox-autosave
    restart: unless-stopped
```

启动服务：

```bash
docker-compose up -d
```

访问 `http://localhost:8000` 开始使用！

## 📖 文档

完整文档请访问：**https://docs.panbox.online**

- [快速开始](https://docs.panbox.online/guide/getting-started)
- [安装部署](https://docs.panbox.online/guide/installation)
- [功能详解](https://docs.panbox.online/features/)
- [常见问题](https://docs.panbox.online/faq)

## 🌟 支持的网盘

| 网盘 | 账号管理 | 扫码登录 | Cookie 登录 | 转存功能 |
|------|---------|---------|------------|---------|
| 百度网盘 | ✅ | ✅ | ✅ | ✅ |
| 夸克网盘 | ✅ | ✅ | ✅ | ✅ |
| UC网盘 | ✅ | ✅ | ✅ | ✅ |

## 💎 License 套餐

| 套餐 | 最大账号数 | 每账号任务数 | 价格 | 有效期 |
|------|-----------|-------------|------|--------|
| Free | 1 | 3 | 免费 | 永久 |
| Basic | 1 | 20 | ¥29 | 1年 |
| Pro | 3 | 80 | ¥99 | 1年 |
| Ultra | 10 | 200 | ¥299 | 1年 |

## 🛠️ 系统要求

- **操作系统**：Linux（Ubuntu/Debian/CentOS）
- **Docker**：20.10+
- **内存**：至少 512MB RAM
- **存储**：至少 1GB 可用空间

## 🤝 参与贡献

欢迎参与 PanBox 的开发和完善！

- 🐛 [报告 Bug](https://github.com/kokojacket/panbox-autosave/issues)
- 💡 [提出建议](https://github.com/kokojacket/panbox-autosave/discussions)
- ⭐ [Star 项目](https://github.com/kokojacket/panbox-autosave)

## 📝 开源协议

本项目采用 [MIT License](./LICENSE) 开源协议。

## 🔗 相关链接

- [GitHub 主仓库](https://github.com/kokojacket/panbox-autosave)
- [Docker Hub](https://hub.docker.com/r/kokojacket/panbox)
- [在线文档](https://docs.panbox.online)
- [问题反馈](https://github.com/kokojacket/panbox-autosave/issues)

---

<div align="center">

**如果这个项目对你有帮助，请给我们一个 ⭐ Star！**

Made with ❤️ by PanBox Team

</div>
