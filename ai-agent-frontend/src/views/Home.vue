<template>
  <div class="home">
    <header class="header">
      <div class="container">
        <h1 class="header-title">AI Agent 应用中心</h1>
        <p class="header-subtitle">欢迎使用我们的AI智能应用</p>
      </div>
    </header>
    
    <main class="main-content">
      <div class="container">
        <div class="app-grid">
          <div class="app-card card" @click="navigateToLoveApp">
            <div class="app-icon">💕</div>
            <h2 class="app-title">AI 恋爱大师</h2>
            <p class="app-description">
              AI 恋爱大师是一款基于大语言模型的智能应用，具备多轮对话记忆、知识库检索、工具调用和 SSE 流式传输能力，能够提供情感分析、关系建议和个性化互动体验。
            </p>
            <button class="btn btn-primary app-button">开始使用</button>
          </div>
          
          <div class="app-card card" @click="navigateToManusApp">
            <div class="app-icon">🤖</div>
            <h2 class="app-title">AI 超级智能体</h2>
            <p class="app-description">
              AI超级智能体以大语言模型为基础，整合多轮对话记忆、知识库检索和工具调用能力，采用SSE流式传输技术，通过CoT思维链、Agent Loop和ReAct等机制实现环境感知、推理决策和自主行动，完成既定目标。
            </p>
            <button class="btn btn-primary app-button">开始使用</button>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
export default {
  name: 'Home',
  methods: {
    navigateToLoveApp() {
      this.$router.push('/love-app')
    },
    navigateToManusApp() {
      this.$router.push('/manus-app')
    }
  }
}
</script>

<style scoped>
.home {
  min-height: 100vh;
  background: var(--primary-gradient);
}

.header {
  text-align: center;
  padding: var(--spacing-xxl) 0;
  color: white;
}

.header-title {
  font-size: var(--font-size-hero);
  margin-bottom: var(--spacing-sm);
  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
  font-weight: 700;
}

.header-subtitle {
  font-size: var(--font-size-xl);
  opacity: 0.9;
  font-weight: 300;
}

.main-content {
  padding: var(--spacing-xxl) 0;
}

.app-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: var(--spacing-xl);
  padding: var(--spacing-xxl) 0;
}

.app-card {
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}

.app-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: var(--primary-gradient);
}

.app-card:hover {
  transform: translateY(-10px);
}

.app-icon {
  font-size: 4rem;
  margin-bottom: var(--spacing-lg);
  text-align: center;
}

.app-title {
  font-size: var(--font-size-title);
  margin-bottom: var(--spacing-lg);
  color: #333;
  text-align: center;
  font-weight: 600;
}

.app-description {
  font-size: var(--font-size-md);
  line-height: 1.6;
  color: #666;
  margin-bottom: var(--spacing-xl);
  text-align: justify;
}

.app-button {
  width: 100%;
  font-weight: 600;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .header-title {
    font-size: var(--font-size-title);
  }
  
  .header-subtitle {
    font-size: var(--font-size-lg);
  }
  
  .app-grid {
    grid-template-columns: 1fr;
    gap: var(--spacing-lg);
  }
  
  .app-icon {
    font-size: 3rem;
  }
  
  .app-title {
    font-size: var(--font-size-xxl);
  }
}

@media (max-width: 576px) {
  .header {
    padding: var(--spacing-xl) 0;
  }
  
  .main-content {
    padding: var(--spacing-lg) 0;
  }
  
  .app-grid {
    gap: var(--spacing-md);
  }
  
  .app-icon {
    font-size: 2.5rem;
  }
  
  .app-title {
    font-size: var(--font-size-xl);
  }
  
  .app-description {
    font-size: var(--font-size-sm);
  }
}
</style>
