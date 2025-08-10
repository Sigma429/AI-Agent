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
        <!-- 提醒区域 - 在应用卡片下方 -->
        <div class="notice-section">
          <div class="notice-card">
            <div class="notice-icon">⚠️</div>
            <div class="notice-content">
              <p class="notice-text">
                <span>因调用大模型花费费用较昂贵（本人系学生），如若无法正常对话，可以移至</span>
                <a href="https://github.com/Sigma429/AI-Agent" target="_blank" class="github-link">
                  <svg class="github-icon" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                  </svg>
                  GitHub
                </a>
                <span>观看运行效果视频</span>
              </p>
            </div>
          </div>
        </div>
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
  display: flex;
  flex-direction: column;
}

.header {
  text-align: center;
  padding: var(--spacing-xxl) 0;
  color: white;
  flex-shrink: 0;
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
  padding: 0;
  flex: 1;
  display: flex;
  align-items: flex-start;
}

.app-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: var(--spacing-xl);
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  margin-bottom: var(--spacing-xxl);
}

.app-card {
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
  height: 100%;
  display: flex;
  flex-direction: column;
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
  flex: 1;
}

.app-button {
  width: 100%;
  font-weight: 600;
  margin-top: auto;
}

.notice-section {
  background-color: #fff3cd;
  padding: 1px 0;
  border-radius: var(--border-radius-md);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  max-width: 830px;
  margin:  auto;
  margin-bottom: 20px;
  width: 71%;
}

.notice-card {
  display: flex;
  align-items: center;
  padding: var(--spacing-md);
  background-color: transparent;
  border-radius: var(--border-radius-md);
}

.notice-icon {
  font-size: 2rem;
  margin-right: var(--spacing-md);
  color: #856404;
  flex-shrink: 0;
}

.notice-content {
  flex-grow: 1;
}

.notice-text {
  font-size: var(--font-size-sm);
  color: #856404;
  line-height: 1.5;
  margin-bottom: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: flex;
  align-items: center;
  gap: 0.25rem;
  flex-wrap: nowrap;
}

.notice-text span {
  display: inline;
  vertical-align: baseline;
}

.github-link {
  color: #007bff;
  text-decoration: none;
  font-weight: 600;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  white-space: nowrap;
  vertical-align: baseline;
  line-height: 1;
}

.github-link:hover {
  text-decoration: underline;
}

.github-icon {
  width: 1.2rem;
  height: 1.2rem;
  vertical-align: baseline;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .app-grid {
    max-width: 900px;
    grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  }

  .notice-section {
    max-width: 700px;
  }
}

@media (max-width: 768px) {
  .header-title {
    font-size: var(--font-size-title);
  }

  .header-subtitle {
    font-size: var(--font-size-lg);
  }

  .main-content {
    padding: var(--spacing-lg) 0;
  }

  .app-grid {
    grid-template-columns: 1fr;
    gap: var(--spacing-lg);
    max-width: 500px;
    margin-bottom: var(--spacing-lg);
  }

  .notice-section {
    max-width: 500px;
    margin: 0 var(--spacing-md);
  }

  .notice-card {
    flex-direction: column;
    text-align: center;
  }

  .notice-icon {
    margin-right: 0;
    margin-bottom: var(--spacing-sm);
  }

  .notice-text {
    white-space: normal;
    text-align: center;
    flex-direction: column;
    gap: 0.5rem;
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
    padding: var(--spacing-md) 0;
  }

  .app-grid {
    gap: var(--spacing-md);
    margin: 0 var(--spacing-sm);
    margin-bottom: var(--spacing-md);
  }

  .notice-section {
    margin: 0 var(--spacing-sm);
    padding: var(--spacing-md) 0;
  }

  .notice-text {
    font-size: var(--font-size-xs);
    white-space: normal;
    flex-direction: column;
    gap: 0.25rem;
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

@media (max-width: 480px) {
  .app-grid {
    margin: 0 var(--spacing-xs);
    margin-bottom: var(--spacing-sm);
  }

  .notice-section {
    margin: 0 var(--spacing-xs);
    padding: var(--spacing-sm) 0;
  }

  .notice-card {
    padding: var(--spacing-sm);
  }

  .header-title {
    font-size: var(--font-size-xxl);
  }

  .header-subtitle {
    font-size: var(--font-size-md);
  }
}
</style>
