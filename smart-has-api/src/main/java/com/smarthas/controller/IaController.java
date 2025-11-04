package com.smarthas.controller;

import com.smarthas.service.LlmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/ia")
@CrossOrigin(origins = "*")
public class IaController {

    @Autowired
    private LlmService llmService;

    @PostMapping("/chat")
    public String chat(@RequestBody String pergunta) {
        return llmService.gerarResposta(pergunta);
    }

    @GetMapping("/relatorio")
    public String gerarRelatorio() {
        return llmService.gerarResposta("Gerar relatório da cidade");
    }

    @GetMapping("/sugestao")
    public String gerarSugestao() {
        return llmService.gerarResposta("Sugestão de otimização urbana");
    }
}
