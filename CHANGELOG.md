# Changelog

## [Unreleased] - 2026-05-30

### Fixed
- `panbox-autosave.sh`：修复更新时 PostgreSQL 可能报 `postmaster.pid` 锁冲突、宿主机残留多个 postgres 进程的问题。更新流程由原先的直接 `up -d` 改为「先 `down --remove-orphans -t 60` 彻底停止旧容器、等待 PostgreSQL 释放数据目录锁，再 `up -d --remove-orphans` 启动」，消除新旧 postgres 同时打开同一份数据目录的抢锁窗口。

### Changed
- `panbox-autosave.sh`：安装流程的 `up -d` 加 `--remove-orphans`，清理遗留孤儿容器。
- `panbox-autosave.sh`：停止流程的 `down` 加 `--remove-orphans -t 60`，给 PostgreSQL 足够的优雅关闭时间，避免被默认 10 秒超时强杀后触发下次启动的 crash recovery。
- `panbox-autosave.sh`：`SCRIPT_VERSION` 升级到 `2026.05.30.1`，触发用户端强制自更新拉取上述修复。

## [Unreleased] - 2026-02-13

### Changed
- `panbox-autosave.sh`：下载配置文件新增重试机制（每个源最多重试 3 次），并采用 `--connect-timeout 3 --max-time 8`，失败后自动切换下一个下载源。
- `panbox-autosave.sh`：公网/IPv6 IP 探测请求增加 `--max-time 3` 与 `|| true`，避免在 `set -e` 下因网络探测失败导致脚本提前退出。
- `panbox-autosave.sh`：部署完成输出简化为“应用启动状态 + 最终访问路径（内网/外网）”，减少冗余信息与分割线。
