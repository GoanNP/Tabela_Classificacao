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


# Decisões estruturais da Camada 2
 
## 1. Módulo `Classificacao`
 
A Camada 2 foi colocada em um módulo próprio, `Classificacao.hs`, que importa `Tipos`.
 
Assim, cada camada fica em um arquivo separado: `Tipos` define os dados e as funções básicas sobre uma partida, e `Classificacao` calcula a tabela e as estatísticas a partir de uma lista de partidas.
 
O módulo exporta somente as funções pedidas no enunciado. As funções auxiliares (`linhaVazia`, `acumular`, `contar`, `criterioTabela`, `diferenca` e `golsNaPartida`) ficam internas.
 
---
 
## 2. Funções de ordem superior em vez de recursão explícita
 
O enunciado proíbe recursão explícita nesta camada. Todas as funções usam padrões de recursão já nomeados:
 
| Recurso exigido | Onde é usado |
|---|---|
| `map` | `classificacao`, `mediaGols` |
| `filter` | `linhaDoTime`, `ateRodada` |
| dobra (`foldl`) | `linhaDoTime`, `maiorGoleada` |
| composição `(.)` | `ateRodada`, `criterioTabela` |
| `sortBy` com `comparing` e `Down` | `classificacao` |
 
Usar a função com nome mostra, já na leitura, o que é feito com a lista: `filter` seleciona, `map` transforma, `foldl` acumula e `sortBy` ordena.
 
---
 
## 3. Função `pontos`
 
```haskell
pontos :: Resultado -> Int
pontos Vitoria = 3
pontos Empate  = 1
pontos Derrota = 0
```
 
A função usa casamento de padrões sobre o tipo soma `Resultado`. Como os três construtores são tratados, o `-Wall` não emite aviso de padrões incompletos.
 
Essa é a única função que conhece o valor de cada resultado. `pontosLinha` e `aproveitamento` reutilizam `pontos`; assim, se a regra de pontuação mudar, só esta função precisa ser alterada.
 
---
 
## 4. Função `linhaDoTime`
 
```haskell
linhaDoTime :: [Partida] -> Time -> Linha
linhaDoTime partidas time =
  foldl (acumular time) (linhaVazia time) (filter (participou time) partidas)
```
 
A linha é construída em duas etapas:
 
1. `filter (participou time)` mantém somente as partidas do time;
2. `foldl` parte de `linhaVazia time`, com todos os campos zerados, e aplica `acumular` a cada partida.
`acumular` utiliza `resultadoPara`, da Camada 1, para descobrir o resultado e soma 1 ao contador correspondente por meio do auxiliar `contar :: Bool -> Int`. Os gols feitos e sofridos dependem de o time ser mandante ou visitante.
 
O caso `Nothing` de `resultadoPara` devolve a linha sem alteração. Por causa do `filter`, ele nunca ocorre na prática, mas precisa estar presente para que o `case` seja exaustivo.
 
`foldl` foi escolhido porque a linha é acumulada da esquerda para a direita, partida a partida, como uma tabela é atualizada ao longo do campeonato. Uma lista vazia resulta na própria `linhaVazia`, sem nenhum caso especial.
 
---
 
## 5. Funções `pontosLinha` e `saldo`
 
```haskell
pontosLinha :: Linha -> Int
saldo       :: Linha -> Int
```
 
Pontos e saldo não foram adicionados como campos de `Linha`, mas calculados a partir dos campos existentes.
 
Se fossem campos, seria possível construir uma linha em que os pontos não correspondem às vitórias e aos empates. Calculados, eles são sempre coerentes com o restante da linha.
 
---
 
## 6. Função `aproveitamento`
 
```haskell
aproveitamento :: Linha -> Double
aproveitamento linha
  | disputados == 0 = 0
  | otherwise       = 100 * fromIntegral (pontosLinha linha) / fromIntegral disputados
  where
    disputados = pontos Vitoria * jogos linha
```
 
O resultado é um percentual, entre 0 e 100.
 
Haskell não converte tipos numéricos automaticamente: `div` trunca o resultado, e `/` exige um tipo fracionário. Por isso, os dois `Int` são convertidos com `fromIntegral` antes da divisão. Com `div`, um empate em um jogo daria 0% em vez de 33,33%.
 
A guarda `disputados == 0` trata o time que não jogou. Sem ela, a divisão 0 / 0 em `Double` resultaria em `NaN`.
 
---
 
## 7. Função `classificacao`
 
```haskell
classificacao :: [Partida] -> [Linha]
classificacao partidas =
  sortBy criterioTabela (map (linhaDoTime partidas) (times partidas))
 
criterioTabela :: Linha -> Linha -> Ordering
criterioTabela =
     comparing (Down . pontosLinha)
  <> comparing (Down . vitorias)
  <> comparing (Down . saldo)
  <> comparing (Down . golsPro)
  <> comparing timeLinha
```
 
`map` gera uma linha para cada time, e `sortBy` ordena todas de uma vez.
 
Os critérios de desempate formam uma única função de comparação. Como `Ordering` é um `Monoid`, o operador `<>` só passa para o critério seguinte quando o anterior resulta em `EQ`.
 
Encadear vários `sortBy`, um para cada critério, seria frágil: o resultado dependeria da ordem das chamadas e da estabilidade da ordenação. Com uma única comparação, a prioridade dos critérios aparece diretamente no código.
 
`Down` inverte a ordem dos critérios em que o maior valor fica à frente. O nome do time, em ordem alfabética, é o último critério e garante que a tabela tenha sempre uma ordem única, mesmo quando todos os outros critérios empatam.
 
---
 
## 8. Função `ateRodada`
 
```haskell
ateRodada :: Int -> [Partida] -> [Partida]
ateRodada n = filter ((<= n) . rodada)
```
 
A função compõe `rodada` com a seção `(<= n)` e utiliza o resultado como predicado do `filter`. A rodada informada é incluída.
 
`ateRodada` apenas seleciona partidas e não calcula nada. A tabela em um momento intermediário é obtida pela composição das duas funções:
 
```haskell
classificacao (ateRodada 3 campeonatoTeste)
```
 
Rodadas fora do intervalo não geram erro: 0 ou um valor negativo resulta em `[]`, e um valor maior que a última rodada resulta no campeonato inteiro.
 
---
 
## 9. Função `maiorGoleada`
 
```haskell
maiorGoleada :: [Partida] -> Maybe Partida
maiorGoleada = foldl escolher Nothing
```
 
`maximumBy` é uma função parcial: gera uma exceção quando recebe uma lista vazia. Por isso, a maior goleada é obtida com `foldl` e um acumulador do tipo `Maybe Partida`.
 
O acumulador começa em `Nothing` e passa a `Just` na primeira partida. Assim, a lista vazia resulta em `Nothing` sem nenhum tratamento adicional.
 
A diferença é calculada com `abs`, de modo que uma goleada do visitante conta da mesma forma que uma do mandante.
 
Em caso de empate na diferença, a comparação estrita (`>`) mantém a primeira partida da lista. No campeonato de teste, Azuriz 0×4 Cascavel (rodada 3) e Coritiba 4×0 Maringá (rodada 5) têm diferença 4, e o resultado é a da rodada 3.
 
---
 
## 10. Função `mediaGols`
 
```haskell
mediaGols :: [Partida] -> Maybe Double
mediaGols [] = Nothing
mediaGols partidas =
  Just (fromIntegral (sum (map golsNaPartida partidas))
          / fromIntegral (length partidas))
```
 
A lista vazia é tratada por casamento de padrões. O segundo caso não chama `mediaGols` novamente; portanto, não há recursão explícita.
 
Como em `aproveitamento`, a soma e a quantidade são convertidas com `fromIntegral` antes da divisão.
 
---
 
## 11. Uso de `Maybe` nas estatísticas
 
`maiorGoleada` e `mediaGols` retornam `Maybe` porque, em um campeonato sem partidas, não existe maior goleada nem média.
 
Com `Maybe`, a ausência de resultado faz parte do tipo, e quem chama a função é obrigado a tratar o caso `Nothing`. Isso evita funções parciais como `head`, `maximum` e `foldr1`, que encerram o programa com uma exceção quando recebem uma lista vazia.
 
`aproveitamento` é diferente: o enunciado define o valor 0 para um time que não jogou. Por isso, ela retorna `Double` diretamente.

## 12. Limitações
 
`classificacao` executa `linhaDoTime` uma vez para cada time, e cada execução percorre todas as partidas. O custo é proporcional ao número de times multiplicado pelo número de partidas, o que é suficiente para o tamanho de um campeonato.
 
A tabela inclui somente os times que aparecem em pelo menos uma partida, porque a lista de times vem de `times`. Um time sem jogos não aparece na classificação.
 
As funções confiam que as partidas são válidas. Gols negativos ou partidas de um time contra ele mesmo, mencionados nas limitações da Camada 1, continuam possíveis e serão tratados na leitura da entrada, na Camada 3.