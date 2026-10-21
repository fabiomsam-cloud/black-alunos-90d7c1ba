-- 21/10 (Fábio): TESTE DA V4 — rodízio 20% (v4, v2, v2b, v2c, v5) a partir do link /v4 das campanhas.
-- Aplicada no Data Core (dqpxugdhlgafvddavzzp) como migração "black_teste_v4_visitas_painel".
-- 1) tabela de visitas anônimas (1 por página por sessão; sem dado pessoal nem IP), gravada pela edge gerador-paginas (op "visita"):
create table if not exists public.paginas_aulas_visitas (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  slug text not null, versao text not null, teste text, visitante text,
  utm_source text, utm_medium text, utm_campaign text, utm_term text, utm_content text,
  referrer text, largura int, user_agent text
);
create index if not exists paginas_aulas_visitas_slug_dt on public.paginas_aulas_visitas (slug, created_at);
create index if not exists paginas_aulas_visitas_teste on public.paginas_aulas_visitas (teste, versao) where teste is not null;
alter table public.paginas_aulas_visitas enable row level security;
revoke all on public.paginas_aulas_visitas from anon, authenticated;
-- 2) fn_black_cadastros_painel: lead_all ganha `l.answers->>'teste' teste`; nao_alunos ganha o bloco
--    'teste_v4': { inicio, paginas: [ {versao, ordem, visitantes (distinct visitante), visitas, cadastros, superior, clicaram, no_grupo, hoje} ] }
--    cruzando paginas_aulas_visitas (teste='v4', slug não alunos) × leads com answers.teste='v4', por versão, na ordem v4, v2, v2b, v2c, v5.
--    Definição completa: select pg_get_functiondef('public.fn_black_cadastros_painel'::regproc);
-- 3) 21/10 15:08 (migração "black_teste_v4_sem_robos"): vis_v4 ignora user_agent ~* (facebookexternalhit|bot|crawler|spider|headless|preview|fetch) — o robô da Meta executa o script e gravava visita.
