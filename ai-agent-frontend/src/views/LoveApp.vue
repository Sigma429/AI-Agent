<template>
  <div class="chat-container">
    <!-- 头部 -->
    <header class="chat-header">
      <button class="btn back-button" @click="goBack">
        <span>←</span> 返回主页
      </button>
      <h1 class="chat-title">AI 恋爱大师 💕</h1>
      <div class="chat-info">
        <span>聊天室ID: {{ chatId }}</span>
      </div>
    </header>

    <!-- 聊天记录区域 -->
    <div class="chat-messages" ref="messagesContainer">
      <div 
        v-for="(message, index) in messages" 
        :key="index"
        :class="['message', message.type]"
      >
        <div class="message-content">
          <div class="avatar" :class="message.type === 'user' ? 'avatar-user' : 'avatar-ai-love'">
            {{ message.type === 'user' ? '👤' : '💕' }}
          </div>
          <div class="message-bubble">
            <div class="message-text" v-html="formatMessage(message.content)"></div>
            <div class="message-time">{{ formatTime(message.timestamp) }}</div>
          </div>
        </div>
      </div>
      
      <!-- 加载状态 -->
      <div v-if="isLoading" class="message ai">
        <div class="message-content">
          <div class="avatar avatar-ai-love">💕</div>
          <div class="message-bubble">
            <div class="typing-indicator">
              <span></span>
              <span></span>
              <span></span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 输入区域 -->
    <div class="chat-input-container">
      <div class="input-wrapper">
        <textarea
          v-model="inputMessage"
          @keydown.enter.prevent="sendMessage"
          placeholder="输入您的问题..."
          class="chat-input input"
          :disabled="isLoading"
          ref="inputRef"
        ></textarea>
        <button 
          @click="sendMessage" 
          class="btn btn-primary send-button"
          :disabled="!inputMessage.trim() || isLoading"
        >
          发送
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { connectLoveAppSSE, generateChatId } from '../api/index.js'

export default {
  name: 'LoveApp',
  data() {
    return {
      chatId: '',
      messages: [],
      inputMessage: '',
      isLoading: false,
      currentEventSource: null
    }
  },
  mounted() {
    this.chatId = generateChatId()
    this.addWelcomeMessage()
  },
  methods: {
    goBack() {
      this.$router.push('/')
    },
    
    addWelcomeMessage() {
      this.messages.push({
        type: 'ai',
        content: '你好！我是AI恋爱大师，很高兴为您服务。我可以帮助您分析情感问题、提供关系建议，或者与您进行有趣的对话。请告诉我您想聊什么吧！',
        timestamp: new Date()
      })
    },
    
    async sendMessage() {
      if (!this.inputMessage.trim() || this.isLoading) return
      
      const userMessage = this.inputMessage.trim()
      this.inputMessage = ''
      
      console.log('发送消息:', userMessage)
      console.log('聊天室ID:', this.chatId)
      
      // 添加用户消息
      this.messages.push({
        type: 'user',
        content: userMessage,
        timestamp: new Date()
      })
      
      this.isLoading = true
      this.scrollToBottom()
      
      try {
        // 关闭之前的连接
        if (this.currentEventSource) {
          console.log('关闭之前的SSE连接')
          this.currentEventSource.close()
        }
        
        let aiResponse = ''
        
        // 创建AI消息占位符
        const aiMessageIndex = this.messages.length
        this.messages.push({
          type: 'ai',
          content: '',
          timestamp: new Date()
        })
        
        console.log('开始连接SSE...')
        
        // 连接SSE
        this.currentEventSource = connectLoveAppSSE(
          userMessage,
          this.chatId,
          (data) => {
            console.log('收到SSE数据:', data)
            aiResponse += data
            this.messages[aiMessageIndex].content = aiResponse
            this.scrollToBottom()
          },
          (error) => {
            console.error('SSE连接错误:', error)
            console.error('错误详情:', {
              message: error.message,
              type: error.type,
              target: error.target
            })
            
            // 只有在真正错误时才显示错误信息
            if (error && error.message) {
              this.messages[aiMessageIndex].content = '抱歉，连接出现错误，请重试。错误信息：' + error.message
            }
            this.isLoading = false
          },
          () => {
            console.log('SSE连接完成')
            this.isLoading = false
            this.currentEventSource = null
          }
        )
        
      } catch (error) {
        console.error('发送消息错误:', error)
        this.messages.push({
          type: 'ai',
          content: '抱歉，发送消息时出现错误，请重试。错误信息：' + (error.message || '未知错误'),
          timestamp: new Date()
        })
        this.isLoading = false
      }
    },
    
    scrollToBottom() {
      this.$nextTick(() => {
        const container = this.$refs.messagesContainer
        if (container) {
          container.scrollTop = container.scrollHeight
        }
      })
    },
    
    formatMessage(content) {
      // 简单的换行处理
      return content.replace(/\n/g, '<br>')
    },
    
    formatTime(timestamp) {
      return new Date(timestamp).toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit'
      })
    }
  },
  
  beforeUnmount() {
    if (this.currentEventSource) {
      this.currentEventSource.close()
    }
  }
}
</script>

<style scoped>
.chat-container {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: var(--love-gradient);
}

.chat-header {
  background: rgba(255, 255, 255, 0.95);
  padding: var(--spacing-md) var(--spacing-lg);
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  backdrop-filter: blur(10px);
}

.back-button {
  background: none;
  border: none;
  color: #666;
  font-size: var(--font-size-md);
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--border-radius-sm);
  transition: all 0.3s ease;
}

.back-button:hover {
  background: rgba(102, 126, 234, 0.1);
  color: #667eea;
}

.chat-title {
  color: #333;
  font-size: var(--font-size-xxl);
  margin: 0;
  font-weight: 600;
}

.chat-info {
  font-size: var(--font-size-sm);
  color: #666;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: var(--spacing-lg);
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
}

.message {
  display: flex;
  margin-bottom: var(--spacing-md);
}

.message.user {
  justify-content: flex-end;
}

.message.ai {
  justify-content: flex-start;
}

.message-content {
  display: flex;
  align-items: flex-start;
  gap: var(--spacing-sm);
  max-width: 70%;
}

.message.user .message-content {
  flex-direction: row-reverse;
}

.message-bubble {
  background: rgba(255, 255, 255, 0.95);
  padding: var(--spacing-md) var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  backdrop-filter: blur(10px);
  max-width: 100%;
}

.message.user .message-bubble {
  background: var(--primary-gradient);
  color: white;
}

.message-text {
  line-height: 1.5;
  word-wrap: break-word;
}

.message-time {
  font-size: var(--font-size-xs);
  opacity: 0.7;
  margin-top: var(--spacing-xs);
}

.chat-input-container {
  background: rgba(255, 255, 255, 0.95);
  padding: var(--spacing-lg);
  backdrop-filter: blur(10px);
  border-top: 1px solid rgba(0,0,0,0.1);
}

.input-wrapper {
  display: flex;
  gap: var(--spacing-sm);
  align-items: flex-end;
}

.chat-input {
  flex: 1;
  resize: none;
  min-height: 50px;
  max-height: 120px;
}

.chat-input:disabled {
  background: #f5f5f5;
  cursor: not-allowed;
}

.send-button {
  white-space: nowrap;
}

.typing-indicator {
  display: flex;
  gap: 4px;
  align-items: center;
}

.typing-indicator span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #999;
  animation: typing 1.4s infinite ease-in-out;
}

.typing-indicator span:nth-child(1) { animation-delay: -0.32s; }
.typing-indicator span:nth-child(2) { animation-delay: -0.16s; }

/* 响应式设计 */
@media (max-width: 768px) {
  .chat-header {
    padding: var(--spacing-sm) var(--spacing-md);
  }
  
  .chat-title {
    font-size: var(--font-size-xl);
  }
  
  .chat-info {
    display: none;
  }
  
  .chat-messages {
    padding: var(--spacing-md);
  }
  
  .message-content {
    max-width: 85%;
  }
  
  .chat-input-container {
    padding: var(--spacing-md);
  }
}

@media (max-width: 576px) {
  .chat-header {
    padding: var(--spacing-xs) var(--spacing-sm);
  }
  
  .chat-title {
    font-size: var(--font-size-lg);
  }
  
  .chat-messages {
    padding: var(--spacing-sm);
  }
  
  .message-content {
    max-width: 90%;
  }
  
  .message-bubble {
    padding: var(--spacing-sm) var(--spacing-md);
  }
  
  .chat-input-container {
    padding: var(--spacing-sm);
  }
  
  .input-wrapper {
    gap: var(--spacing-xs);
  }
}
</style>

    padding: var(--spacing-sm);