module Main where

import Classificacao
import Data.List (nub)
import Dados
import Leitura
import Tipos



testar :: (Eq a, Show a) => String -> a -> a -> IO ()
testar nome obtido esperado
  | obtido == esperado =
      putStrLn ("OK      " ++ nome)
  | otherwise =
      error
        ( "FALHOU  "
            ++ nome
            ++ "\n  obtido:   "
            ++ show obtido
            ++ "\n  esperado: "
            ++ show esperado
        )

testarAproximado :: String -> Double -> Double -> IO ()
testarAproximado nome obtido esperado
  | abs (obtido - esperado) < 0.0001 =
      putStrLn ("OK      " ++ nome)
  | otherwise =
      error
        ( "FALHOU  "
            ++ nome
            ++ "\n  obtido:   "
            ++ show obtido
            ++ "\n  esperado: "
            ++ show esperado
        )

testarMaybeAproximado
  :: String
  -> Maybe Double
  -> Maybe Double
  -> IO ()
testarMaybeAproximado nome (Just obtido) (Just esperado) =
  testarAproximado nome obtido esperado
testarMaybeAproximado nome obtido esperado =
  testar nome obtido esperado

titulo :: String -> IO ()
titulo nome = do
  putStrLn ""
  putStrLn ("=== " ++ nome ++ " ===")



partidaTeste :: Partida
partidaTeste =
  Partida
    { rodada = 7
    , mandante = "Coritiba"
    , golsMandante = 3
    , golsVisitante = 0
    , visitante = "Operario"
    }

partidaEmpatada :: Partida
partidaEmpatada =
  Partida
    { rodada = 1
    , mandante = "Londrina"
    , golsMandante = 0
    , golsVisitante = 0
    , visitante = "Maringa"
    }



classificacaoFinalEsperada :: [Linha]
classificacaoFinalEsperada =
  [ Linha
      { timeLinha = "Coritiba"
      , jogos = 7
      , vitorias = 6
      , empates = 1
      , derrotas = 0
      , golsPro = 17
      , golsContra = 2
      }
  , Linha
      { timeLinha = "Athletico"
      , jogos = 7
      , vitorias = 5
      , empates = 2
      , derrotas = 0
      , golsPro = 13
      , golsContra = 4
      }
  , Linha
      { timeLinha = "Cianorte"
      , jogos = 7
      , vitorias = 3
      , empates = 3
      , derrotas = 1
      , golsPro = 6
      , golsContra = 5
      }
  , Linha
      { timeLinha = "Londrina"
      , jogos = 7
      , vitorias = 3
      , empates = 2
      , derrotas = 2
      , golsPro = 9
      , golsContra = 6
      }
  , Linha
      { timeLinha = "Cascavel"
      , jogos = 7
      , vitorias = 3
      , empates = 1
      , derrotas = 3
      , golsPro = 13
      , golsContra = 9
      }
  , Linha
      { timeLinha = "Parana"
      , jogos = 7
      , vitorias = 2
      , empates = 2
      , derrotas = 3
      , golsPro = 9
      , golsContra = 10
      }
  , Linha
      { timeLinha = "Maringa"
      , jogos = 7
      , vitorias = 2
      , empates = 2
      , derrotas = 3
      , golsPro = 6
      , golsContra = 10
      }
  , Linha
      { timeLinha = "Operario"
      , jogos = 7
      , vitorias = 2
      , empates = 1
      , derrotas = 4
      , golsPro = 5
      , golsContra = 9
      }
  , Linha
      { timeLinha = "Azuriz"
      , jogos = 7
      , vitorias = 1
      , empates = 2
      , derrotas = 4
      , golsPro = 6
      , golsContra = 15
      }
  , Linha
      { timeLinha = "Rio Branco"
      , jogos = 7
      , vitorias = 0
      , empates = 0
      , derrotas = 7
      , golsPro = 2
      , golsContra = 16
      }
  ]

classificacaoRodada3Esperada :: [Linha]
classificacaoRodada3Esperada =
  [ Linha "Coritiba" 3 2 1 0 6 1
  , Linha "Athletico" 3 2 1 0 6 2
  , Linha "Maringa" 3 2 1 0 4 2
  , Linha "Londrina" 3 1 2 0 2 1
  , Linha "Cascavel" 3 1 1 1 7 4
  , Linha "Parana" 3 1 1 1 4 3
  , Linha "Cianorte" 3 1 1 1 3 4
  , Linha "Operario" 3 0 1 2 2 5
  , Linha "Azuriz" 3 0 1 2 1 8
  , Linha "Rio Branco" 3 0 0 3 1 6
  ]



testesCamada1 :: IO ()
testesCamada1 = do
  titulo "Camada 1 - Tipos e consultas basicas"

  testar
    "record Partida com campos nomeados"
    ( rodada partidaTeste
    , mandante partidaTeste
    , golsMandante partidaTeste
    , golsVisitante partidaTeste
    , visitante partidaTeste
    )
    (7, "Coritiba", 3, 0, "Operario")

  testar
    "resultadoPara aplicado ao mandante vencedor"
    (resultadoPara "Coritiba" partidaTeste)
    (Just Vitoria)

  testar
    "resultadoPara aplicado ao visitante derrotado"
    (resultadoPara "Operario" partidaTeste)
    (Just Derrota)

  testar
    "resultadoPara aplicado a time que nao participou"
    (resultadoPara "Parana" partidaTeste)
    Nothing

  testar
    "resultadoPara reconhece empate para o mandante"
    (resultadoPara "Londrina" partidaEmpatada)
    (Just Empate)

  testar
    "resultadoPara reconhece empate para o visitante"
    (resultadoPara "Maringa" partidaEmpatada)
    (Just Empate)

  testar
    "participou como mandante"
    (participou "Coritiba" partidaTeste)
    True

  testar
    "participou como visitante"
    (participou "Operario" partidaTeste)
    True

  testar
    "nao participou"
    (participou "Parana" partidaTeste)
    False

  testar
    "times sem repeticao e em ordem alfabetica"
    (times campeonatoTeste)
    [ "Athletico"
    , "Azuriz"
    , "Cascavel"
    , "Cianorte"
    , "Coritiba"
    , "Londrina"
    , "Maringa"
    , "Operario"
    , "Parana"
    , "Rio Branco"
    ]

  testar
    "times sobre lista vazia"
    (times [])
    []

  testar
    "lista de times nao possui repeticoes"
    (length (times campeonatoTeste))
    (length (nub (times campeonatoTeste)))

  testar
    "campeonato possui 10 times"
    (length (times campeonatoTeste))
    10

  testar
    "campeonato possui 7 rodadas"
    (nub (map rodada campeonatoTeste))
    [1 .. 7]

  testar
    "campeonato possui 35 partidas"
    (length campeonatoTeste)
    35

  testar
    "cada rodada possui 5 partidas"
    [ length
        (filter ((== numero) . rodada) campeonatoTeste)
    | numero <- [1 .. 7]
    ]
    (replicate 7 5)

  testar
    "cada time joga exatamente uma vez por rodada"
    [ length
        [ partida
        | partida <- campeonatoTeste
        , rodada partida == numero
        , participou time partida
        ]
    | numero <- [1 .. 7]
    , time <- times campeonatoTeste
    ]
    (replicate 70 1)

  testar
    "campeonato possui empate em zero a zero"
    ( any
        (\partida ->
          golsMandante partida == 0
            && golsVisitante partida == 0
        )
        campeonatoTeste
    )
    True

  testar
    "campeonato possui empate com gols"
    ( any
        (\partida ->
          golsMandante partida == golsVisitante partida
            && golsMandante partida > 0
        )
        campeonatoTeste
    )
    True

  testar
    "campeonato possui vitoria por tres ou mais gols"
    (any ((>= 3) . diferencaDeGols) campeonatoTeste)
    True

  testar
    "campeonato possui goleada por quatro gols"
    (any ((== 4) . diferencaDeGols) campeonatoTeste)
    True



testesCamada2 :: IO ()
testesCamada2 = do
  titulo "Camada 2 - Classificacao e estatisticas"

  testar
    "pontos de uma vitoria"
    (pontos Vitoria)
    3

  testar
    "pontos de um empate"
    (pontos Empate)
    1

  testar
    "pontos de uma derrota"
    (pontos Derrota)
    0

  testar
    "linha completa do Coritiba"
    (linhaDoTime campeonatoTeste "Coritiba")
    (Linha "Coritiba" 7 6 1 0 17 2)

  testar
    "linha de time sem partidas fica zerada"
    (linhaDoTime campeonatoTeste "Time Inexistente")
    (Linha "Time Inexistente" 0 0 0 0 0 0)

  testar
    "pontos da linha do Coritiba"
    (pontosLinha (linhaDoTime campeonatoTeste "Coritiba"))
    19

  testar
    "saldo da linha do Coritiba"
    (saldo (linhaDoTime campeonatoTeste "Coritiba"))
    15

  testarAproximado
    "aproveitamento do Coritiba"
    (aproveitamento (linhaDoTime campeonatoTeste "Coritiba"))
    (100.0 * 19.0 / 21.0)

  testarAproximado
    "aproveitamento de time sem partidas"
    (aproveitamento (Linha "Sem Jogos" 0 0 0 0 0 0))
    0.0

  testar
    "classificacao final completa conferida manualmente"
    (classificacao campeonatoTeste)
    classificacaoFinalEsperada

  testar
    "Coritiba e o primeiro colocado"
    (map timeLinha (take 1 (classificacao campeonatoTeste)))
    ["Coritiba"]

  testar
    "Parana e Maringa terminam empatados em pontos"
    ( pontosLinha (linhaDoTime campeonatoTeste "Parana")
    , pontosLinha (linhaDoTime campeonatoTeste "Maringa")
    )
    (8, 8)

  testar
    "desempate entre Parana e Maringa ocorre pelo saldo"
    ( saldo (linhaDoTime campeonatoTeste "Parana")
    , saldo (linhaDoTime campeonatoTeste "Maringa")
    )
    (-1, -4)

  testar
    "Parana fica acima do Maringa na classificacao"
    ( map timeLinha
        ( filter
            (\linha ->
              timeLinha linha == "Parana"
                || timeLinha linha == "Maringa"
            )
            (classificacao campeonatoTeste)
        )
    )
    ["Parana", "Maringa"]

  testar
    "ateRodada 3 inclui somente as tres primeiras rodadas"
    (nub (map rodada (ateRodada 3 campeonatoTeste)))
    [1, 2, 3]

  testar
    "ateRodada 3 possui 15 partidas"
    (length (ateRodada 3 campeonatoTeste))
    15

  testar
    "classificacao apos a terceira rodada"
    (classificacao (ateRodada 3 campeonatoTeste))
    classificacaoRodada3Esperada

  testar
    "classificacao da terceira rodada difere da final"
    ( classificacao (ateRodada 3 campeonatoTeste)
        /= classificacao campeonatoTeste
    )
    True

  testar
    "ateRodada zero devolve lista vazia"
    (ateRodada 0 campeonatoTeste)
    []

  testar
    "ateRodada acima da ultima devolve campeonato completo"
    (ateRodada 100 campeonatoTeste)
    campeonatoTeste

  testar
    "maiorGoleada de lista vazia devolve Nothing"
    (maiorGoleada [])
    Nothing

  testar
    "mediaGols de lista vazia devolve Nothing"
    (mediaGols [])
    Nothing

  testar
    "maior goleada possui diferenca de quatro gols"
    (fmap diferencaDeGols (maiorGoleada campeonatoTeste))
    (Just 4)

  testar
    "maiorGoleada mantem a primeira em caso de empate"
    (maiorGoleada campeonatoTeste)
    (Just (Partida 3 "Azuriz" 0 4 "Cascavel"))

  testarMaybeAproximado
    "media de gols do campeonato"
    (mediaGols campeonatoTeste)
    (Just (86.0 / 35.0))



testesCamada3 :: IO ()
testesCamada3 = do
  titulo "Camada 3 - Leitura, validacao e saida"

  testar
    "separar linha valida"
    (separar ';' "1;Coritiba;2;0;Operario")
    ["1", "Coritiba", "2", "0", "Operario"]

  testar
    "separar preserva campo vazio"
    (separar ';' "1;;2;0;Operario")
    ["1", "", "2", "0", "Operario"]

  testar
    "lerPartida valida"
    (lerPartida 1 "7;Coritiba;3;0;Operario")
    (Right partidaTeste)

  testar
    "lerCampeonato sobre dados validos devolve Right"
    (lerCampeonato dadosCampeonato)
    (Right campeonatoTeste)

  testar
    "lerCampeonato vazio devolve Right com lista vazia"
    (lerCampeonato "")
    (Right [])

  testar
    "lerCampeonato ignora comentario e linha vazia"
    ( lerCampeonato
        ( unlines
            [ "# comentario"
            , ""
            , "1;Coritiba;2;0;Operario"
            ]
        )
    )
    (Right [Partida 1 "Coritiba" 2 0 "Operario"])

  -- CamposInvalidos
  testar
    "erro CamposInvalidos"
    (lerPartida 10 "1;Coritiba;2")
    (Left (CamposInvalidos 10 3))

  -- NumeroInvalido
  testar
    "erro NumeroInvalido na rodada"
    (lerPartida 11 "dois;Coritiba;2;0;Operario")
    (Left (NumeroInvalido 11 "dois"))

  testar
    "erro NumeroInvalido no placar"
    (lerPartida 12 "1;Coritiba;dois;0;Operario")
    (Left (NumeroInvalido 12 "dois"))

  -- PlacarNegativo
  testar
    "erro PlacarNegativo para mandante"
    (lerPartida 13 "1;Coritiba;-1;0;Operario")
    (Left (PlacarNegativo 13 (-1)))

  testar
    "erro PlacarNegativo para visitante"
    (lerPartida 14 "1;Coritiba;1;-2;Operario")
    (Left (PlacarNegativo 14 (-2)))

  -- MesmoTime
  testar
    "erro MesmoTime"
    (lerPartida 15 "1;Coritiba;1;0;Coritiba")
    (Left (MesmoTime 15 "Coritiba"))

  -- RodadaInvalida
  testar
    "erro RodadaInvalida com rodada zero"
    (lerPartida 16 "0;Coritiba;1;0;Operario")
    (Left (RodadaInvalida 16 0))

  testar
    "erro RodadaInvalida com rodada negativa"
    (lerPartida 17 "-1;Coritiba;1;0;Operario")
    (Left (RodadaInvalida 17 (-1)))

  -- NomeVazio
  testar
    "erro NomeVazio no mandante"
    (lerPartida 18 "1;;1;0;Operario")
    (Left (NomeVazio 18))

  testar
    "erro NomeVazio no visitante"
    (lerPartida 19 "1;Coritiba;1;0;")
    (Left (NomeVazio 19))

  -- TimeRepetidoNaRodada
  testar
    "erro TimeRepetidoNaRodada para mandante"
    ( lerCampeonato
        ( unlines
            [ "1;Coritiba;1;0;Operario"
            , "1;Coritiba;2;0;Parana"
            ]
        )
    )
    (Left (TimeRepetidoNaRodada 1 "Coritiba"))

  testar
    "erro TimeRepetidoNaRodada para visitante"
    ( lerCampeonato
        ( unlines
            [ "1;Coritiba;1;0;Operario"
            , "1;Parana;2;0;Operario"
            ]
        )
    )
    (Left (TimeRepetidoNaRodada 1 "Operario"))

  testar
    "mesmo time pode jogar novamente em outra rodada"
    ( lerCampeonato
        ( unlines
            [ "1;Coritiba;1;0;Operario"
            , "2;Coritiba;2;0;Parana"
            ]
        )
    )
    ( Right
        [ Partida 1 "Coritiba" 1 0 "Operario"
        , Partida 2 "Coritiba" 2 0 "Parana"
        ]
    )

  testar
    "todosOsErros coleta pelo menos tres linhas invalidas"
    ( todosOsErros
        ( unlines
            [ "x;Coritiba;1;0;Operario"
            , "1;Athletico;-2;0;Azuriz"
            , "2;Parana;1;0;Parana"
            , "3;Londrina;dois;0;Maringa"
            ]
        )
    )
    [ NumeroInvalido 1 "x"
    , PlacarNegativo 2 (-2)
    , MesmoTime 3 "Parana"
    , NumeroInvalido 4 "dois"
    ]

  testar
    "todosOsErros inclui repeticao entre linhas validas"
    ( todosOsErros
        ( unlines
            [ "1;Coritiba;1;0;Operario"
            , "1;Coritiba;2;0;Parana"
            , "2;Londrina;dois;0;Maringa"
            ]
        )
    )
    [ NumeroInvalido 3 "dois"
    , TimeRepetidoNaRodada 1 "Coritiba"
    ]

  testar
    "todosOsErros funciona sobre dadosComErros"
    (todosOsErros dadosComErros)
    [ CamposInvalidos 3 4
    , NumeroInvalido 4 "dois"
    , PlacarNegativo 5 (-1)
    , MesmoTime 6 "Parana"
    , TimeRepetidoNaRodada 1 "Coritiba"
    ]

  testar
    "descrever CamposInvalidos"
    (descreverErro (CamposInvalidos 4 3))
    "linha 4: esperados 5 campos separados por ';', encontrados 3"

  testar
    "descrever NumeroInvalido"
    (descreverErro (NumeroInvalido 5 "dois"))
    "linha 5: 'dois' nao e um numero valido"

  testar
    "descrever PlacarNegativo"
    (descreverErro (PlacarNegativo 6 (-2)))
    "linha 6: placar negativo (-2)"

  testar
    "descrever MesmoTime"
    (descreverErro (MesmoTime 7 "Coritiba"))
    "linha 7: Coritiba nao pode jogar contra si mesmo"

  testar
    "descrever TimeRepetidoNaRodada"
    (descreverErro (TimeRepetidoNaRodada 2 "Coritiba"))
    "rodada 2: Coritiba joga mais de uma vez"

  testar
    "descrever RodadaInvalida"
    (descreverErro (RodadaInvalida 8 0))
    "linha 8: rodada invalida (0)"

  testar
    "descrever NomeVazio"
    (descreverErro (NomeVazio 9))
    "linha 9: nome de time vazio"

  testar
    "tabelaFormatada vazia ainda possui cabecalho"
    (tabelaFormatada [])
    "Pos  Time    P    J    V    E    D   SG\n"



main :: IO ()
main = do
  putStrLn "========================================"
  putStrLn " Iniciando testes"
  putStrLn "========================================"

  testesCamada1
  testesCamada2
  testesCamada3

  putStrLn ""
  putStrLn "========================================"
  putStrLn " TODOS OS TESTES FORAM CONCLUIDOS"
  putStrLn "========================================"