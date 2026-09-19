## Builds the `capes_years` index shipped in data/capes_years.rda.
##
## The yearly Parquet files must be present in dados_parquet/ (gitignored).
## They were originally hosted on OSF (https://osf.io/4a5b7/); the local copy
## can be restored from the current host with:
##   capesR::download_capes_data(1987:2022, destination = "dados_parquet")
##
## To move the data to another host, change `base_url` below, upload the files
## (see data-raw/upload_data.sh) and re-run this script.

base_url <- "https://huggingface.co/datasets/mlkwy/capesR/resolve/main"

files <- sort(list.files("dados_parquet", pattern = "^capes_\\d{4}\\.parquet$"))
stopifnot(length(files) == 38)

capes_years <- data.frame(
  year  = as.integer(sub("^capes_(\\d{4})\\.parquet$", "\\1", files)),
  file  = files,
  url   = paste0(base_url, "/", files),
  bytes = as.numeric(file.size(file.path("dados_parquet", files))),
  md5   = unname(tools::md5sum(file.path("dados_parquet", files))),
  stringsAsFactors = FALSE
)

usethis::use_data(capes_years, overwrite = TRUE)
