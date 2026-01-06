---
layout: home

hero:
  name: PanBox
  text: 网盘自动转存系统
  tagline: 定时、批量、智能地将分享的网盘资源保存到你的网盘
  image:
    src: /screenshots/prod-dashboard.png
    alt: PanBox 概览界面
  actions:
    - theme: brand
      text: 快速开始 →
      link: /guide/getting-started

features:
  - icon: 🌐
    title: 多网盘支持
    details: 支持百度网盘、夸克网盘、UC网盘，轻松管理多个账号，统一界面操作
  - icon: ⏰
    title: 定时任务
    details: 灵活的 Cron 定时配置，自动执行转存任务，解放双手
  - icon: 📁
    title: 智能管理
    details: 自定义目标目录，支持正则过滤，精准转存你需要的文件
  - icon: 📊
    title: 状态追踪
    details: 详细的执行记录和日志，转存状态一目了然，问题快速定位
  - icon: 🔔
    title: 批次通知
    details: 支持 PushPlus 多渠道通知，5秒聚合窗口，文件树展示
  - icon: 🐳
    title: 一键部署
    details: Docker Compose 一键部署，5分钟快速上手，无需复杂配置
---

<!-- 自定义内容区域 -->

## 快速上手

### 下载安装

使用官方安装脚本，三步完成部署：

**第一步：下载安装脚本**

```bash
curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh -o install.sh
```

**第二步：赋予执行权限**

```bash
chmod +x install.sh
```

**第三步：执行安装**

```bash
sudo ./install.sh
```

**第四步：访问应用**

安装完成后，访问 `http://your-server-ip:1888` 开始使用！

::: tip 💡 提示
首次访问需要注册账号并激活 License（Free 套餐免费永久使用）
:::

---

## 支持的网盘

<div class="overflow-x-auto">

| 网盘 | 账号管理 | 扫码登录 | Cookie 登录 | 转存功能 |
|------|---------|---------|------------|---------|
| 百度网盘 | ✅ | ✅ | ✅ | ✅ |
| 夸克网盘 | ✅ | ✅ | ✅ | ✅ |
| UC网盘 | ✅ | ✅ | ✅ | ✅ |
| 阿里云盘 | 即将支持 | 即将支持 | 即将支持 | 即将支持 |
| 天翼云盘 | 即将支持 | 即将支持 | 即将支持 | 即将支持 |
| 迅雷云盘 | 即将支持 | 即将支持 | 即将支持 | 即将支持 |

</div>

::: details 🔍 详细说明
- **✅ 已支持**：功能完整可用
- **即将支持**：正在开发中，敬请期待
- **账号管理**：支持添加、编辑、删除网盘账号
- **扫码登录**：手机扫码即可快速登录，无需手动复制 Cookie
- **Cookie 登录**：支持手动粘贴 Cookie 登录，适合高级用户
- **转存功能**：完整支持分享链接解析和文件转存
:::

---

## 为什么选择 PanBox？

<div class="grid grid-cols-1 md:grid-cols-2 gap-6 my-8">

<div class="p-6 border rounded-lg">

### 🎯 解决痛点

- **手动转存太麻烦？** 自动定时帮你搞定
- **管理多个账号太混乱？** 统一管理，轻松切换
- **错过资源失效时间？** 定时检查，及时转存
- **通知消息太多？** 批次聚合，5秒合并推送

</div>

<div class="p-6 border rounded-lg">

### 💎 核心优势

- **开箱即用** Docker 一键部署，无需复杂配置
- **安全可靠** 本地部署，数据完全由你掌控
- **灵活强大** Cron 定时、正则过滤、多渠道通知
- **持续更新** 活跃维护，快速响应问题和需求

</div>

</div>

---

## License 套餐

选择适合你的套餐，解锁更多功能：

<div class="overflow-x-auto my-8">

| 套餐 | 最大账号数 | 每账号任务数 | 价格 | 有效期 |
|------|-----------|-------------|------|--------|
| **Free** | 1 | 3 | **免费** | 永久 |
| **Basic** | 1 | 20 | ¥199 | 1年 |
| **Pro** | 3 | 80 | ¥299 | 1年 |
| **Ultra** | 10 | 200 | ¥399 | 1年 |

</div>

::: tip 📌 说明
- 任务数限制是**按账号**计算，例如 Pro 套餐支持 3 个账号，每个账号最多创建 80 个任务
- Free 套餐适合个人轻度使用，无需付费即可永久使用核心功能
:::

---

## 联系方式

<div class="flex flex-col items-center gap-6 my-8">

<div class="text-center">

### 扫码添加微信

<div class="inline-block p-4 border-2 border-gray-300 rounded-lg">

<img src="/wechat-qrcode.png" alt="微信二维码" class="w-48" />

</div>

<p class="mt-4 text-sm text-gray-600">扫码添加微信，获取激活码、技术支持和产品更新</p>

</div>

</div>

---

<div class="text-center my-12">

**准备好了吗？** [立即开始使用 PanBox →](/guide/getting-started)

</div>
