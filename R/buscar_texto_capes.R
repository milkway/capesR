library(dplyr)
library(stringr)

# Declarar `.data` como variável global para evitar avisos
utils::globalVariables(".data")

#' Buscar termos nos campos textuais dos dados do Catálogo de Teses e Dissertações da CAPES
#'
#' Esta função permite buscar termos específicos nos campos textuais de um `data.frame` previamente carregado.
#'
#' @param dados `data.frame` contendo os dados do Catálogo de Teses e Dissertações da CAPES.
#' @param termo string, termo a ser buscado.
#' @param campo string, nome do campo onde buscar (ex.: "resumo", "titulo").
#' @return um `data.frame` com as linhas que correspondem à busca ou uma mensagem informando que nenhum resultado foi encontrado.
#' @importFrom dplyr filter
#' @importFrom stringr str_detect fixed
#' @importFrom magrittr %>%
#' @export
buscar_texto_capes <- function(dados, termo, campo) {
  # Validar entrada
  if (missing(dados) || missing(termo) || missing(campo)) {
    stop("Os parâmetros `dados`, `termo` e `campo` são obrigatórios.")
  }

  if (!is.data.frame(dados)) {
    stop("O parâmetro `dados` deve ser um `data.frame`.")
  }

  if (!campo %in% colnames(dados)) {
    stop(paste("O campo especificado ('", campo, "') não existe no `data.frame` fornecido.", sep = ""))
  }

  # Filtrar pelo termo no campo especificado
  resultados <- dados %>%
    dplyr::filter(stringr::str_detect(.data[[campo]], stringr::fixed(termo, ignore_case = TRUE)))

  # Verificar se existem resultados
  if (nrow(resultados) == 0) {
    message("Nenhum resultado encontrado para a busca.")
    return(data.frame())
  }

  # Retornar os resultados
  return(resultados)
}
