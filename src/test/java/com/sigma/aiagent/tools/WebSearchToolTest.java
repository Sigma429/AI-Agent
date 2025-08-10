package com.sigma.aiagent.tools;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class WebSearchToolTest {

    @Value("${search-api.api-key}")
    private String searchApiKey;

    @Test
    void searchWeb() {
        BochaaiWebSearchTool bochaaiWebSearchTool = new BochaaiWebSearchTool(searchApiKey);
        String query = "我的另一半居住在上海静安区，请帮我找到 5 公里内合适的约会地点";
        String result = bochaaiWebSearchTool.searchWeb(query);
        System.out.println(result);
        Assertions.assertNotNull(result);
    }
}
