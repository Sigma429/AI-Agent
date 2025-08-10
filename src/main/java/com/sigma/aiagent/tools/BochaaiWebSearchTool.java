package com.sigma.aiagent.tools;

import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;

import java.util.HashMap;
import java.util.Map;

/**
 * Bochaai 网页搜索工具
 */
public class BochaaiWebSearchTool {

    private static final String SEARCH_API_URL = "https://api.bochaai.com/v1/web-search";

    private final String apiKey;

    public BochaaiWebSearchTool(String apiKey) {
        this.apiKey = apiKey;
    }

    @Tool(description = "Search for information from Bochaai Search Engine")
    public String searchWeb(
            @ToolParam(description = "Search query keyword") String query) {
        // 构建请求参数
        JSONObject payload = new JSONObject();
        payload.put("query", query);
        payload.put("freshness", "oneYear");
        payload.put("summary", true);
        payload.put("count", 8);

        // 设置请求头
        Map<String, String> headers = new HashMap<>();
        headers.put("Authorization", "Bearer " + apiKey);
        headers.put("Content-Type", "application/json");

        try {
            // 发送POST请求
            String response = HttpRequest.post(SEARCH_API_URL)
                    .headerMap(headers, true)
                    .body(payload.toString())
                    .execute()
                    .body();

            // 解析返回结果
            JSONObject jsonResponse = JSONUtil.parseObj(response);

            // 检查API返回状态
            if (jsonResponse.getInt("code", 0) != 200) {
                return "API request failed: " + jsonResponse.getStr("msg", "Unknown error");
            }

            JSONObject data = jsonResponse.getJSONObject("data");
            if (data == null) {
                return "No data found for: " + query;
            }

            // 获取网页搜索结果
            JSONObject webPages = data.getJSONObject("webPages");
            if (webPages == null || !webPages.containsKey("value")) {
                return "No web results found for: " + query;
            }

            JSONArray results = webPages.getJSONArray("value");
            if (results == null || results.isEmpty()) {
                return "No results found for: " + query;
            }

            // 构建结果字符串
            StringBuilder resultBuilder = new StringBuilder();
            resultBuilder.append("Search results for \"").append(query).append("\":\n\n");

            // 取前5条结果
            int limit = Math.min(results.size(), 5);
            for (int i = 0; i < limit; i++) {
                JSONObject result = results.getJSONObject(i);
                resultBuilder.append(i + 1).append(". ").append(result.getStr("name", "No title"))
                        .append("\nURL: ").append(result.getStr("url", "No URL"))
                        .append("\nSummary: ").append(result.getStr("summary", result.getStr("snippet", "No summary available")))
                        .append("\nSite: ").append(result.getStr("siteName", "Unknown site"))
                        .append("\nPublished: ").append(result.getStr("datePublished", "Unknown date"))
                        .append("\n\n");
            }

            // 如果有图片结果，可以添加图片信息
            JSONObject images = data.getJSONObject("images");
            if (images != null && images.containsKey("value")) {
                JSONArray imageResults = images.getJSONArray("value");
                if (imageResults != null && !imageResults.isEmpty()) {
                    resultBuilder.append("\nRelated images:\n");
                    int imageLimit = Math.min(imageResults.size(), 3);
                    for (int i = 0; i < imageLimit; i++) {
                        JSONObject image = imageResults.getJSONObject(i);
                        resultBuilder.append("- ").append(image.getStr("contentUrl", "")).append("\n");
                    }
                }
            }

            return resultBuilder.toString();
        } catch (Exception e) {
            return "Error searching Bochaai: " + e.getMessage();
        }
    }
}