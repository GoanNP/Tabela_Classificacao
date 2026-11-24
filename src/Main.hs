module Main where

import Classificacao
import Dados
import Leitura
import Tipos


main :: IO ()
main = do
  case lerCampeonato dadosCampeonato of
    Left erro -> putStrLn ("Erro na leitura: " ++ descreverErro erro)
    Right partidas -> do
      putStrLn "== Tabela final =="
      putStr (tabelaFormatada (classificacao partidas))

      putStrLn "\n== Tabela apos a rodada 3 =="
      putStr (tabelaFormatada (classificacao (ateRodada 3 partidas)))

      putStrLn "\n== Estatisticas =="
      putStrLn ("Maior goleada: " ++ maybe "nenhuma partida" descreverPartida (maiorGoleada partidas))
      putStrLn ("Media de gols por partida: " ++ maybe "nenhuma partida" duasCasas (mediaGols partidas))
      putStrLn "Aproveitamento por time:"
      mapM_ (putStrLn . aproveitamentoDe) (classificacao partidas)

  putStrLn "\n== Entrada com erros =="
  putStrLn (either (("Primeiro erro: " ++) . descreverErro) (const "Nenhum erro") (lerCampeonato dadosComErros))
  putStrLn "Todos os erros:"
  mapM_ (putStrLn . ("  - " ++) . descreverErro) (todosOsErros dadosComErros)
  where
    descreverPartida p =
      mandante p ++ " " ++ show (golsMandante p) ++ " x " ++ show (golsVisitante p)
        ++ " " ++ visitante p ++ " (rodada " ++ show (rodada p) ++ ")"
    duasCasas x = show (fromIntegral (round (x * 100) :: Int) / 100 :: Double)
    aproveitamentoDe l = "  " ++ timeLinha l ++ ": " ++ duasCasas (aproveitamento l) ++ "%"