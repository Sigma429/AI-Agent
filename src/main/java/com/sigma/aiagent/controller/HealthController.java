package com.sigma.aiagent.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * ClassName:HealthController
 * Package:com.sigma.aiagent.controller
 * Description:
 * @Author:14亿少女的梦-Sigma429
 * @Create:2025/08/02 - 9:14
 * @Version:v1.0
 */
@RestController
@RequestMapping("/health")
public class HealthController {
    @GetMapping
    public String healthCheck() {
        return "ok";
    }

}
