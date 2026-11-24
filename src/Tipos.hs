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

import Data.List (nub, sort)

type Time = String

data Resultado
  = Vitoria
  | Empate
  | Derrota
  deriving (Show, Eq, Ord)

data Partida = Partida
  { rodada        :: Int
  , mandante      :: Time
  , golsMandante  :: Int
  , golsVisitante :: Int
  , visitante     :: Time
  } deriving (Show, Eq)

data Linha = Linha
  { timeLinha  :: Time
  , jogos      :: Int
  , vitorias   :: Int
  , empates    :: Int
  , derrotas   :: Int
  , golsPro    :: Int
  , golsContra :: Int
  } deriving (Show, Eq)

participou :: Time -> Partida -> Bool
participou nome partida =
  nome == mandante partida || nome == visitante partida

resultadoPara :: Time -> Partida -> Maybe Resultado
resultadoPara nome partida
  | nome == mandante partida =
      Just (compararPlacar (golsMandante partida) (golsVisitante partida))
  | nome == visitante partida =
      Just (compararPlacar (golsVisitante partida) (golsMandante partida))
  | otherwise = Nothing

compararPlacar :: Int -> Int -> Resultado
compararPlacar golsDoTime golsDoAdversario
  | golsDoTime > golsDoAdversario = Vitoria
  | golsDoTime == golsDoAdversario = Empate
  | otherwise = Derrota

times :: [Partida] -> [Time]
times = sort . nub . concatMap nomes
  where
    nomes partida = [mandante partida, visitante partida]

golsDaPartida :: Partida -> Int
golsDaPartida partida =
  golsMandante partida + golsVisitante partida

diferencaDeGols :: Partida -> Int
diferencaDeGols partida =
  abs (golsMandante partida - golsVisitante partida)