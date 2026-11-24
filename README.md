# PjBL2: Tabela de Classificação de Campeonato

Projeto desenvolvido em Haskell para calcular a classificação de um campeonato de futebol a partir dos resultados das partidas.

A implementação está organizada em três camadas:

1. modelagem dos tipos e dados do campeonato;
2. cálculo da classificação e das estatísticas;
3. leitura, validação e formatação dos resultados.

## Estrutura do projeto

```text
Tabela_Classificacao/
├── src/
│   ├── Tipos.hs
│   ├── Dados.hs
│   ├── Classificacao.hs
│   ├── Leitura.hs
│   └── Main.hs
├── tests/
│   └── Testes.hs
├── docs/
│   └── decisoes.md
└── README.md
```

### Arquivos principais

- `src/Tipos.hs`: tipos básicos do domínio e consultas sobre partidas;
- `src/Dados.hs`: campeonato de teste e entradas textuais;
- `src/Classificacao.hs`: classificação, pontuação e estatísticas;
- `src/Leitura.hs`: leitura, validação e formatação;
- `src/Main.hs`: demonstração das três camadas;
- `tests/Testes.hs`: testes automatizados;
- `docs/decisoes.md`: decisões estruturais e limitações conhecidas.

## Funcionalidades

O projeto implementa:

- representação de times, partidas, resultados e linhas da tabela;
- identificação do resultado de um time em uma partida;
- extração dos times sem repetição e em ordem alfabética;
- cálculo de pontos, vitórias, empates, derrotas e gols;
- classificação por múltiplos critérios de desempate;
- cálculo de saldo de gols e aproveitamento;
- classificação até uma rodada específica;
- identificação da maior goleada;
- cálculo da média de gols;
- leitura de partidas a partir de texto;
- validação de campos, números, rodadas, placares e nomes;
- detecção de times repetidos na mesma rodada;
- coleta de todos os erros de uma entrada;
- formatação da tabela para exibição no terminal.

## Campeonato de teste

O campeonato utilizado possui:

- 10 times;
- 7 rodadas;
- 35 partidas;
- 5 partidas por rodada;
- cada time jogando exatamente uma vez por rodada;
- empate em `0 x 0`;
- empate com gols;
- vitória por três ou mais gols de diferença;
- times empatados em pontos;
- aplicação dos critérios de desempate;
- Coritiba terminando como campeão.

## Requisitos

Para compilar e executar o projeto, é necessário ter instalado:

- GHC, o compilador de Haskell;
- GHCi, o ambiente interativo do GHC.

O projeto utiliza somente módulos da biblioteca padrão:

```haskell
Data.Char
Data.Either
Data.List
Data.Maybe
Data.Ord
Text.Read
```

Não é necessário instalar bibliotecas adicionais com Cabal ou Stack.

## Instalação do Haskell

A forma recomendada de instalar Haskell é por meio do GHCup.

### Windows

No Windows, abra o PowerShell e execute o instalador apresentado no site oficial do GHCup:

```text
https://www.haskell.org/ghcup/
```

Durante a instalação, selecione a instalação do GHC.

Após a instalação, feche e abra novamente o PowerShell.

Verifique se o GHC foi instalado:

```powershell
ghc --version
```

Verifique também o GHCi:

```powershell
ghci --version
```

Uma saída válida terá formato semelhante a:

```text
The Glorious Glasgow Haskell Compilation System, version 9.10.3
```

### Linux

No Linux, instale o GHCup com o comando indicado no site oficial:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Depois, reinicie o terminal ou carregue novamente as configurações do shell.

Verifique a instalação:

```bash
ghc --version
ghci --version
```

### macOS

No macOS, o GHCup também pode ser instalado pelo terminal:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Depois, verifique:

```bash
ghc --version
ghci --version
```

## Diretório de execução

Todos os comandos deste README devem ser executados na raiz do projeto.

Exemplo no Windows:

```powershell
cd "C:\Documentos\PUCPR\8° Período\Prolog\Tabela_Classificacao"
```

A raiz deve conter as pastas:

```text
src
tests
docs
```

## Executar o programa com GHCi

Na raiz do projeto, execute:

```powershell
ghci -isrc src/Main.hs
```

A opção:

```text
-isrc
```

adiciona a pasta `src` ao caminho de procura dos módulos.

Sem essa opção, o GHCi pode não encontrar os módulos:

```haskell
Tipos
Dados
Classificacao
Leitura
```

Depois que o GHCi carregar os módulos, execute:

```haskell
main
```

Para sair do GHCi:

```haskell
:quit
```

Também é possível usar:

```haskell
:q
```

## Executar os testes com GHCi

Na raiz do projeto, execute:

```powershell
ghci -isrc tests/Testes.hs
```

Depois:

```haskell
main
```

Os testes são separados por camada e exibem mensagens deste tipo:

```text
OK      resultadoPara aplicado ao mandante vencedor
OK      classificacao final completa conferida manualmente
OK      lerCampeonato sobre dados validos devolve Right
```

Se algum teste falhar, será exibido o valor obtido e o valor esperado:

```text
FALHOU  nome do teste
  obtido:   ...
  esperado: ...
```

Isso evita encadear várias ordenações independentes.

## Tratamento de erros

A leitura pode produzir os seguintes erros:

```haskell
CamposInvalidos
NumeroInvalido
PlacarNegativo
MesmoTime
TimeRepetidoNaRodada
RodadaInvalida
NomeVazio
```

As conversões numéricas utilizam:

```haskell
readMaybe
```

Isso evita exceções para entradas como:

```text
dois
2a
3.5
```

A leitura de uma partida utiliza `Either Erro Partida`. A leitura do campeonato inteiro utiliza `traverse`, interrompendo no primeiro erro.

A função `todosOsErros` permite obter um relatório com os erros encontrados nas diferentes linhas da entrada.

## Formato da entrada

Cada partida deve possuir cinco campos separados por ponto e vírgula:

```text
rodada;mandante;gols do mandante;gols do visitante;visitante
```

Exemplo:

```text
1;Coritiba;2;0;Rio Branco
```

Linhas vazias e linhas iniciadas por `#` são ignoradas:

```text
# rodada;mandante;gols mandante;gols visitante;visitante
1;Coritiba;2;0;Rio Branco
```

Espaços no início e no final dos campos são removidos durante a leitura.

## Testes implementados

### Camada 1

Os testes verificam:

- aplicação de `resultadoPara` ao mandante;
- aplicação de `resultadoPara` ao visitante;
- retorno de `Nothing` para um time ausente;
- empates;
- funcionamento de `participou`;
- lista de times sem repetições;
- ordem alfabética dos times;
- quantidade de times, rodadas e partidas;
- quantidade de partidas por rodada;
- participação única de cada time por rodada;
- empate em `0 x 0`;
- empate com gols;
- goleada por três ou mais gols.

### Camada 2

Os testes verificam:

- pontuação de vitória, empate e derrota;
- construção da linha de um time;
- pontos, saldo e aproveitamento;
- classificação completa conferida manualmente;
- Coritiba na primeira posição;
- desempate entre Paraná e Maringá;
- classificação após a terceira rodada;
- diferença entre classificação parcial e final;
- comportamento de `ateRodada`;
- `maiorGoleada [] == Nothing`;
- `mediaGols [] == Nothing`;
- diferença de gols da maior goleada;
- média de gols do campeonato.

### Camada 3

Os testes verificam:

- separação dos campos;
- preservação de campos vazios;
- leitura de uma partida válida;
- leitura do campeonato válido;
- campeonato vazio;
- comentários e linhas vazias;
- todos os construtores de `Erro`;
- time repetido como mandante;
- time repetido como visitante;
- coleta de vários erros;
- mensagens de erro;
- formatação da tabela vazia.

## Solução de problemas

### Erro: módulo não encontrado

Exemplo:

```text
Could not find module `Classificacao'
Could not find module `Dados'
Could not find module `Leitura'
Could not find module `Tipos'
```

Use `-isrc`:

```powershell
ghci -isrc src/Main.hs
```

Para os testes:

```powershell
ghci -isrc tests/Testes.hs
```

### Erro: variável não encontrada

Exemplo:

```text
Variable not in scope: diferencaDeGols
```

Confirme se `Tipos.hs` exporta a função:

```haskell
module Tipos
  ( Time
  , Resultado(..)
  , Partida(..)
  , Linha(..)
  , participou
  , resultadoPara
  , times
  , golsDaPartida
  , diferencaDeGols
  ) where
```

E se a função está definida:

```haskell
diferencaDeGols :: Partida -> Int
diferencaDeGols partida =
  abs (golsMandante partida - golsVisitante partida)
```

### O GHCi ainda mostra uma versão antiga

Dentro do GHCi, recarregue os módulos:

```haskell
:reload
```

Ou:

```haskell
:r
```

Se o problema continuar, saia e carregue novamente:

```haskell
:quit
```

```powershell
ghci -isrc tests/Testes.hs
```

### Caminho com espaços ou caracteres especiais

No PowerShell, utilize aspas ao entrar na pasta.


Depois execute normalmente:

```powershell
ghci -isrc tests/Testes.hs
```