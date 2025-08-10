import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'

export default defineConfig({
    plugins: [vue()],
    server: {
        port: 3000,
        host: '0.0.0.0', // 允许外部访问
        open: true,
        cors: true, // 启用CORS
        hmr: {
            host: 'localhost' // HMR主机设置
        },
        // 添加代理配置，让前端代理后端请求
        proxy: {
            '/api': {
                target: 'http://localhost:8123',
                changeOrigin: true,
                secure: false,
                rewrite: (path) => path.replace(/^\/api/, '/api')
            }
        }
    },
    // 生产环境配置
    build: {
        outDir: 'dist',
        assetsDir: 'assets',
        sourcemap: false,
        // 配置基础路径
        base: '/',
        rollupOptions: {
            output: {
                manualChunks: undefined
            }
        }
    }
})
