package com.ruoyi.ai.config;

import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.vectorstore.SimpleVectorStore;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.File;

@Configuration
public class VectorStoreConfig {

    @Value("${smart-cs.vector-store.path:vectorstore.json}")
    private String vectorStorePath;

    @Bean
    public SimpleVectorStore vectorStore(EmbeddingModel embeddingModel) {
        SimpleVectorStore vectorStore = SimpleVectorStore.builder(embeddingModel).build();
        File vectorStoreFile = new File(vectorStorePath);
        if (vectorStoreFile.exists()) {
            vectorStore.load(vectorStoreFile);
        }
        return vectorStore;
    }
}
