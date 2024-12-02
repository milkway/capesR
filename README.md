# capesR

**capesR** é um pacote R para facilitar o acesso e a manipulação dos dados do Catálogo de Teses e Dissertações da Fundação Coordenação de Aperfeiçoamento de Pessoal de Nível Superior (CAPES), com informações sobre teses e dissertações defendidas em instituições de ensino superior (IES) no Brasil .

Os dados originais da Capes estão disponíveis em [dadosabertos.capes.gov.br](https://dadosabertos.capes.gov.br/group/catalogo-de-teses-e-dissertacoes-brasil).

Os dados utilizados no pacote estão disponíveis no repositório do [The Open Science Framework (OSF)](https://osf.io/4a5b7/).

## Instalação

Você pode instalar este pacote diretamente do GitHub com:

```r
# Instale o pacote remotes, se ainda não tiver
install.packages("remotes")

# Instale o capesR a partir do GitHub
remotes::install_github("hugoavmedeiros/capesR")
```

## Funções

### Baixar dados

A função `baixar_dados_capes` permite baixar arquivos de dados da CAPES hospedados no OSF. Você pode especificar os anos desejados, e os arquivos correspondentes serão salvos localmente.

#### Exemplo 1
Baixar dados usando o diretório temporário (padrão da função)
```r
library(capesR)
library(dplyr)

# Baixar dados dos anos 1987 e 1990
arquivos_capes <- baixar_dados_capes(c(1987, 1990))

# Visualizar a lista de arquivos baixados
arquivos_capes %>% glimpse()
```
Neste caso, os dados não irão persistir para usos futuros. 

#### Exemplo 2 - Reutilização dos dados

Recomenda-se definir um diretório persistente para armazenar os dados baixados, ao invés de usar o diretório temporário padrão (`tempdir()`). Isso permitirá reusar os dados no futuro. 

```r
# Definir o diretório onde os dados serão armazenados
diretorio_dados <- "/dados_capes"

# Baixar dados dos anos 1987 e 1990 com indicação de diretório persistente
arquivos_capes <- baixar_dados_capes(
  c(1987, 1990),
  destino = diretorio_dados)
```
No caso da utilização de um diretório persistente, os dados serão baixados apenas uma vez. Nos usos posteriores a função informará quais arquivos já existem no diretório, e montará apenas a lista com o endereço dos dados disponíveis. 

### Combinar dados
Use a função ler_dados_capes para combinar os arquivos baixados a partir de uma lista de arquivos gerada com a função `baixar_dados_capes` ou construída manualmente. 

#### Exemplo 1 - Combinação sem filtros

```r
# Combinar todos os dados selecionados, sem uso de filtros
dados_sem_filtro <- ler_dados_capes(arquivos_capes)

# Visualizar os dados combinados
dados_sem_filtro %>% glimpse()
```

#### Exemplo 2 - Combinação dos dados com filtros exatos
Os filtros  são aplicados antes de os dados serem lidos, melhorando a performance. 

```r
# Crie um objeto com os filtros 
filtro_exato <- list(
  ano_base = c(2021, 2022),
  uf = c("PE", "CE")
)

# Combinar os dados já filtrados
dados_filtro_exato <- ler_dados_capes(arquivos_capes, filtro_exato)

# Visualizar os dados combinados
dados_filtro_exato %>% glimpse()
```

#### Exemplo 3 - Combinação dos dados com filtros de texto
Os filtros exatos são aplicados antes de os dados serem lidos, melhorando a performance, e o filtro de texto é otimizado para acelerar a busca nos dados. 

```r
# Crie um objeto com os filtros 
filtro_texto <- list(
  ano_base = c(2018, 2019, 2020, 2021, 2022),
  uf = c("PE", "CE"),
  titulo = "educacao"
)

# Combinar os dados já filtrados
dados_filtro_texto <- ler_dados_capes(arquivos_capes, filtro_texto)

# Visualizar os dados combinados
dados_filtro_texto %>% glimpse()
```

### Realizar buscas
Para realizar buscas de texto em dados já combinados, você pode usar a  função `buscar_texto_capes` informando o termo e o campo de texto  (titulo, resumo, autoria e orientacao)

#### Exemplo:
```r
resultados <- buscar_texto_capes(
  dados = dados_capes,
  termo = "educacao",
  campo = "titulo"
)
```
## Dados
### Dados Sintéticos
O pacote também fornece um conjunto de dados sintéticos, df_capes_sintetico, que contém informações agregadas do Catálogo de Teses e Dissertações. Esses dados foram sintetizados para facilitar análises rápidas e prototipagem, sem a necessidade de baixar e processar arquivos completos.

#### Estrutura dos Dados
Os dados sintéticos incluem as seguintes colunas:

- ano_base: Ano base do dado.
- ies: Instituição de Ensino Superior.
- area: Área de Concentração.
- nome_programa: Nome do Programa de Pós-graduação.
- tipo: Tipo do trabalho (ex.: Mestrado, Doutorado).
- regiao: Região do Brasil.
- uf: Unidade Federativa (estado).
- n: Número total de trabalhos.

#### Carregando os Dados
Os dados sintéticos estão disponíveis diretamente no pacote e podem ser carregados com o comando:

```r
data(df_capes_sintetico)

# Visualizar as primeiras linhas dos dados
head(df_capes_sintetico)
```
#### Exemplo de Uso
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
