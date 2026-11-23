module Main where

import Data.List (nub)
import Dados
import Tipos

testar :: (Eq a, Show a) => String -> a -> a -> IO ()
testar nome obtido esperado
  | obtido == esperado = putStrLn ("OK      " ++ nome)
  | otherwise = error
      ("FALHOU  " ++ nome ++ ": obtido " ++ show obtido
        ++ ", esperado " ++ show esperado)

pontosDoTime :: Time -> [Partida] -> Int
pontosDoTime time = sum . map pontos . filter (participou time)
  where
    pontos partida =
      case resultadoPara time partida of
        Just Vitoria -> 3
        Just Empate  -> 1
        Just Derrota -> 0
        Nothing      -> 0

saldoDoTime :: Time -> [Partida] -> Int
saldoDoTime time = sum . map saldo . filter (participou time)
  where
    saldo partida
      | time == mandante partida = golsMandante partida - golsVisitante partida
      | otherwise = golsVisitante partida - golsMandante partida

main :: IO ()
main = do
  testar "record Partida com campos nomeados"
    ( rodada partidaFinalCoritiba
    , mandante partidaFinalCoritiba
    , golsMandante partidaFinalCoritiba
    , golsVisitante partidaFinalCoritiba
    , visitante partidaFinalCoritiba
    )
    (7, "Coritiba", 3, 0, "Operario")
  testar "10 times" (length (times campeonatoTeste)) 10
  testar "7 rodadas" (nub (map rodada campeonatoTeste)) [1..7]
  testar "35 partidas" (length campeonatoTeste) 35
  testar "5 partidas por rodada"
    [length (filter ((== numero) . rodada) campeonatoTeste) | numero <- [1..7]]
    (replicate 7 5)
  testar "cada time joga uma vez por rodada"
    [ length [p | p <- campeonatoTeste, rodada p == numero, participou time p]
    | numero <- [1..7], time <- times campeonatoTeste
    ]
    (replicate 70 1)
  testar "empate em zero a zero"
    (partidaEmpateSemGols `elem` campeonatoTeste) True
  testar "goleada por quatro gols"
    (partidaMaiorGoleada `elem` campeonatoTeste) True
  testar "Coritiba vence a ultima partida"
    (resultadoPara "Coritiba" partidaFinalCoritiba) (Just Vitoria)
  testar "time ausente retorna Nothing"
    (resultadoPara "Parana" partidaFinalCoritiba) Nothing
  testar "Coritiba campeao com 19 pontos"
    (pontosDoTime "Coritiba" campeonatoTeste) 19
  testar "Parana e Maringa empatados com 8 pontos"
    ( pontosDoTime "Parana" campeonatoTeste
    , pontosDoTime "Maringa" campeonatoTeste
    )
    (8, 8)
  testar "desempate depende do saldo"
    ( saldoDoTime "Parana" campeonatoTeste
    , saldoDoTime "Maringa" campeonatoTeste
    )
    (-1, -4)
