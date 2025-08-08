import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import Home from './views/Home.vue'
import LoveApp from './views/LoveApp.vue'
import ManusApp from './views/ManusApp.vue'

const routes = [
  { path: '/', component: Home },
  { path: '/love-app', component: LoveApp },
  { path: '/manus-app', component: ManusApp }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

const app = createApp(App)
app.use(router)
app.mount('#app')
