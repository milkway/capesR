# Annual files of the CAPES Catalog of Theses and Dissertations

A data frame listing, for each year, the Parquet file distributed by the
package and the URL from which it is downloaded. Used internally by
\[download_capes_data()\]; the host can be overridden with the
\`capesR.base_url\` option (see \[download_capes_data()\]).

## Usage

``` r
capes_years
```

## Format

A data frame with one row per year (1987-2024) and the columns:

- year:

  Year of the data.

- file:

  File name (e.g. \`capes_1987.parquet\`).

- url:

  Download URL of the file.

- bytes:

  File size in bytes, used to check the download.

- md5:

  MD5 checksum of the file.

## Source

Derived from the CAPES open data portal,
\<https://dadosabertos.capes.gov.br/group/catalogo-de-teses-e-dissertacoes-brasil\>.

## Examples

``` r
data(capes_years)
head(capes_years)
#>   year               file
#> 1 1987 capes_1987.parquet
#> 2 1988 capes_1988.parquet
#> 3 1989 capes_1989.parquet
#> 4 1990 capes_1990.parquet
#> 5 1991 capes_1991.parquet
#> 6 1992 capes_1992.parquet
#>                                                                            url
#> 1 https://huggingface.co/datasets/mlkwy/capesR/resolve/main/capes_1987.parquet
#> 2 https://huggingface.co/datasets/mlkwy/capesR/resolve/main/capes_1988.parquet
#> 3 https://huggingface.co/datasets/mlkwy/capesR/resolve/main/capes_1989.parquet
#> 4 https://huggingface.co/datasets/mlkwy/capesR/resolve/main/capes_1990.parquet
#> 5 https://huggingface.co/datasets/mlkwy/capesR/resolve/main/capes_1991.parquet
#> 6 https://huggingface.co/datasets/mlkwy/capesR/resolve/main/capes_1992.parquet
#>     bytes                              md5
#> 1 2652675 24c7d0b2f3fec82ffb3717ed1edbd9b7
#> 2 2578151 6dcfe91ed596c8f80f469bc1f8809a62
#> 3 3071802 bb49104e68e737791af00a819a4b2b64
#> 4 3648890 6d734111246c38edba0bdf7ab07e1ce4
#> 5 4671563 ddb1ed0c95914861913e03fa9eb339e7
#> 6 5236593 f7f9e70d1f1a9825968116e2fef1e1f2
```
