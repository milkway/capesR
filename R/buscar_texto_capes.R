library(arrow)
library(dplyr)
library(stringr)
library(rlang)
#' Buscar termos nos campos textuais dos dados Catálogo de Teses e Dissertações da Fundação Coordenação de Aperfeiçoamento de Pessoal de Nível Superior (CAPES)
#'
#' Esta função permite buscar termos específicos nos campos textuais do Catálogo de Teses e Dissertações da CAPES.
#' Caso os arquivos ainda não estejam disponíveis no diretório especificado, eles serão baixados automaticamente.
#'
#' @param termo string, termo a ser buscado.
#' @param campo string, nome do campo onde buscar (ex.: "resumo", "titulo").
#' @param anos vetor de anos a serem considerados na busca.
#' @param destino diretório onde os arquivos estão ou serão salvos (padrão: `tempdir()`).
#' @return um `data.frame` com as linhas que correspondem à busca.
#' @importFrom dplyr filter bind_rows
#' @importFrom stringr str_detect fixed
#' @importFrom rlang sym
#' @importFrom arrow open_dataset
#' @importFrom utils download.file
#' @export
buscar_texto_capes <- function(termo, campo, anos, destino = tempdir()) {
  # Validar entrada
  if (missing(termo) || missing(campo) || missing(anos)) {
    stop("Os parâmetros `termo`, `campo` e `anos` são obrigatórios.")
  }

  # Carregar os dados de anos e IDs
  anos_osf <- capesR::anos_osf

  # Filtrar os anos disponíveis
  anos_disponiveis <- anos_osf$ano
  if (any(!anos %in% anos_disponiveis)) {
    stop("Alguns anos especificados não estão disponíveis nos dados.")
  }

  # Filtrar os IDs do OSF para os anos desejados
  osf_ids <- dplyr::filter(anos_osf, ano %in% anos)

  # Preparar lista de resultados
  resultados <- list()

  for (i in seq_len(nrow(osf_ids))) {
    ano <- osf_ids$ano[i]
    osf_id <- osf_ids$osf_id[i]
    arquivo_destino <- file.path(destino, paste0("capes_", ano, ".parquet"))

    # Baixar o arquivo se necessário
    if (!file.exists(arquivo_destino)) {
      url <- paste0("https://osf.io/download/", osf_id, "/")
      message(paste("Baixando:", arquivo_destino))
      utils::download.file(url, arquivo_destino, mode = "wb")
    }

    # Abrir o arquivo Parquet
    dataset <- arrow::open_dataset(arquivo_destino)

    # Filtrar pelo termo no campo especificado
    resultado <- dataset %>%
      dplyr::filter(stringr::str_detect(get(campo), stringr::fixed(termo, ignore_case = TRUE))) %>%
      as.data.frame()

    # Adicionar ao resultado
    if (nrow(resultado) > 0) {
      resultados[[as.character(ano)]] <- resultado
    }
  }

  # Combinar os resultados
  if (length(resultados) > 0) {
    dplyr::bind_rows(resultados)
  } else {
    message("Nenhum resultado encontrado para a busca.")
    return(data.frame())
  }
}
