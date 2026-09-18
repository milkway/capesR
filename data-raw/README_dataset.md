---
license: other
license_name: capes-open-data
license_link: https://dadosabertos.capes.gov.br
language:
  - pt
pretty_name: CAPES Catalog of Theses and Dissertations (1987-2024)
tags:
  - brazil
  - education
  - theses
size_categories:
  - 1M<n<10M
configs:
  - config_name: default
    data_files: "capes_*.parquet"
---

# CAPES Catalog of Theses and Dissertations, 1987-2024

One Parquet file per year (`capes_1987.parquet` ... `capes_2024.parquet`) derived from the
open data of the Brazilian Coordination for the Improvement of Higher Education Personnel
(CAPES): <https://dadosabertos.capes.gov.br/group/catalogo-de-teses-e-dissertacoes-brasil>.

Columns: `ano_base`, `ies`, `area`, `nome_programa`, `tipo`, `titulo`, `resumo`, `idioma`,
`autoria`, `orientacao`, `regiao`, `uf`.

These files back the R package [capesR](https://github.com/mlkwy/capesR)
(`capesR::download_capes_data()`). Maintained by André Leite; original compilation by
Hugo Vasconcelos Medeiros, Dalson Figueiredo Filho and André Leite.
