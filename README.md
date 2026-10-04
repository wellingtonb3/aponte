# Ponte

Comunidade aberta que conecta **profissionais experientes** (mentores e empresas)
a pessoas em **inicio de carreira ou transicao** — em qualquer idade.

## Funcionalidades (MVP)

- **Tres papeis**: mentor, mentorado e empresa (empresas tambem podem mentorar).
- **Rede de mentoria**: mentorados solicitam mentoria; mentores aceitam/recusam.
  Um mentorado pode ter varios mentores.
- **Contribuicoes publicas**: mentorados publicam projetos, PRs open source,
  palestras e eventos no perfil publico.
- **Recomendacoes**: mentores recomendam contribuicoes de mentorados da sua rede —
  evidencia real para o mercado.
- **Busca de talentos**: empresas (e qualquer visitante) buscam mentorados por
  habilidade, ordenados por recomendacoes.
- **Quadro de oportunidades**: mentores e empresas publicam vagas, eventos e
  projetos open source — inclusive para colaboracao entre mentores.
- **Perfis publicos**: qualquer pessoa pode ver perfis, redes e contribuicoes.

## Stack

- Next.js (App Router) + React + Tailwind CSS
- SQLite via `node:sqlite` embutido no Node 24+ (zero dependencias nativas)
- Autenticacao propria: senha com scrypt + sessao por cookie httpOnly

## Rodando local

```bash
npm install
npm run dev
# http://localhost:3000
```

O banco `data/ponte.db` e criado e populado com dados de demo na primeira
execucao. Para comecar do zero, apague a pasta `data/`.

### Contas de demo (senha: `senha123`)

| Papel      | Email              |
| ---------- | ------------------ |
| Mentor     | ana@ponte.dev      |
| Mentor     | carlos@ponte.dev   |
| Mentor     | rita@ponte.dev     |
| Empresa    | contato@techcorp.dev |
| Mentorado  | joao@email.com     |
| Mentorado  | maria@email.com    |
| Mentorado  | pedro@email.com    |

## Deploy (Docker — Railway, Render, Fly.io, VPS)

```bash
docker build -t ponte .
docker run -p 3000:3000 -v ponte-data:/app/data ponte
```

O volume `/app/data` persiste o SQLite. Para apontar o banco para outro
caminho, use a env `DATABASE_PATH`.

## Deploy no Render

O repositorio inclui um `render.yaml` (Blueprint) com o servico Docker,
`DATABASE_PATH` e o health check ja configurados: no Render, use
**New > Blueprint** e aponte para este repositorio.

### Plano free — atencao

O plano free **nao suporta disco persistente**. O SQLite vive em `/app/data`,
um filesystem efemero: os dados sao apagados a cada deploy, reinicio ou
spin-down (o Render desliga o servico apos 15 min sem trafego).

O `seedIfEmpty()` repovoa os dados de demo a cada boot, entao o site nunca
aparece vazio — mas cadastros e contribuicoes reais **nao persistem**.

Para persistir de verdade:

- **Opcao A**: mude o `plan` para `starter` (pago) e descomente o bloco `disk`
  no `render.yaml` (mount em `/app/data`).
- **Opcao B**: migre o banco para um servico externo (ex.: Turso/libSQL).

## Nota sobre o `.npmrc`

O `.npmrc` e todas as URLs do `package-lock.json` apontam para o registry
oficial (`registry.npmjs.org`). Se sua rede tiver alguma restricao, ajuste
o registro conforme necessario.
