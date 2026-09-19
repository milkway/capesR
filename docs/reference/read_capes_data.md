# Read and filter data from the CAPES Catalog of Theses and Dissertations

This function combines data from multiple Parquet files and applies
optional filters, including text-based searches.

## Usage

``` r
read_capes_data(files, filters = list())

ler_dados_capes(files, filters = list())
```

## Arguments

- files:

  A vector or list of paths to Parquet files.

- filters:

  A named list of filters. Values for the text columns \`titulo\` and
  \`resumo\` (or \`title\`/\`abstract\`) are matched as case-insensitive
  substrings; all other columns are matched exactly (e.g.,
  \`list(ano_base = 1987, uf = "SP", titulo = "educação")\`).

## Value

A \`data.frame\` containing the combined and filtered data.

## Examples

``` r
# \donttest{
# Download data for the years 1987 and 1990
capes_files <- download_capes_data(c(1987, 1990))
#> File already exists: /var/folders/j9/7g_srh2x0d71c5q0pbj5mxh40000gn/T//RtmpEMM0Z3/capes_1987.parquet
#> File already exists: /var/folders/j9/7g_srh2x0d71c5q0pbj5mxh40000gn/T//RtmpEMM0Z3/capes_1990.parquet
# Combine all selected data
combined_data <- read_capes_data(capes_files)
# }
```
