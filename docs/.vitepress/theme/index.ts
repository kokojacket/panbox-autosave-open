import DefaultTheme from 'vitepress/theme'
import './style.css'
import { onMounted } from 'vue'

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    // 可以在这里注册全局组件
  },
  setup() {
    onMounted(() => {
      // Hero 图片轮播
      const screenshots = [
        '/screenshots/prod-dashboard.png',
        '/screenshots/prod-accounts.png',
        '/screenshots/prod-tasks.png',
        '/screenshots/prod-records.png'
      ]

      const imageContainer = document.querySelector('.VPHomeHero .image-container') as HTMLElement
      const img = document.querySelector('.VPHomeHero .image-container img') as HTMLImageElement

      if (!imageContainer || !img) return

      let currentIndex = 0
      let isZoomed = false
      let carouselTimer: number | null = null

      // 图片切换函数（带淡入淡出效果）
      const switchImage = () => {
        if (isZoomed) return // 放大状态下不切换

        currentIndex = (currentIndex + 1) % screenshots.length

        // 淡出效果
        img.style.opacity = '0'

        setTimeout(() => {
          img.src = screenshots[currentIndex]
          // 淡入效果
          img.style.opacity = '1'
        }, 300)
      }

      // 启动自动轮播（每 4 秒切换一次）
      const startCarousel = () => {
        if (carouselTimer) clearInterval(carouselTimer)
        carouselTimer = window.setInterval(switchImage, 4000)
      }

      // 停止自动轮播
      const stopCarousel = () => {
        if (carouselTimer) {
          clearInterval(carouselTimer)
          carouselTimer = null
        }
      }

      // 添加过渡效果
      img.style.transition = 'opacity 0.3s ease-in-out'

      // 启动轮播
      startCarousel()

      // 点击图片容器切换放大/缩小
      imageContainer.addEventListener('click', (e) => {
        isZoomed = !isZoomed
        imageContainer.classList.toggle('zoomed', isZoomed)

        if (isZoomed) {
          // 放大时停止轮播
          stopCarousel()

          // 放大状态：使用 setProperty + important 确保样式生效
          img.style.setProperty('position', 'fixed', 'important')
          img.style.setProperty('top', '50%', 'important')
          img.style.setProperty('left', '50%', 'important')
          img.style.setProperty('transform', 'translate(-50%, -50%)', 'important')
          img.style.setProperty('max-width', '90vw', 'important')
          img.style.setProperty('max-height', '90vh', 'important')
          img.style.setProperty('width', 'auto', 'important')
          img.style.setProperty('height', 'auto', 'important')
          img.style.setProperty('z-index', '9999', 'important')
          img.style.setProperty('cursor', 'zoom-out', 'important')
        } else {
          // 还原状态：移除所有内联样式
          img.style.removeProperty('position')
          img.style.removeProperty('top')
          img.style.removeProperty('left')
          img.style.removeProperty('transform')
          img.style.removeProperty('max-width')
          img.style.removeProperty('max-height')
          img.style.removeProperty('width')
          img.style.removeProperty('height')
          img.style.removeProperty('z-index')
          img.style.removeProperty('cursor')

          // 还原后重新启动轮播
          startCarousel()
        }

        // 阻止事件冒泡
        e.stopPropagation()
      })

      // 点击文档其他地方或按 ESC 退出放大
      const exitZoom = () => {
        if (isZoomed) {
          isZoomed = false
          imageContainer.classList.remove('zoomed')
          // 移除所有内联样式
          img.style.removeProperty('position')
          img.style.removeProperty('top')
          img.style.removeProperty('left')
          img.style.removeProperty('transform')
          img.style.removeProperty('max-width')
          img.style.removeProperty('max-height')
          img.style.removeProperty('width')
          img.style.removeProperty('height')
          img.style.removeProperty('z-index')
          img.style.removeProperty('cursor')

          // 还原后重新启动轮播
          startCarousel()
        }
      }

      document.addEventListener('click', (e) => {
        if (!imageContainer.contains(e.target as Node)) {
          exitZoom()
        }
      })

      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
          exitZoom()
        }
      })

      // 页面卸载时清理定时器
      window.addEventListener('beforeunload', () => {
        stopCarousel()
      })
    })
  }
}
