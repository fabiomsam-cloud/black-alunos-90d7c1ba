-- 28/10/2026 (Fábio): "Custo por cadastro superior — por campanha" na aba não alunos.
-- custo[] de fn_black_cadastros_painel() ganha superiores (qualified = superior cursando/completo/pós)
-- e sup_grupo (superior que está no grupo, casado pelo telefone no Sendflow). Resto da função inalterado.
do $mig$
declare d text; n1 int; n2 int;
  a1 text := E'count(*) filter (where entrou_em is not null) no_grupo\n  from lead where campanha ilike ''[BLACK]%'' group by 1';
  b1 text := E'count(*) filter (where entrou_em is not null) no_grupo,\n         count(*) filter (where qualified) superiores, count(*) filter (where qualified and entrou_em is not null) sup_grupo\n  from lead where campanha ilike ''[BLACK]%'' group by 1';
  a2 text := 'coalesce(c.cadastros, 0) cadastros, coalesce(c.no_grupo, 0) no_grupo,';
  b2 text := 'coalesce(c.cadastros, 0) cadastros, coalesce(c.no_grupo, 0) no_grupo, coalesce(c.superiores, 0) superiores, coalesce(c.sup_grupo, 0) sup_grupo,';
begin
  d := pg_get_functiondef('public.fn_black_cadastros_painel()'::regprocedure);
  n1 := (length(d) - length(replace(d, a1, ''))) / length(a1);
  n2 := (length(d) - length(replace(d, a2, ''))) / length(a2);
  if n1 <> 1 or n2 <> 1 then raise exception 'trecho não encontrado (n1=%, n2=%)', n1, n2; end if;
  execute replace(replace(d, a1, b1), a2, b2);
end $mig$;
