-- 21/10/2026 — fn_black_cadastros_painel(): custo por campanha passou a casar gasto (meta_ads_insights) × cadastros (utm_campaign)
-- por CHAVE NORMALIZADA: lower(nome) sem as tags [LEADS] e [META] e com espaços colapsados. Motivo: as 4 campanhas da conta ON-LINE
-- foram renomeadas na Meta com [LEADS] (ex.: "[BLACK][LEADS][NAOALUNOS][POLICIAS] concurso · v4") e os cliques continuam chegando
-- com o utm_campaign antigo ("[BLACK][NAOALUNOS][POLICIAS] concurso · v4") — 4 campanhas apareciam sem gasto no painel.
-- Novos campos em custo[]: campanha_meta, conta, ck, atualizado_em, alunos (pelo funil do lead), captacao (false = engajamento).
-- sync.gasto_atualizado_em = última gravação do n8n "META · Contas Spend" (roda de hora em hora).
-- APLICADA via MCP (migration fn_black_cadastros_painel_custo_chave_normalizada). Fonte da verdade = o banco.
select 'ver fn_black_cadastros_painel() no banco';
