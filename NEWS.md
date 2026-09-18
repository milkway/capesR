# capesR 0.2.0

* Data updated from the CAPES open data portal: years 2023 and 2024 added, and
  2019, 2021 and 2022 replaced by the revised files CAPES published in 2025
  (institution names in those files now use `(CAMPUS)` instead of `( CAMPUS )`).
  The package now covers 1987 through 2024.
* André Leite is now the package maintainer (previously Hugo Vasconcelos Medeiros).
* Data hosting moved off OSF. The yearly Parquet files are now listed in the new
  `capes_years` dataset (year, file, url, bytes, md5), which replaces `years_osf`.
  `download_capes_data()` reads the URL from that table, so the host can change
  without touching the code.
* `download_capes_data()` gains a `base_url` argument (default
  `getOption("capesR.base_url")`) to download from a mirror, downloads to a
  temporary `.part` file first, checks the file size, and warns about requested
  years that are not available.
* `read_capes_data()` text search now works on the actual column names of the
  data (`titulo`, `resumo`); it previously only recognised `title`, so
  `filters = list(titulo = "...")` silently matched nothing.
* `read_capes_data()` no longer loads the whole dataset into memory just to
  read the column names.
* Repository moved to <https://github.com/milkway/capesR>.

# capesR 0.1.0

* Initial CRAN release.
