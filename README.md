# capesR

**capesR** é um pacote R para acessar e manipular dados do Catálogo de Teses e Dissertações da CAPES.

## Instalação

Você pode instalar este pacote diretamente do GitHub com:

```r
# Instale o pacote remotes, se ainda não tiver
install.packages("remotes")

# Instale o capesR a partir do GitHub
remotes::install_github("hugoavmedeiros/capesR")
```

## Principais funções

### Baixar dados

A função `baixar_dados_capes` permite baixar arquivos de dados da CAPES hospedados no OSF. Você pode especificar os anos desejados, e os arquivos correspondentes serão salvos localmente.

#### Exemplo:
```r
library(capesR)

# Baixar dados dos anos 1987 e 1990
arquivos_capes <- baixar_dados_capes(c(1987, 1990))
```
### Reutilização dos dados

Recomenda-se definir um diretório persistente para armazenar os dados baixados, como `dados_capes`, em vez de usar o diretório temporário padrão (`tempdir()`). Isso permitirá reusar os dados no futuro. 

#### Exemplo:

```r
# Definir o diretório onde os dados serão armazenados
diretorio_dados <- "/dados_capes"

# Buscar pelo termo "educação" no campo "titulo" para os anos 1987 e 1990
arquivos_capes <- baixar_dados_capes(
  c(1987, 1990),
  destino = 'dados_capes')
```

### Combinar dados
Use a função ler_dados_capes para combinar os arquivos baixados

#### Exemplo 1
Combinação sem filtros.

```r
dados_capes <- ler_dados_capes(arquivos_capes)
head(dados_capes)
```

#### Exemplo 2
Combinação com filtros, que são aplicados antes de os dados serem lidos, melhorando a performance. 

```r
# indique os filtros
filtros <- list(ano_base = c(1987), uf = c("PE", "CE"))

# Carregar e filtrar os dados
dados_filtrados <- ler_dados_capes(arquivos_capes, filtros)

# Visualizar os resultados filtrados
head(dados_filtrados)
```

### Realizar buscas
Use a função buscar_texto_capes para realizar buscas de texto nos campos textuais (titulo, resumo, autoria e orientacao)

#### Exemplo:
```r
resultados <- buscar_texto_capes(
  dados = dados_capes,
  termo = "educacao",
  campo = "titulo"
)
```

## Dados Sintéticos
O pacote também fornece um conjunto de dados sintéticos, df_capes_sintetico, que contém informações agregadas do Catálogo de Teses e Dissertações. Esses dados foram sintetizados para facilitar análises rápidas e prototipagem, sem a necessidade de baixar e processar arquivos completos.

### Estrutura dos Dados
Os dados sintéticos incluem as seguintes colunas:

- ano_base: Ano base do dado.
- ies: Instituição de Ensino Superior.
- area: Área de Concentração.
- nome_programa: Nome do Programa de Pós-graduação.
- tipo: Tipo do trabalho (ex.: Mestrado, Doutorado).
- regiao: Região do Brasil.
- uf: Unidade Federativa (estado).
- n: Número total de trabalhos.

### Carregando os Dados
Os dados sintéticos estão disponíveis diretamente no pacote e podem ser carregados com o comando:

```r
data(df_capes_sintetico)

# Visualizar as primeiras linhas dos dados
head(df_capes_sintetico)
```
### Exemplo de Uso
Você pode utilizar os dados sintéticos para criar análises exploratórias ou gráficos rápidos:

```r
# Carregar os dados
data(df_capes_sintetico)

# Exemplo: Contagem por ano e tipo de trabalho
library(dplyr)
df_capes_sintetico %>%
  group_by(ano_base, tipo) %>%
  summarise(total = sum(n)) %>%
  arrange(desc(total))
```