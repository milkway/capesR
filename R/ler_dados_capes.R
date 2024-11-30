library(arrow)
library(dplyr)

#' Ler e filtrar dados do Catálogo de Teses e Dissertações da CAPES
#'
#' Esta função combina os dados de múltiplos arquivos Parquet e aplica filtros opcionais.
#'
#' @param arquivos vetor ou lista de caminhos dos arquivos Parquet.
#' @param filtros lista de filtros para aplicar (ex.: list(ano_base = 1987, uf = "SP")).
#' @return um `data.frame` contendo os dados combinados e filtrados.
#' @importFrom arrow open_dataset
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

  # Aplicar filtros, se fornecidos
  if (length(filtros) > 0) {
    for (campo in names(filtros)) {
      valor <- filtros[[campo]]

      # Adicionar condição de filtro ao dataset
      dataset <- dataset %>% dplyr::filter(.data[[campo]] %in% valor)
    }
  }

  # Converter o resultado para um data.frame e retornar
  return(as.data.frame(dataset))
}
