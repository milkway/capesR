#' Dados Sintéticos da CAPES
#'
#' Dados agregados do Catálogo de Teses e Dissertações da CAPES,
#' contendo informações resumidas por ano, instituição, área, programa, tipo, região e UF.
#'
#' @format Um data frame com as colunas:
#' \describe{
#'   \item{ano_base}{Ano base do dado.}
#'   \item{ies}{Instituição de Ensino Superior.}
#'   \item{area}{Área de Concentração.}
#'   \item{nome_programa}{Nome do Programa de Pós-graduação.}
#'   \item{tipo}{Tipo do trabalho (ex.: Mestrado, Doutorado).}
#'   \item{regiao}{Região do Brasil.}
#'   \item{uf}{Unidade Federativa (estado).}
#'   \item{n}{Número total de trabalhos.}
#' }
#' @source Dados sintéticos criados a partir do Catálogo de Teses e Dissertações da CAPES.
#' @examples
#' data(df_capes_sintetico)
#' head(df_capes_sintetico)
"df_capes_sintetico"
