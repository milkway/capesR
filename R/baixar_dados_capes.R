library(arrow)

#' Baixar dados anuais do Catálogo de Teses e Dissertações da Fundação Coordenação de Aperfeiçoamento de Pessoal de Nível Superior (CAPES) de acordo com os anos selecionados. Os arquivos ficam disponíveis no diretório informado, em formato parquet.
#'
#' @param anos vetor com os anos desejados
#' @param destino diretório onde os arquivos serão salvos (padrão: diretório temporário)
#' @return lista de caminhos dos arquivos baixados ou já existentes
#' @importFrom utils data download.file
#' @export
baixar_dados_capes <- function(anos, destino = tempdir()) {
  # Carregar o dataset anos_osf
  data("anos_osf", package = "capesR", envir = environment())

  # Filtrar os IDs para os anos desejados
  ids_filtrados <- capesR::anos_osf[capesR::anos_osf$ano %in% anos, ]

  # Verificar se há anos inválidos
  if (nrow(ids_filtrados) == 0) {
    stop("Nenhum dos anos selecionados está disponível.")
  }

  # Loop para baixar os arquivos
  arquivos_baixados <- list()
  for (i in seq_len(nrow(ids_filtrados))) {
    # Nome do arquivo de destino
    arquivo_destino <- file.path(destino, paste0("capes_", ids_filtrados$ano[i], ".parquet"))

    # Verificar se o arquivo já existe
    if (!file.exists(arquivo_destino)) {
      url <- paste0("https://osf.io/download/", ids_filtrados$osf_id[i], "/")
      message(paste("Baixando:", arquivo_destino))
      download.file(url, arquivo_destino, mode = "wb")
    } else {
      message(paste("Arquivo já existe no diretório:", arquivo_destino))
    }

    # Adicionar à lista de arquivos baixados
    arquivos_baixados[[as.character(ids_filtrados$ano[i])]] <- arquivo_destino
  }

  # Retornar os caminhos dos arquivos baixados ou já existentes
  return(arquivos_baixados)
}
