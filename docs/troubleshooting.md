# 故障排查

遇到问题？本文档提供常见问题的排查和解决方法。

## 安装问题

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

<div class="tip custom-block">
<p class="custom-block-title">方法 1：检查网络连接</p>

```bash
# 测试网络连通性
curl -I https://www.github.com
ping 8.8.8.8

# 如果是防火墙问题，临时关闭测试
sudo ufw disable  # Ubuntu/Debian
sudo systemctl stop firewalld  # CentOS/RHEL
```
</div>

<div class="tip custom-block">
<p class="custom-block-title">方法 2：手动下载配置文件</p>

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
</div>

<div class="tip custom-block">
<p class="custom-block-title">方法 3：使用代理</p>

```bash
# 通过代理下载脚本
export https_proxy=http://your-proxy:port
curl -fsSL https://raw.githubusercontent.com/kokojacket/panbox-autosave-open/main/install.sh | sudo bash
```
</div>

### 2. Docker 未安装

**症状：**
```
command not found: docker
```

**解决方法：**

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

### 3. 无法获取公网 IP

**症状：**
```
访问地址：
  公网 IP: 无法获取（纯内网环境）
  内网: http://192.168.1.100:1888
```

**原因：** 服务器在纯内网环境或防火墙阻止了 IP 查询服务

**解决方法：**

1. **手动查询公网 IP：**

   ```bash
   # IPv4
   curl -4 https://api.ipify.org
   curl -4 https://ifconfig.me
   curl -4 https://icanhazip.com

   # IPv6
   curl -6 https://api64.ipify.org
   curl -6 https://icanhazip.com
   ```

2. **使用内网 IP 访问：**

   如果是纯内网环境，使用脚本提供的内网 IP 访问即可。

## 运行问题

### 1. 容器无法启动

**症状：**
```bash
docker ps
# 没有看到 panbox-autosave 容器
```

**排查步骤：**

<div class="warning custom-block">
<p class="custom-block-title">⚠️ 第一步：查看日志</p>

```bash
cd /opt/panbox-autosave
docker-compose logs panbox-autosave
```

根据日志内容定位问题：
- 数据库连接失败 → 检查数据库容器状态
- 端口被占用 → 修改 docker-compose.yml 中的端口映射
- 权限问题 → 检查 /opt/panbox-autosave 目录权限
</div>

**常见错误及解决：**

<div class="details custom-block">
<summary>错误 1：数据库未就绪</summary>

```
Error: could not connect to database
```

**解决：** 等待数据库容器完全启动（约 10-30 秒），然后重启应用容器

```bash
docker-compose restart panbox-autosave
```
</div>

<div class="details custom-block">
<summary>错误 2：端口冲突</summary>

```
Error: Bind for 0.0.0.0:1888 failed: port is already allocated
```

**解决：** 修改 docker-compose.yml 端口映射

```yaml
ports:
  - "8080:8000"  # 改为 8080 或其他未占用端口
```

然后重启：

```bash
docker-compose down
docker-compose up -d
```
</div>

### 2. 无法访问 Web 界面

**症状：** 浏览器访问 `http://server-ip:1888` 显示"无法连接"

**排查步骤：**

<div class="tip custom-block">
<p class="custom-block-title">步骤 1：检查容器运行状态</p>

```bash
docker ps | grep panbox
```

预期输出：
```
panbox-autosave   Up 2 minutes   0.0.0.0:1888->8000/tcp
```

如果没有输出，说明容器未运行，查看日志排查原因。
</div>

<div class="tip custom-block">
<p class="custom-block-title">步骤 2：检查端口是否监听</p>

```bash
# 在服务器上测试本地访问
curl http://localhost:1888

# 检查端口监听
netstat -tlnp | grep 1888
# 或
ss -tlnp | grep 1888
```
</div>

<div class="tip custom-block">
<p class="custom-block-title">步骤 3：检查防火墙</p>

```bash
# Ubuntu/Debian
sudo ufw status
sudo ufw allow 1888

# CentOS/RHEL
sudo firewall-cmd --state
sudo firewall-cmd --permanent --add-port=1888/tcp
sudo firewall-cmd --reload
```
</div>

### 3. 数据库连接失败

**症状：**
```
Error: FATAL: password authentication failed for user "panbox-autosave"
```

**解决方法：**

<div class="danger custom-block">
<p class="custom-block-title">⚠️ 数据库密码不匹配</p>

检查 `docker-compose.yml` 中的数据库配置，确保以下环境变量一致：

```yaml
postgres:
  environment:
    POSTGRES_PASSWORD: "panbox-autosave"  # 数据库密码

panbox-autosave:
  environment:
    DB_PASSWORD: "panbox-autosave"  # 应用连接密码
```

修改后重启服务：

```bash
docker-compose down
docker-compose up -d
```
</div>

## 功能问题

### 1. 扫码登录二维码不显示

**可能原因：**
- 网络问题，无法连接网盘 API
- 网盘服务暂时不可用

**解决方法：**

1. 刷新页面重试
2. 切换到 Cookie 登录方式
3. 查看浏览器控制台是否有报错
4. 检查服务器日志

### 2. Cookie 登录失败

**症状：**
```
Cookie 验证失败
```

**原因：**
- Cookie 格式不正确
- Cookie 已过期
- 复制时丢失部分内容

**解决方法：**

1. **确认 Cookie 格式完整：**

   不同网盘需要的 Cookie 字段：

   - **百度网盘**：至少包含 `BDUSS` 和 `STOKEN`
   - **夸克网盘**：至少包含 `__puus`、`__kp`、`__kps`
   - **UC网盘**：至少包含 `__pus`、`__kp`、`__kps`

2. **重新获取 Cookie：**

   参考 [账号管理 - Cookie 获取方法](/features/account-management#cookie-获取方法)

3. **使用扫码登录代替**

### 3. 任务执行失败

**症状：** 执行记录显示"失败"状态

**排查步骤：**

<div class="tip custom-block">
<p class="custom-block-title">步骤 1：查看详细日志</p>

前往"执行记录"页面，点击失败的记录查看详细日志，根据错误信息定位问题。
</div>

**常见错误：**

| 错误信息 | 原因 | 解决方法 |
|---------|------|---------|
| `Cookie 失效` | 网盘 Cookie 已过期 | 重新登录账号 |
| `分享链接已失效` | 分享链接过期或被取消 | 更新分享链接 |
| `目标目录不存在` | 指定的目标目录不存在 | 创建目录或修改任务配置 |
| `网络超时` | 网络连接问题 | 检查服务器网络，重试任务 |

### 4. 定时任务未执行

**可能原因：**
- Cron 表达式配置错误
- 任务已禁用
- 调度器服务异常

**解决方法：**

1. **验证 Cron 表达式：**

   使用 [Crontab Guru](https://crontab.guru/) 验证表达式是否正确

2. **检查任务状态：**

   确认任务的"启用定时"开关已打开

3. **查看服务日志：**

   ```bash
   docker-compose logs -f panbox-autosave | grep scheduler
   ```

4. **手动触发测试：**

   点击"立即执行"按钮测试任务是否正常

### 5. 通知未收到

**排查步骤：**

<div class="tip custom-block">
<p class="custom-block-title">步骤 1：测试 PushPlus 配置</p>

在"设置 → 通知设置"页面，点击"发送测试消息"按钮。

如果测试消息也收不到，说明 PushPlus 配置有问题。
</div>

<div class="tip custom-block">
<p class="custom-block-title">步骤 2：检查 Token 是否正确</p>

1. 登录 [PushPlus 官网](https://pushplus.plus)
2. 复制最新的 Token
3. 在 PanBox 中重新配置
</div>

<div class="tip custom-block">
<p class="custom-block-title">步骤 3：检查推送记录</p>

在 PushPlus 官网查看是否有推送记录：
- 如果有记录但未收到，检查微信公众号是否屏蔽消息
- 如果没有记录，说明 PanBox 未成功调用 PushPlus API，查看服务日志
</div>

## 性能问题

### 1. 转存速度慢

**原因：**
- 服务器网络带宽限制
- 网盘 API 限流
- 大文件较多

**优化建议：**

- 选择网络带宽较大的服务器
- 避免同时执行大量任务
- 大文件转存可能需要较长时间，这是正常现象

### 2. 内存占用高

**原因：**
- 数据库缓存较多
- 长时间运行未重启

**解决方法：**

```bash
# 重启服务释放内存
docker-compose restart

# 查看内存使用情况
docker stats
```

## 数据问题

### 1. 数据丢失

**预防措施：**

::: danger ⚠️ 重要
定期备份数据库，详见 [数据备份](/advanced/database-backup)
:::

```bash
# 备份数据库
docker exec panbox-autosave-postgres pg_dump -U panbox-autosave panbox-autosave > backup-$(date +%Y%m%d).sql
```

### 2. 数据恢复

**恢复步骤：**

```bash
# 停止应用（保留数据库）
cd /opt/panbox-autosave
docker-compose stop panbox-autosave

# 恢复数据
cat backup.sql | docker exec -i panbox-autosave-postgres psql -U panbox-autosave panbox-autosave

# 重启应用
docker-compose start panbox-autosave
```

## 升级问题

### 1. 更新后无法启动

**可能原因：**
- 数据库迁移失败
- 配置文件不兼容
- Docker 镜像损坏

**解决方法：**

<div class="warning custom-block">
<p class="custom-block-title">⚠️ 回滚到旧版本</p>

```bash
cd /opt/panbox-autosave

# 停止服务
docker-compose down

# 拉取指定版本（替换为之前正常工作的版本号）
docker pull kokojacket/panbox:v1.0.0

# 修改 docker-compose.yml 指定版本
# image: kokojacket/panbox:v1.0.0

# 启动服务
docker-compose up -d
```
</div>

### 2. 数据库迁移失败

**症状：**
```
Error: database migration failed
```

**解决方法：**

1. **查看迁移日志：**

   ```bash
   docker-compose logs panbox-autosave | grep migration
   ```

2. **联系技术支持：**

   如果无法自行解决，请在 [GitHub Issues](https://github.com/kokojacket/panbox-autosave/issues) 提交问题，并附上：
   - 错误日志
   - 当前版本号
   - 升级前版本号

## 获取帮助

如果以上方法都无法解决问题，请按以下方式寻求帮助：

1. **收集信息：**

   ```bash
   # 导出服务日志
   docker-compose logs > panbox-logs.txt

   # 查看系统信息
   uname -a
   docker --version
   docker-compose --version
   ```

2. **提交 Issue：**

   前往 [GitHub Issues](https://github.com/kokojacket/panbox-autosave/issues/new) 提交问题，并提供：
   - 问题描述
   - 复现步骤
   - 错误日志
   - 系统信息

3. **加入社区：**

   - [GitHub Discussions](https://github.com/kokojacket/panbox-autosave/discussions)
   - 我们会尽快回复并提供帮助

---

**问题解决了吗？** 给我们一个 ⭐ [Star](https://github.com/kokojacket/panbox-autosave) 支持一下！
