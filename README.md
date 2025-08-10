# AI 超级智能体项目

该项目系本人学习AI应用开发所创项目，参考<a href="https://github.com/liyupi" target="_blank">liyupi (程序员鱼皮)</a>的智能体项目<a href="https://github.com/liyupi/yu-ai-agent" target="_blank">yu-ai-agent</a>，在此基础上做了部分优化处理

上线地址为<a href="http://sigma429.online/" target="_blank">AI Agent 应用平台</a>

因调用大模型花费费用较昂贵（本人系学生），如若无法正常对话，可以观看下列演示视频

<a href="https://www.bilibili.com/video/BV12BbKzQEuz/?vd_source=c96a3b535582d17a0b479355f0317d27" target="_blank">AI恋爱大师对话效果展示</a>

<a href="https://www.bilibili.com/video/BV14BbKzXEvx/?vd_source=c96a3b535582d17a0b479355f0317d27" target="_blank">AI超级智能体对话效果展示</a>

## 项目功能梳理

项目中，我们将开发一个 AI 恋爱大师应用、一个拥有自主规划能力的超级智能体，以及一系列工具和 MCP 服务。

具体需求如下：

- AI 恋爱大师应用：用户在恋爱过程中难免遇到各种难题，让 AI 为用户提供贴心情感指导。支持多轮对话、对话记忆持久化、RAG 知识库检索、工具调用、MCP 服务调用。
- AI 超级智能体：可以根据用户的需求，自主推理和行动，直到完成目标。
- 提供给 AI 的工具：包括联网搜索、文件操作、网页抓取、资源下载、终端操作、PDF 生成。
- AI MCP 服务：可以从特定网站搜索图片。


## 用哪些技术？

项目以 Spring AI 开发框架实战为核心，涉及到多种主流 AI 客户端和工具库的运用。

- Java 21 + Spring Boot 3 框架
- ⭐️ Spring AI + LangChain4j
- ⭐️ RAG 知识库
- ⭐️ PGvector 向量数据库
- ⭐ Tool Calling 工具调用 
- ⭐️ MCP 模型上下文协议
- ⭐️ ReAct Agent 智能体构建
- ⭐️ Serverless 计算服务
- ⭐️ AI 大模型开发平台百炼
- ⭐️ Cursor AI 代码生成
- ⭐️ SSE 异步推送
- 第三方接口：如 SearchAPI / Pexels API
- Ollama 大模型部署
- 工具库如：Kryo 高性能序列化 + Jsoup 网页抓取 + iText PDF 生成 + Knife4j 接口文档

项目架构设计图：

![AI 智能体架构图](https://pic.yupi.icu/1/AI%E6%99%BA%E8%83%BD%E4%BD%93%E6%9E%B6%E6%9E%84%E5%9B%BE.png)



