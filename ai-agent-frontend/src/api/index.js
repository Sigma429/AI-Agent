import axios from 'axios'

// 根据环境动态设置API基础URL
const getApiBaseUrl = () => {
  // 生产环境
  if (window.location.hostname === 'sigma429.online' || 
      window.location.hostname === '123.57.74.30') {
    return 'http://123.57.74.30:8123/api'
  }
  // 开发环境，使用相对路径让前端代理处理
  return '/api'
}

const API_BASE_URL = getApiBaseUrl()

console.log('API Base URL:', API_BASE_URL)
console.log('Current hostname:', window.location.hostname)

// 创建axios实例
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 生成聊天室ID
export const generateChatId = () => {
  return 'chat_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9)
}

// AI恋爱大师SSE连接
export const connectLoveAppSSE = (message, chatId, onMessage, onError, onComplete) => {
  const url = `${API_BASE_URL}/ai/love_app/chat/sse?message=${encodeURIComponent(message)}&chatId=${chatId}`
  
  console.log('连接SSE URL:', url)
  
  const eventSource = new EventSource(url)
  
  eventSource.onopen = (event) => {
    console.log('SSE连接已打开:', event)
  }
  
  eventSource.onmessage = (event) => {
    console.log('收到SSE消息:', event.data)
    if (event.data === '[DONE]') {
      console.log('SSE连接完成')
      onComplete && onComplete()
      eventSource.close()
    } else {
      onMessage && onMessage(event.data)
    }
  }
  
  eventSource.onerror = (error) => {
    console.log('SSE连接状态:', eventSource.readyState)
    
    // readyState: 0=连接中, 1=打开, 2=关闭
    if (eventSource.readyState === 2) {
      // 连接已关闭，这是正常结束
      console.log('SSE连接正常结束')
      onComplete && onComplete()
    } else {
      // 真正的错误
      console.error('SSE连接错误详情:', {
        error: error,
        readyState: eventSource.readyState,
        url: eventSource.url
      })
      onError && onError(error)
    }
    
    eventSource.close()
  }
  
  return eventSource
}

// AI超级智能体SSE连接
export const connectManusSSE = (message, onMessage, onError, onComplete) => {
  // 根据后端代码，这个接口可能返回SseEmitter而不是标准的SSE流
  // 让我们先尝试标准的SSE方式
  const url = `${API_BASE_URL}/ai/manus/chat?message=${encodeURIComponent(message)}`
  
  console.log('连接Manus SSE URL:', url)
  
  const eventSource = new EventSource(url)
  
  eventSource.onopen = (event) => {
    console.log('Manus SSE连接已打开:', event)
  }
  
  eventSource.onmessage = (event) => {
    console.log('收到Manus SSE消息:', event.data)
    if (event.data === '[DONE]') {
      console.log('Manus SSE连接完成')
      onComplete && onComplete()
      eventSource.close()
    } else {
      onMessage && onMessage(event.data)
    }
  }
  
  eventSource.onerror = (error) => {
    console.log('Manus SSE连接状态:', eventSource.readyState)
    
    // readyState: 0=连接中, 1=打开, 2=关闭
    if (eventSource.readyState === 2) {
      // 连接已关闭，这是正常结束
      console.log('Manus SSE连接正常结束')
      onComplete && onComplete()
    } else {
      // 真正的错误
      console.error('Manus SSE连接错误详情:', {
        error: error,
        readyState: eventSource.readyState,
        url: eventSource.url
      })
      
      // 如果SSE连接失败，尝试使用fetch方式
      console.log('尝试使用fetch方式连接Manus...')
      fetchManusResponse(message, onMessage, onError, onComplete)
    }
    
    eventSource.close()
  }
  
  return eventSource
}

// 备用方案：使用fetch方式连接Manus
const fetchManusResponse = async (message, onMessage, onError, onComplete) => {
  try {
    const url = `${API_BASE_URL}/ai/manus/chat?message=${encodeURIComponent(message)}`
    console.log('使用fetch连接Manus URL:', url)
    
    const response = await fetch(url)
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }
    
    const reader = response.body.getReader()
    const decoder = new TextDecoder()
    
    while (true) {
      const { done, value } = await reader.read()
      
      if (done) {
        console.log('Manus fetch连接完成')
        onComplete && onComplete()
        break
      }
      
      const chunk = decoder.decode(value, { stream: true })
      const lines = chunk.split('\n')
      
      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const data = line.slice(6)
          if (data === '[DONE]') {
            console.log('Manus fetch连接完成')
            onComplete && onComplete()
            return
          } else if (data.trim()) {
            console.log('收到Manus fetch数据:', data)
            onMessage && onMessage(data)
          }
        }
      }
    }
  } catch (error) {
    console.error('Manus fetch连接错误:', error)
    onError && onError(error)
  }
}

export default apiClient
