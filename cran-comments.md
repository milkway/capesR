## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Maintainer change

The maintainer changed from Hugo Vasconcelos Medeiros (on CRAN record as
<hugo.medeiros@ufpe.br>; now listed as <hugoavmedeiros@gmail.com>) to
André Leite <leite@castlab.org>. Both are package authors; the previous
maintainer has been asked to confirm the change by e-mail to CRAN.

## Changes in this release

* The data files moved from OSF to a new host; the download URLs are now
  shipped in the `capes_years` dataset and the download function verifies the
  file size. Examples that download data remain wrapped in \donttest{}.
