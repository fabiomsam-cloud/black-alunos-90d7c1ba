-- 08/10/2026 — Painel Black · alunos. APLICADA no SOU Data Core (dqpxugdhlgafvddavzzp) via MCP.
-- Uma função, zero PII na saída: base por ângulo (black_alunos_camadas), campanhas [BLACK][ALUNOS] (espelho anne_disparos /
-- anne_disparo_recipients, 5 min), respostas (anne_contato_dia, 15 min), entrada no grupo (sendflow_membros frente BLACK_ALUNOS,
-- tempo real) e check-ins (survey_answers do funil c9254ab8). Atribuição: entrada "via disparo" = telefone recebeu template
-- de uma campanha Black ANTES de entrar; "da base, sem disparo" = está em black_alunos_camadas; o resto é orgânico.
-- Pré-requisitos: tabela black_alunos_camadas (preparar_black_alunos.py), linha BLACK_ALUNOS em sendflow_release_frente,
-- funil Black em funnels (typeform_form_id sSo84jdL). Ângulo da campanha = regex no nome: '[BLACK][ALUNOS] 7a · ...'.
-- (corpo idêntico ao criado em 08/10 — ver histórico da sessão; reaplicar = colar a função inteira)
select 'ver fn_black_alunos_painel() no banco — fonte da verdade é o banco; este arquivo é o registro da decisão';
