package com.sigma.aiagent.multimodal;

import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversation;
import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversationParam;
import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversationResult;
import com.alibaba.dashscope.common.MultiModalMessage;
import com.alibaba.dashscope.common.Role;
import com.alibaba.dashscope.exception.ApiException;
import com.alibaba.dashscope.exception.NoApiKeyException;
import com.alibaba.dashscope.exception.UploadFileException;
import com.alibaba.dashscope.utils.JsonUtils;
import com.sigma.aiagent.demo.invoke.TestApiKey;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Arrays;
import java.util.Collections;

/**
 * ClassName:MultiModalTest
 * Package:com.sigma.aiagent.multimodal
 * Description:
 * @Author:14亿少女的梦-Sigma429
 * @Create:2025/08/03 - 17:11
 * @Version:v1.0
 */
@SpringBootTest(properties = {
        "spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration"
})
public class MultiModalTest {
    @Test
    public  void test() {
        try {
            simpleMultiModalConversationCall();
        } catch (ApiException | NoApiKeyException | UploadFileException e) {
            System.out.println(e.getMessage());
        }
        System.exit(0);
    }
    public static void simpleMultiModalConversationCall()
            throws ApiException, NoApiKeyException, UploadFileException {
        MultiModalConversation conv = new MultiModalConversation();
        MultiModalMessage userMessage = MultiModalMessage.builder().role(Role.USER.getValue())
                .content(Arrays.asList(
                        Collections.singletonMap("image", "https://dashscope.oss-cn-beijing.aliyuncs" +
                                ".com/images/dog_and_girl.jpeg"),
                        Collections.singletonMap("image", "https://dashscope.oss-cn-beijing.aliyuncs.com/images/tiger" +
                                ".png"),
                        Collections.singletonMap("image", "https://dashscope.oss-cn-beijing.aliyuncs" +
                                ".com/images/rabbit.png"),
                        Collections.singletonMap("text", "这些是什么?"))).build();
        MultiModalConversationParam param = MultiModalConversationParam.builder()
                // 若没有配置环境变量，请用百炼API Key将下行替换为：.apiKey("sk-xxx")
                .apiKey(TestApiKey.API_KEY)
                // 此处以qwen-vl-plus为例，可按需更换模型名称。模型列表：https://help.aliyun.com/zh/model-studio/getting-started/models
                .model("qwen-vl-plus")
                .message(userMessage)
                .build();
        MultiModalConversationResult result = conv.call(param);
        System.out.println(JsonUtils.toJson(result));
    }


}
