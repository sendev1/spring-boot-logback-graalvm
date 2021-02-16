package com.example.logback;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(proxyBeanMethods = false)
public class LogbackApplication {

	private static final Logger logger = LoggerFactory.getLogger(LogbackApplication.class);

	public static void main(String[] args) {
		logger.error("START This is NOT an error message......");
		SpringApplication.run(LogbackApplication.class, args);
		logger.error("AFTER INIT This is NOT an error message......");
	}

}
