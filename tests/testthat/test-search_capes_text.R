df <- data.frame(
  titulo = c("Varicela em crianças", "A CATAPORA no Brasil", "Educação e saúde", NA),
  resumo = c("estudo clínico", "vacina contra varicela", "escola e saúde pública", "catapora"),
  ano_base = c(2020L, 2021L, 2022L, 2023L),
  stringsAsFactors = FALSE
)

test_that("a single term in a single field works and ignores case", {
  res <- search_capes_text(df, term = "varicela", field = "titulo")
  expect_equal(res$ano_base, 2020L)
  res <- search_capes_text(df, term = "catapora", field = "titulo")
  expect_equal(res$ano_base, 2021L)
})

test_that("several terms are combined with OR (#5)", {
  res <- search_capes_text(df, term = c("Catapora", "varicela"), field = "titulo")
  expect_equal(res$ano_base, c(2020L, 2021L))
})

test_that("several fields are searched", {
  res <- search_capes_text(df, term = c("varicela", "catapora"), field = c("titulo", "resumo"))
  expect_equal(res$ano_base, c(2020L, 2021L, 2023L))
})

test_that("match = 'all' requires every term", {
  res <- search_capes_text(df, term = c("saúde", "escola"), field = "resumo", match = "all")
  expect_equal(res$ano_base, 2022L)
  # terms may be satisfied by different fields
  res <- search_capes_text(df, term = c("catapora", "vacina"), field = c("titulo", "resumo"), match = "all")
  expect_equal(res$ano_base, 2021L)
  expect_message(
    res <- search_capes_text(df, term = c("varicela", "escola"), field = "titulo", match = "all")
  )
  expect_equal(nrow(res), 0L)
})

test_that("no match returns an empty data.frame with the same columns", {
  expect_message(res <- search_capes_text(df, term = "xyz", field = "titulo"), "No results")
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 0L)
  expect_equal(names(res), names(df))
})

test_that("matching is literal, not a regular expression", {
  expect_message(res <- search_capes_text(df, term = "sa.de", field = "titulo"))
  expect_equal(nrow(res), 0L)
})

test_that("invalid input is rejected", {
  expect_error(search_capes_text(df, term = "a", field = "nope"), "'nope'")
  expect_error(search_capes_text(df, term = character(0), field = "titulo"), "`term`")
  expect_error(search_capes_text(df, term = "", field = "titulo"), "`term`")
  expect_error(search_capes_text(df, term = 1, field = "titulo"), "`term`")
  expect_error(search_capes_text(list(), term = "a", field = "titulo"), "data.frame")
  expect_error(search_capes_text(df, term = "a", field = "titulo", match = "some"))
})

test_that("the Portuguese alias is the same function", {
  expect_identical(buscar_texto_capes, search_capes_text)
})
