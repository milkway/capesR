skip_if_not_installed("arrow")

df <- data.frame(
  ano_base = c(2020L, 2020L, 2021L),
  uf = c("SP", "PE", "PE"),
  titulo = c("Varicela em crianças", "A catapora no Brasil", "Educação"),
  resumo = c("a", "b", NA),
  stringsAsFactors = FALSE
)
f <- tempfile(fileext = ".parquet")
arrow::write_parquet(df, f)

test_that("exact and text filters combine", {
  res <- read_capes_data(f, filters = list(uf = "PE", titulo = "catapora"))
  expect_equal(res$ano_base, 2020L)
})

test_that("text filters accept a vector of terms", {
  res <- read_capes_data(f, filters = list(titulo = c("varicela", "catapora")))
  expect_equal(res$ano_base, c(2020L, 2020L))
})

test_that("NA in the text column never matches", {
  res <- read_capes_data(f, filters = list(resumo = "a"))
  expect_equal(nrow(res), 1L)
})

test_that("unknown filter columns are rejected", {
  expect_error(read_capes_data(f, filters = list(foo = 1)), "foo")
})
