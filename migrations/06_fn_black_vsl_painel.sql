-- 23/10 (Fábio): bloco "VSL da Tríade" no painel, abaixo do Resumo — quantas pessoas entraram na /vslalunos e
-- quanto assistiram (marcos 25/50/75/100 gravados pela página em vsl_alunos_views), por origem e por dia.
-- Aplicada no Data Core (dqpxugdhlgafvddavzzp) como migração "black_vsl_painel". Sem dado pessoal: só contagens.
-- Origem pelas UTMs que a página grava: pago = anúncio Meta (utm_term = conjunto) · grupo = post no grupo dos
-- alunos · anne/whatsapp = templates da Anne (vsl = disparo VSL1, vsl-entrou, vsl-lembrete) · resto = direto.
create or replace function public.fn_black_vsl_painel()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
with v as (
  select w.*,
    coalesce(w.utm->>'utm_source', '') src, coalesce(w.utm->>'utm_medium', '') med,
    coalesce(w.utm->>'utm_campaign', '') camp, coalesce(w.utm->>'utm_term', '') termo,
    (w.primeira_em at time zone 'America/Manaus')::date dia
  from vw_vsl_alunos w
),
o as (
  select v.*,
    case
      when med = 'pago' then 'Anúncio Meta · ' || coalesce(nullif(termo, ''), 'sem conjunto')
      when src = 'grupo' then 'Post no grupo dos alunos'
      when med = 'anne' or src = 'anne' or (med = 'whatsapp' and camp like 'black-alunos-vsl%') then
        'Anne · ' || case camp when 'black-alunos-vsl' then 'disparo VSL' when 'black-alunos-vsl1' then 'disparo VSL'
                               when 'black-alunos-vsl-entrou' then 'entrou no grupo' when 'black-alunos-vsl-lembrete' then 'lembrete 24 h'
                               else coalesce(nullif(camp, ''), 'sem campanha') end
      else 'Direto / sem UTM'
    end origem
  from v
),
agg as (
  select count(*) entraram,
    count(*) filter (where progresso_max >= 25) p25, count(*) filter (where progresso_max >= 50) p50,
    count(*) filter (where progresso_max >= 75) p75, count(*) filter (where progresso_max >= 100) p100,
    count(*) filter (where visitas > 1) voltaram,
    count(*) filter (where no_grupo_ao_entrar) no_grupo_ao_entrar,
    count(*) filter (where not coalesce(no_grupo_ao_entrar, false)) fora_ao_entrar,
    count(*) filter (where not coalesce(no_grupo_ao_entrar, false) and no_grupo_agora) entraram_grupo_depois,
    count(*) filter (where comentarios > 0) comentaram,
    count(*) filter (where dia = (now() at time zone 'America/Manaus')::date) hoje,
    max(ultima_em) ultima_em
  from o
)
select jsonb_build_object(
  'resumo', (select to_jsonb(agg) from agg),
  'comentarios', (select jsonb_build_object('total', count(*), 'visiveis', count(*) filter (where not coalesce(oculto, false))) from vsl_alunos_comentarios),
  'por_origem', coalesce((select jsonb_agg(x order by x.entraram desc) from (
      select origem, count(*) entraram, count(*) filter (where progresso_max >= 25) p25, count(*) filter (where progresso_max >= 50) p50,
             count(*) filter (where progresso_max >= 75) p75, count(*) filter (where progresso_max >= 100) p100,
             count(*) filter (where not coalesce(no_grupo_ao_entrar, false)) fora_ao_entrar,
             count(*) filter (where not coalesce(no_grupo_ao_entrar, false) and no_grupo_agora) entraram_grupo_depois
      from o group by origem) x), '[]'::jsonb),
  'por_dia', coalesce((select jsonb_agg(x order by x.dia) from (
      select dia, count(*) entraram, count(*) filter (where progresso_max >= 50) p50, count(*) filter (where progresso_max >= 100) p100
      from o group by dia) x), '[]'::jsonb)
);
$$;
revoke all on function public.fn_black_vsl_painel() from public, anon, authenticated;
grant execute on function public.fn_black_vsl_painel() to service_role;
