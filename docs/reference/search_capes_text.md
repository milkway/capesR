# Search for terms in text fields of the CAPES Catalog of Theses and Dissertations data

This function allows searching for specific terms in the text fields of
a previously loaded \`data.frame\`.

## Usage

``` r
search_capes_text(data, term, field)

buscar_texto_capes(data, term, field)
```

## Arguments

- data:

  A \`data.frame\` containing the CAPES Catalog of Theses and
  Dissertations data.

- term:

  A string, the term to search for.

- field:

  A string, the name of the field to search in (e.g., "resumo",
  "titulo").

## Value

A \`data.frame\` with rows matching the search or a message indicating
no results were found.

## Examples

``` r
# \donttest{
# Download data for the years 1987 and 1990
capes_files <- download_capes_data(c(1987, 1990))
#> File already exists: /var/folders/j9/7g_srh2x0d71c5q0pbj5mxh40000gn/T//RtmpEMM0Z3/capes_1987.parquet
#> File already exists: /var/folders/j9/7g_srh2x0d71c5q0pbj5mxh40000gn/T//RtmpEMM0Z3/capes_1990.parquet
# Combine all selected data
combined_data <- read_capes_data(capes_files)
# Search data
results <- search_capes_text(
data = combined_data,
term = "Educação",
  field = "titulo"
)
#> No results found for the search.
# }
```
