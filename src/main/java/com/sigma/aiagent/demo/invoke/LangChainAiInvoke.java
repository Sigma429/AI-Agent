package com.sigma.aiagent.demo.invoke;

import dev.langchain4j.community.model.dashscope.QwenChatModel;
import dev.langchain4j.model.chat.ChatLanguageModel;

/**
 * ClassName:LangChainAiInvoke
 * Package:com.sigma.aiagent.demo.invoke
 * Description:
 * @Author:14亿少女的梦-Sigma429
 * @Create:2025/08/02 - 10:31
 * @Version:v1.0
 */
public class LangChainAiInvoke {
    public static void main(String[] args) {
        ChatLanguageModel qwenChatModel = QwenChatModel.builder()
                .apiKey(TestApiKey.API_KEY)
                .modelName("qwen-max")
                .build();
        String answer = qwenChatModel.chat("你好");
        System.out.println(answer);
    }
}
