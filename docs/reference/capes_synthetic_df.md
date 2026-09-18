# Synthetic CAPES Data

Aggregated data from the CAPES Catalog of Theses and Dissertations,
containing summarized information by year, institution, area, program,
type, region, and state (UF).

## Usage

``` r
capes_synthetic_df
```

## Format

A data frame with the following columns:

- base_year:

  Reference year of the data.

- institution:

  Higher Education Institution.

- area:

  Area of Concentration.

- program_name:

  Name of the Graduate Program.

- type:

  Type of work (e.g., Master's, Doctorate).

- region:

  Region of Brazil.

- state:

  Federative Unit (state).

- n:

  Total number of works.

## Source

Synthetic data created from the CAPES Catalog of Theses and
Dissertations.

## Examples

``` r
data(capes_synthetic_df)
head(capes_synthetic_df)
#> # A tibble: 6 × 8
#> # Groups:   base_year, institution, area, program_name, type, region
#> #   [6]
#>   base_year area      institution     n program_name region state type 
#>       <dbl> <chr>     <chr>       <int> <chr>        <chr>  <chr> <chr>
#> 1      1987 CIÊNCIA … (INATIVA) …     7 INFORMÁTICA  NORDE… PB    Mest…
#> 2      1987 ECONOMIA  (INATIVA) …     4 ECONOMIA RU… NORDE… PB    Mest…
#> 3      1987 ENGENHAR… (INATIVA) …     8 ENGENHARIA … NORDE… PB    Mest…
#> 4      1987 ENGENHAR… (INATIVA) …     4 ENGENHARIA … NORDE… PB    Dout…
#> 5      1987 ENGENHAR… (INATIVA) …     5 ENGENHARIA … NORDE… PB    Mest…
#> 6      1987 ENGENHAR… (INATIVA) …     1 ENGENHARIA … NORDE… PB    Mest…
```
