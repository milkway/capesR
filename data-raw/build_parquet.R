## Converts the CAPES "Catálogo de Teses e Dissertações" CSVs (2013 onwards layout,
## latin1, ';'-separated) in dados_raw/capes_<year>.csv into the 12-column
## parquet files distributed by the package (dados_parquet/capes_<year>.parquet).
##
## CSV source: https://dadosabertos.capes.gov.br/group/catalogo-de-teses-e-dissertacoes-brasil
## Usage: Rscript data-raw/build_parquet.R 2023 2024   (or no args = all CSVs present)

suppressPackageStartupMessages({
  library(readr); library(dplyr); library(arrow)
})

# CSV column -> package column (same layout used by the original 1987-2022 files)
col_map <- c(
  ano_base      = "AN_BASE",
  ies           = "NM_ENTIDADE_ENSINO",
  area          = "NM_AREA_AVALIACAO",
  nome_programa = "NM_PROGRAMA",
  tipo          = "NM_SUBTIPO_PRODUCAO",
  titulo        = "NM_PRODUCAO",
  resumo        = "DS_RESUMO",
  idioma        = "NM_IDIOMA",
  autoria       = "NM_DISCENTE",
  orientacao    = "NM_ORIENTADOR",
  regiao        = "NM_REGIAO",
  uf            = "SG_UF_IES"
)

build_year <- function(year) {
  csv <- file.path("dados_raw", sprintf("capes_%s.csv", year))
  out <- file.path("dados_parquet", sprintf("capes_%s.parquet", year))
  stopifnot(file.exists(csv))
  message("Reading ", csv)
  raw <- read_delim(csv, delim = ";", locale = locale(encoding = "latin1"),
                    col_types = cols(.default = col_character()),
                    col_select = all_of(unname(col_map)), progress = FALSE,
                    show_col_types = FALSE)
  # CAPES CSVs occasionally have a row with a broken quote in DS_RESUMO that
  # swallows the trailing columns (not used here). Tolerate a handful of such
  # rows as long as the columns we keep are filled; fail on anything larger.
  pr <- problems(raw)
  if (nrow(pr) > 0) {
    message("  ", nrow(pr), " parse problem(s) in ", csv, " (rows ", paste(unique(pr$row), collapse = ","), ")")
    print(pr)
    bad <- raw[unique(pr$row), c("AN_BASE", "NM_ENTIDADE_ENSINO", "NM_PRODUCAO", "NM_DISCENTE")]
    if (nrow(pr) > 10 || anyNA(bad)) stop("parse problems in ", csv)
  }
  d <- raw |>
    rename(all_of(col_map)) |>
    mutate(ano_base = as.numeric(ano_base)) |>
    select(all_of(names(col_map)))
  stopifnot(all(d$ano_base == as.numeric(year)))
  message("  ", nrow(d), " rows -> ", out)
  write_parquet(d, out, compression = "snappy")
  invisible(d)
}

years <- commandArgs(trailingOnly = TRUE)
if (length(years) == 0) {
  years <- sub("^capes_(\\d{4})\\.csv$", "\\1", list.files("dados_raw", "^capes_\\d{4}\\.csv$"))
}
for (y in years) build_year(y)
