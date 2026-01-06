# 常见问题 FAQ

## 安装部署

### Q: 支持哪些操作系统？

**A:** PanBox 基于 Docker 部署，理论上支持所有能运行 Docker 的系统。推荐使用：
- Ubuntu 20.04+
- Debian 11+
- CentOS 8+
- 其他主流 Linux 发行版

### Q: 最低配置要求是什么？

**A:**
- CPU：1 核心
- 内存：512MB RAM（推荐 1GB+）
- 存储：1GB 可用空间
- Docker：20.10+
- Docker Compose：1.29+ 或 V2

### Q: 如何验证安装是否成功？

**A:**
```bash
# 检查容器运行状态
docker ps | grep panbox

# 预期输出：
# panbox-autosave   Up 2 minutes   0.0.0.0:1888->8000/tcp
# panbox-postgres   Up 2 minutes   5432/tcp

# 访问 Web 界面
curl http://localhost:1888
```

### Q: 为什么需要使用代理加速？

**A:** GitHub Raw 文件在国内访问速度较慢或可能被限制，使用代理镜像可以显著提升下载速度和成功率。安装脚本已内置 5 个备用源，会自动重试。

### Q: 端口 1888 被占用怎么办？

**A:** 安装脚本会自动检测并使用下一个可用端口（1888 → 1889 → 1890...）。如需手动修改，编辑 `/opt/panbox-autosave/docker-compose.yml`：

```yaml
ports:
  - "8080:8000"  # 改为 8080 或其他端口
```

然后重启服务：

```bash
cd /opt/panbox-autosave
docker-compose down
docker-compose up -d
```

## 网盘账号

### Q: 支持哪些网盘？

**A:** 目前支持：
- 百度网盘
- 夸克网盘
- UC网盘

### Q: 扫码登录和 Cookie 登录有什么区别？

**A:**

| 方式 | 优点 | 缺点 |
|------|------|------|
| **扫码登录** | 快捷方便，无需手动获取 Cookie | 需要手机在线 |
| **Cookie 登录** | 不需要手机，适合高级用户 | 需要手动获取 Cookie |

推荐使用扫码登录。

### Q: Cookie 多久会失效？

**A:** Cookie 有效期因网盘而异：
- **百度网盘**：约 30 天
- **夸克网盘**：约 30 天
- **UC网盘**：约 30 天

Cookie 失效后需重新登录。PanBox 会在任务执行时自动检测 Cookie 状态，失败时会发送通知提醒。

### Q: 如何获取 Cookie？

**A:** 详见 [账号管理 - Cookie 获取方法](/features/account-management#cookie-获取方法)

### Q: 可以添加多个相同网盘的账号吗？

**A:** 可以。PanBox 支持同时管理多个百度/夸克/UC 账号，账号数量受 License 套餐限制。

## 任务管理

### Q: Cron 表达式怎么写？

**A:** Cron 表达式格式为 `分 时 日 月 周`，例如：

```
0 2 * * *      # 每天凌晨 2 点
0 */6 * * *    # 每 6 小时
30 9 * * 1-5   # 工作日上午 9:30
0 0 1 * *      # 每月 1 号凌晨
```

在线工具：[Crontab Guru](https://crontab.guru/)

### Q: 正则过滤怎么写？

**A:** 文件名过滤支持 Python 正则表达式，例如：

```regex
.*\.mp4$       # 只转存 .mp4 文件
^2024.*        # 只转存以 2024 开头的文件
(第[0-9]+集)   # 只转存包含"第X集"的文件
```

在线测试：[Regex101](https://regex101.com/)

### Q: 任务执行失败怎么办？

**A:**
1. 检查执行记录中的详细日志
2. 确认网盘账号 Cookie 是否有效
3. 确认分享链接是否失效
4. 检查目标目录是否存在
5. 查看 [故障排查](/troubleshooting) 文档

### Q: 可以暂停任务吗？

**A:** 可以。在任务列表中找到对应任务，点击"编辑"，取消勾选"启用定时"即可暂停定时执行。如需彻底停止，可以删除任务。

### Q: 每个账号最多可以创建多少个任务？

**A:** 任务数量受 License 套餐限制（按账号计算）：
- **Free**：每账号 3 个任务
- **Basic**：每账号 20 个任务
- **Pro**：每账号 80 个任务
- **Ultra**：每账号 200 个任务

## License 管理

### Q: Free 套餐有什么限制？

**A:** Free 套餐功能完整，仅限制账号数和任务数：
- 最大账号数：1
- 每账号任务数：3
- 有效期：永久

适合个人轻度使用。

### Q: 如何升级套餐？

**A:**
1. 前往"设置 → License 管理"
2. 点击"兑换激活码"
3. 输入激活码
4. 点击"兑换"

### Q: 激活码在哪里获取？

**A:** 目前激活码通过官方渠道发放，具体获取方式请关注：
- GitHub Discussions
- 官方公告

### Q: License 到期后会怎样？

**A:**
- **付费套餐到期**：自动降级为 Free 套餐
- **Free 套餐**：永久有效，无到期时间

到期前会发送通知提醒。

## 通知推送

### Q: 支持哪些通知方式？

**A:** 目前支持 **PushPlus**，可推送到：
- 微信公众号
- PushPlus App

### Q: 如何获取 PushPlus Token？

**A:**
1. 访问 [PushPlus 官网](https://pushplus.plus)
2. 使用微信扫码登录
3. 复制 Token
4. 在 PanBox "设置 → 通知设置" 中粘贴

### Q: 什么是批次通知？

**A:** 为避免消息轰炸，PanBox 采用批次聚合通知：
- **5 秒时间窗口**：5 秒内的多次转存合并为一条消息
- **文件树展示**：清晰展示转存的文件结构
- **状态统计**：显示成功/失败/部分成功的汇总

示例：
```
📦 转存完成 (3 个任务)

✅ 任务 1: 电影合集
  └─ 2024/
      ├─ 电影A.mp4 (2.3GB)
      └─ 电影B.mp4 (1.8GB)

✅ 任务 2: 资源包
  ...

执行时间: 2026-01-06 14:30:25
```

### Q: 没有收到通知怎么办？

**A:**
1. 检查 PushPlus Token 是否正确
2. 在设置页面点击"发送测试消息"
3. 检查 PushPlus 官网是否有推送记录
4. 确认微信公众号没有屏蔽消息

## 数据安全

### Q: PanBox 会上传我的数据吗？

**A:** **不会**。PanBox 是本地部署的自托管应用，所有数据（账号信息、Cookie、任务配置）都存储在你的服务器上，不会上传到任何第三方服务器。

### Q: Cookie 是否加密存储？

**A:** 目前 PanBox 采用**明文存储** Cookie。由于是自托管应用，数据完全由你掌控，安全性取决于你的服务器安全策略。

建议：
- 配置防火墙限制访问
- 使用强密码
- 定期备份数据

### Q: 如何备份数据？

**A:** 详见 [数据备份](/advanced/database-backup)

## 更新与维护

### Q: 如何更新到最新版本？

**A:**
```bash
# 方法 1: 使用管理脚本
sudo bash install.sh
# 选择 "2) 更新 PanBox"

# 方法 2: 手动更新
cd /opt/panbox-autosave
docker pull kokojacket/panbox:latest
docker-compose up -d
```

### Q: 更新会丢失数据吗？

**A:** **不会**。更新只会替换容器镜像，数据库和配置文件都保留在 `/opt/panbox-autosave/` 目录中。

### Q: 如何查看日志？

**A:**
```bash
cd /opt/panbox-autosave

# 查看应用日志
docker-compose logs -f panbox-autosave

# 查看数据库日志
docker-compose logs -f postgres
```

### Q: 如何卸载 PanBox？

**A:**
```bash
# 停止并删除容器
cd /opt/panbox-autosave
docker-compose down -v

# 删除数据目录（可选，会删除所有数据）
sudo rm -rf /opt/panbox-autosave

# 删除 Docker 镜像（可选）
docker rmi kokojacket/panbox:latest
docker rmi postgres:16-alpine
```

## 其他问题

### Q: 支持跨网盘转存吗？

**A:** 目前**不支持**跨网盘转存（例如从百度网盘转存到夸克网盘）。PanBox 仅支持同网盘内的分享链接转存。

### Q: 可以在 Windows/macOS 上运行吗？

**A:** 可以，但推荐使用 Linux。如果使用 Windows/macOS：
- **Windows**：安装 Docker Desktop for Windows
- **macOS**：安装 Docker Desktop for Mac

然后使用 `docker-compose.yml` 手动启动服务。

### Q: 遇到问题如何寻求帮助？

**A:**
1. 查看 [故障排查](/troubleshooting) 文档
2. 搜索 [GitHub Issues](https://github.com/kokojacket/panbox-autosave/issues)
3. 前往 [GitHub Discussions](https://github.com/kokojacket/panbox-autosave/discussions) 提问
4. 提交新的 [Issue](https://github.com/kokojacket/panbox-autosave/issues/new)

---

**没有找到你的问题？** 前往 [GitHub Discussions](https://github.com/kokojacket/panbox-autosave/discussions) 提问，我们会尽快回复！
