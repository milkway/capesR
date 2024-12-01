library(arrow)
library(dplyr)
library(stringr)
library(rlang)

#' Ler e filtrar dados do Catálogo de Teses e Dissertações da CAPES
#'
#' Esta função combina os dados de múltiplos arquivos Parquet e aplica filtros opcionais, incluindo buscas textuais.
#'
#' @param arquivos vetor ou lista de caminhos dos arquivos Parquet.
#' @param filtros lista de filtros para aplicar (ex.: list(ano_base = 1987, uf = "SP", titulo = "educação")).
#' @return um `data.frame` contendo os dados combinados e filtrados.
#' @importFrom arrow open_dataset
#' @importFrom dplyr filter
#' @importFrom stringr str_detect fixed
#' @importFrom rlang sym
#' @export
ler_dados_capes <- function(arquivos, filtros = list()) {
  # Transformar lista nomeada em vetor de caminhos, se necessário
  if (is.list(arquivos)) {
    arquivos <- unlist(arquivos, use.names = FALSE)
  }

  # Verificar se os arquivos existem
  if (any(!file.exists(arquivos))) {
    stop("Um ou mais arquivos especificados não existem.")
  }

  # Abrir os arquivos Parquet como um dataset único
  dataset <- arrow::open_dataset(arquivos)

  # Aplicar filtros exatos
  if (length(filtros) > 0) {
    for (campo in names(filtros)) {
      valor <- filtros[[campo]]

      if (campo == "titulo" && is.character(valor)) {
        # Filtro textual será aplicado após a leitura
        next
      } else {
        # Filtro para valores exatos
        dataset <- dataset %>%
          dplyr::filter(!!sym(campo) %in% valor)
      }
    }
  }

  # Carregar os dados filtrados em um `data.frame`
  dados <- as.data.frame(dataset)

  # Aplicar filtro textual em memória
  if ("titulo" %in% names(filtros) && !is.null(filtros$titulo)) {
    termo <- filtros$titulo
    dados <- dados %>%
      dplyr::filter(stringr::str_detect(.data[["titulo"]], stringr::fixed(termo, ignore_case = TRUE)))
  }

  # Retornar o data.frame final
  return(dados)
}
