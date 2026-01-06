import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'PanBox',
  description: '一站式多网盘自动转存系统 - 定时、批量、智能地将分享的网盘资源保存到你的网盘',
  lang: 'zh-CN',

  // GitHub Pages 部署配置
  // 如果使用自定义域名，设置为 '/'
  // 如果使用 username.github.io/repo，设置为 '/repo/'
  base: '/',

  // 清理 URL，移除 .html 后缀
  cleanUrls: true,

  // 忽略死链接检查（待页面完善后再启用检查）
  ignoreDeadLinks: true,

  // Head 配置
  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/logo.svg' }],
    ['meta', { name: 'theme-color', content: '#1890ff' }],
    ['meta', { name: 'keywords', content: '网盘转存,定时任务,百度网盘,夸克网盘,UC网盘,自动转存' }],
    ['meta', { property: 'og:title', content: 'PanBox - 网盘自动转存系统' }],
    ['meta', { property: 'og:description', content: '定时、批量、智能地将分享的网盘资源保存到你的网盘' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:image', content: '/og-image.png' }],
  ],

  // 主题配置
  themeConfig: {
    // Logo
    logo: '/logo.svg',
    siteTitle: 'PanBox',

    // 导航栏
    nav: [
      { text: '首页', link: '/' },
      { text: '快速开始', link: '/guide/getting-started' },
      {
        text: '功能',
        items: [
          { text: '账号管理', link: '/features/account-management' },
          { text: '任务管理', link: '/features/task-management' },
          { text: '执行记录', link: '/features/execution-records' },
          { text: '通知设置', link: '/features/notifications' },
        ]
      },
      { text: 'FAQ', link: '/faq' }
    ],

    // 侧边栏
    sidebar: {
      '/guide/': [
        {
          text: '使用指南',
          items: [
            { text: '介绍', link: '/guide/' },
            { text: '快速开始', link: '/guide/getting-started' },
            { text: '安装部署', link: '/guide/installation' },
            { text: '创建第一个任务', link: '/guide/first-task' },
          ]
        },
        {
          text: '高级配置',
          items: [
            { text: '环境变量', link: '/advanced/environment-variables' },
            { text: '数据备份', link: '/advanced/database-backup' },
            { text: '自定义域名', link: '/advanced/custom-domain' },
            { text: '反向代理', link: '/advanced/reverse-proxy' },
          ]
        }
      ],
      '/features/': [
        {
          text: '功能详解',
          items: [
            { text: '功能概览', link: '/features/' },
            { text: '账号管理', link: '/features/account-management' },
            { text: '任务管理', link: '/features/task-management' },
            { text: '执行记录', link: '/features/execution-records' },
            { text: '通知设置', link: '/features/notifications' },
            { text: 'License 管理', link: '/features/license' },
          ]
        }
      ],
    },

    // 社交链接（已隐藏）
    // socialLinks: [
    //   { icon: 'github', link: 'https://github.com/kokojacket/panbox-autosave' }
    // ],

    // 页脚
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2026-present PanBox Team'
    },

    // 搜索
    search: {
      provider: 'local',
      options: {
        locales: {
          root: {
            translations: {
              button: {
                buttonText: '搜索文档',
                buttonAriaLabel: '搜索文档'
              },
              modal: {
                noResultsText: '无法找到相关结果',
                resetButtonTitle: '清除查询条件',
                footer: {
                  selectText: '选择',
                  navigateText: '切换',
                  closeText: '关闭'
                }
              }
            }
          }
        }
      }
    },

    // 最后更新时间
    lastUpdated: {
      text: '最后更新于',
      formatOptions: {
        dateStyle: 'short',
        timeStyle: 'short'
      }
    },

    // 编辑链接
    editLink: {
      pattern: 'https://github.com/kokojacket/panbox-autosave-open/edit/main/docs/:path',
      text: '在 GitHub 上编辑此页'
    },

    // 文档页脚
    docFooter: {
      prev: '上一页',
      next: '下一页'
    },

    // 大纲配置
    outline: {
      label: '页面导航',
      level: [2, 3]
    },

    // 返回顶部
    returnToTopLabel: '返回顶部',

    // 侧边栏文字
    sidebarMenuLabel: '菜单',

    // 深色模式切换
    darkModeSwitchLabel: '主题',
    lightModeSwitchTitle: '切换到浅色模式',
    darkModeSwitchTitle: '切换到深色模式',
  },

  // Markdown 配置
  markdown: {
    lineNumbers: true,
    theme: {
      light: 'github-light',
      dark: 'github-dark'
    }
  },

  // Sitemap
  sitemap: {
    hostname: 'https://docs.panbox.online'  // 使用自定义域名，暂时配置，等实际域名绑定后生效
  }
})
