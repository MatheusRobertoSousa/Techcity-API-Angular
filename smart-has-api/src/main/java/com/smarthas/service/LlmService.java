package com.smarthas.service;

import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.Random;

@Service
public class LlmService {

    private static final String[] OCORRENCIAS = {
            "Ocorrência de queda de energia registrada no bairro Centro.",
            "Trânsito intenso nas avenidas principais devido a obras de manutenção.",
            "Equipe de limpeza atuando na região Norte desde as 6h da manhã.",
            "Sensor de qualidade do ar indica índice moderado de poluição."
    };

    private static final String[] SUGESTOES = {
            "Considere otimizar o consumo de energia pública nas praças durante o período noturno.",
            "Recomenda-se aumentar a frequência de coleta de lixo no bairro Sul.",
            "Os semáforos inteligentes podem ser reconfigurados para reduzir o tempo médio de espera em 18%.",
            "Os sensores climáticos indicam chance de chuva nas próximas horas. Ative alertas preventivos."
    };

    public String gerarResposta(String prompt) {
        prompt = prompt.toLowerCase();

        if (prompt.contains("ocorrencia") && prompt.contains("mes")) {
            int qtd = new Random().nextInt(10) + 5;
            return "Neste mês, foram registradas " + qtd + " ocorrências na cidade, incluindo energia, trânsito e segurança pública.";
        }
        else if (prompt.contains("ocorrencia") && prompt.contains("critica")) {
            return "Sim, existe uma ocorrência crítica ativa: falha no fornecimento de energia no bairro Central. Equipes já foram acionadas.";
        }
        else if (prompt.contains("cidade") || prompt.contains("status")) {
            return "A cidade está operando normalmente. Nível de ruído urbano dentro dos padrões e sem alertas de poluição no momento.";
        }
        else if (prompt.contains("clima") || prompt.contains("tempo")) {
            return "Atualmente, o clima é parcialmente nublado com temperatura média de 25°C. Sem alertas meteorológicos.";
        }
        else if (prompt.contains("relatorio")) {
            return gerarRelatorioSimulado();
        }
        else {
            return getSugestaoAleatoria();
        }
    }

    private String gerarRelatorioSimulado() {
        LocalDate hoje = LocalDate.now();
        return String.format(
                "📊 Relatório Tech City - %s%n%n" +
                        "• Ocorrências resolvidas esta semana: %d%n" +
                        "• Ocorrências críticas em andamento: %d%n" +
                        "• Consumo médio de energia pública: %.2f MWh%n" +
                        "• Nível de satisfação cidadã: %d%%%n%n" +
                        "Resumo: o sistema da cidade está operando de forma estável, com pequenas ocorrências em análise.",
                hoje,
                new Random().nextInt(15) + 5,
                new Random().nextInt(3),
                12.5 + new Random().nextDouble() * 3.0,
                80 + new Random().nextInt(15)
        );
    }

    private String getSugestaoAleatoria() {
        Random r = new Random();
        return SUGESTOES[r.nextInt(SUGESTOES.length)];
    }
}
