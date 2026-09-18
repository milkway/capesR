## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

Checked locally on macOS (R 4.6.0), including the \donttest{} examples that
download data.

## Maintainer change

The maintainer changed from Hugo Vasconcelos Medeiros (on CRAN record as
<hugo.medeiros@ufpe.br>; now listed as <hugoavmedeiros@gmail.com>) to
André Leite <leite@castlab.org>. Both are package authors; the previous
maintainer has been asked to confirm the change by e-mail to CRAN.

## Changes in this release (0.2.0)

* Data coverage extended from 1987-2022 to 1987-2024 using the files published
  by CAPES in 2025 (2023 and 2024 added; 2019, 2021 and 2022 revised).
* The data files moved from OSF to Hugging Face
  (<https://huggingface.co/datasets/mlkwy/capesR>). The new `capes_years`
  dataset (year, file, url, bytes, md5) replaces `years_osf`;
  `download_capes_data()` reads the URLs from it, gains a `base_url` argument
  for mirrors, downloads to a temporary file and checks the file size.
  Examples that download data remain wrapped in \donttest{} and the function
  fails gracefully (message, no error) when a file cannot be downloaded.
* `read_capes_data()` text search now matches the actual column names of the
  data (`titulo`, `resumo`).
* Package URL and BugReports moved to <https://github.com/milkway/capesR>.
