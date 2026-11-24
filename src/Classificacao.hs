module Classificacao
  ( pontos
  , linhaDoTime
  , pontosLinha
  , saldo
  , aproveitamento
  , classificacao
  , ateRodada
  , maiorGoleada
  , mediaGols
  ) where

import Data.List (sortBy)
import Data.Ord (Down (..), comparing)
import Tipos

pontos :: Resultado -> Int
pontos Vitoria = 3
pontos Empate  = 1
pontos Derrota = 0


linhaDoTime :: [Partida] -> Time -> Linha
linhaDoTime partidas time =
  foldl (acumular time) (linhaVazia time) (filter (participou time) partidas)

linhaVazia :: Time -> Linha
linhaVazia time = Linha
  { timeLinha  = time
  , jogos      = 0
  , vitorias   = 0
  , empates    = 0
  , derrotas   = 0
  , golsPro    = 0
  , golsContra = 0
  }

acumular :: Time -> Linha -> Partida -> Linha
acumular time linha partida =
  case resultadoPara time partida of
    Nothing -> linha
    Just resultado -> linha
      { jogos      = jogos linha + 1
      , vitorias   = vitorias linha + contar (resultado == Vitoria)
      , empates    = empates linha + contar (resultado == Empate)
      , derrotas   = derrotas linha + contar (resultado == Derrota)
      , golsPro    = golsPro linha + feitos
      , golsContra = golsContra linha + sofridos
      }
  where
    (feitos, sofridos)
      | time == mandante partida = (golsMandante partida, golsVisitante partida)
      | otherwise                = (golsVisitante partida, golsMandante partida)

contar :: Bool -> Int
contar condicao = if condicao then 1 else 0


pontosLinha :: Linha -> Int
pontosLinha linha =
    pontos Vitoria * vitorias linha
  + pontos Empate  * empates linha
  + pontos Derrota * derrotas linha


saldo :: Linha -> Int
saldo linha = golsPro linha - golsContra linha


aproveitamento :: Linha -> Double
aproveitamento linha
  | disputados == 0 = 0
  | otherwise       = 100 * fromIntegral (pontosLinha linha) / fromIntegral disputados
  where
    disputados = pontos Vitoria * jogos linha


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


ateRodada :: Int -> [Partida] -> [Partida]
ateRodada n = filter ((<= n) . rodada)


maiorGoleada :: [Partida] -> Maybe Partida
maiorGoleada = foldl escolher Nothing
  where
    escolher Nothing partida = Just partida
    escolher (Just atual) partida
      | diferenca partida > diferenca atual = Just partida
      | otherwise                           = Just atual

diferenca :: Partida -> Int
diferenca partida = abs (golsMandante partida - golsVisitante partida)


mediaGols :: [Partida] -> Maybe Double
mediaGols [] = Nothing
mediaGols partidas =
  Just (fromIntegral (sum (map golsNaPartida partidas))
          / fromIntegral (length partidas))

golsNaPartida :: Partida -> Int
golsNaPartida partida = golsMandante partida + golsVisitante partida
