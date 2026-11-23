# Decisões estruturais da Camada 1

## 1. Representação de `Time`

```haskell
type Time = String
```

Foi utilizado um sinônimo de `String` porque essa é a estrutura solicitada no enunciado.

Embora `Time` continue sendo internamente uma `String`, o nome torna as assinaturas mais claras:

```haskell
participou :: Time -> Partida -> Bool
```

Isso comunica melhor a finalidade do valor do que utilizar `String` diretamente em todas as assinaturas.

---

## 2. Representação de `Resultado`

```haskell
data Resultado
  = Vitoria
  | Empate
  | Derrota
  deriving (Show, Eq)
```

`Resultado` foi definido como um tipo soma porque existem somente três resultados válidos.

Essa estrutura evita representar resultados com `String` ou `Int`, que permitiriam valores inválidos ou dependeriam de convenções externas.

Com o tipo soma, o compilador reconhece diretamente as três possibilidades e permite tratá-las com casamento de padrões.

---

## 3. Representação de `Partida`

```haskell
data Partida = Partida
  { rodada        :: Int
  , mandante      :: Time
  , golsMandante  :: Int
  , golsVisitante :: Int
  , visitante     :: Time
  } deriving (Show, Eq)
```

`Partida` foi modelada como record porque possui vários campos com significados diferentes, mas tipos repetidos.

Uma tupla teria esta estrutura:

```haskell
type Partida = (Int, Time, Int, Int, Time)
```

O problema é que seria necessário memorizar a posição de cada elemento. Além disso, trocar os gols do mandante e do visitante continuaria compilando, pois ambos são `Int`.

Com record, os campos possuem nomes:

```haskell
golsMandante partida
golsVisitante partida
```

Isso torna o código mais legível e reduz erros causados pela troca de posições.

O record também cria automaticamente as funções de acesso:

```haskell
rodada :: Partida -> Int
mandante :: Partida -> Time
golsMandante :: Partida -> Int
golsVisitante :: Partida -> Int
visitante :: Partida -> Time
```

---

## 4. Representação de `Linha`

```haskell
data Linha = Linha
  { timeLinha  :: Time
  , jogos      :: Int
  , vitorias   :: Int
  , empates    :: Int
  , derrotas   :: Int
  , golsPro    :: Int
  , golsContra :: Int
  } deriving (Show, Eq)
```

`Linha` também foi definida como record porque possui várias estatísticas do tipo `Int`.

Em uma tupla, seria difícil identificar qual posição representa jogos, vitórias, empates, derrotas, gols pró ou gols contra. Com campos nomeados, cada informação pode ser acessada diretamente.

Essa estrutura também prepara o projeto para a Camada 2, na qual as linhas da classificação serão calculadas e ordenadas.

---

## 5. Função `participou`

```haskell
participou :: Time -> Partida -> Bool
```

A função retorna `True` quando o time aparece como mandante ou visitante.

```haskell
participou nome partida =
  nome == mandante partida || nome == visitante partida
```

A implementação utiliza os acessores do record e centraliza a verificação de participação em uma única função.

---

## 6. Função `resultadoPara`

```haskell
resultadoPara :: Time -> Partida -> Maybe Resultado
```

Foi utilizado `Maybe Resultado` porque o resultado somente existe quando o time participou da partida.

A função retorna:

- `Just Vitoria`;
- `Just Empate`;
- `Just Derrota`;
- `Nothing`, caso o time não tenha participado.

O uso de `Maybe` representa a ausência de resultado de forma explícita, sem precisar usar valores especiais ou gerar exceções.

---

## 7. Função `times`

```haskell
times :: [Partida] -> [Time]
times = sort . nub . concatMap (\p -> [mandante p, visitante p])
```

A implementação foi construída em três etapas:

1. `concatMap` extrai mandante e visitante de cada partida;
2. `nub` remove os nomes repetidos;
3. `sort` coloca os nomes em ordem alfabética.

A composição de funções mantém cada transformação separada e deixa o fluxo do processamento claro.

---

## 8. Campeonato de teste

O campeonato foi mantido em `Dados.hs`, separado da lógica principal.

Essa decisão permite alterar os dados de teste sem modificar as funções definidas em `Tipos.hs`.

O campeonato possui uma quantidade maior de times e rodadas do que o mínimo solicitado. Além disso, os testes verificam automaticamente a organização das rodadas e os principais casos exigidos pelo enunciado.

---

## 9. Uso de `Show` e `Eq`

Os tipos derivam `Show` e `Eq`:

```haskell
deriving (Show, Eq)
```

`Show` permite exibir valores no GHCi e no terminal.

`Eq` permite comparar valores nos testes e utilizar operações como:

```haskell
partida `elem` campeonatoTeste
```

As implementações automáticas são suficientes para os objetivos da Camada 1.

---

## 10. Limitações estruturais

Apesar do uso de records, ainda é possível criar diretamente uma partida com valores inválidos:

```haskell
Partida 0 "" (-1) (-2) ""
```

Isso ocorre porque rodada e gols são representados por `Int`, os nomes são `String` e o construtor `Partida` está exportado.

Uma evolução possível seria ocultar o construtor e criar uma função validada:

```haskell
criarPartida
  :: Int
  -> Time
  -> Int
  -> Int
  -> Time
  -> Either ErroPartida Partida
```

Essa função poderia impedir gols negativos, rodadas inválidas, nomes vazios e partidas de um time contra ele mesmo.

Nesta camada, foi mantida a estrutura solicitada no enunciado, priorizando simplicidade, legibilidade e compatibilidade com as próximas etapas.