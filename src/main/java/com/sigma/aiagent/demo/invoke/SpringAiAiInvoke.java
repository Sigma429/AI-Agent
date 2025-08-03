package com.sigma.aiagent.demo.invoke;

import jakarta.annotation.Resource;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * ClassName:SpringAiAiInvoke
 * Package:com.sigma.aiagent.demo.invoke
 * Description:
 * @Author:14亿少女的梦-Sigma429
 * @Create:2025/08/02 - 10:24
 * @Version:v1.0
 */
// @Component
public class SpringAiAiInvoke implements CommandLineRunner {

    @Resource
    private ChatModel dashscopeChatModel;

    @Override
    public void run(String... args) throws Exception {
        AssistantMessage output = dashscopeChatModel.call(new Prompt("你好"))
                .getResult()
                .getOutput();
        System.out.println(output.getText());
    }
}
