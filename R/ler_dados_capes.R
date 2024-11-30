# Arquivo: R/ler_dados_capes.R
#' Ler arquivos Parquet baixados e combinar os dados
#'
#' @param arquivos Lista de caminhos dos arquivos Parquet
#' @return Data frame combinado com todos os dados lidos
#' @export
ler_dados_capes <- function(arquivos) {
  dados <- lapply(arquivos, arrow::read_parquet)
  dados_combinados <- dplyr::bind_rows(dados)
  return(dados_combinados)
}
