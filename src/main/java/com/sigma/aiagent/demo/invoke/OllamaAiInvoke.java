package com.sigma.aiagent.demo.invoke;

import jakarta.annotation.Resource;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * ClassName:OllamaAiInvoke
 * Package:com.sigma.aiagent.demo.invoke
 * Description:
 * @Author:14亿少女的梦-Sigma429
 * @Create:2025/08/02 - 11:01
 * @Version:v1.0
 */
// @Component
public class OllamaAiInvoke implements CommandLineRunner {

    @Resource
    private ChatModel ollamaChatModel;

    @Override
    public void run(String... args) throws Exception {
        AssistantMessage assistantMessage = ollamaChatModel.call(new Prompt("你好，你是谁呀"))
                .getResult()
                .getOutput();
        System.out.println(assistantMessage.getText());
    }
}