module Leitura
  ( Erro(..)
  ) where

import Tipos


data Erro
  = CamposInvalidos Int Int
  | NumeroInvalido Int String
  | PlacarNegativo Int Int
  | MesmoTime Int Time
  | TimeRepetidoNaRodada Int Time
  | RodadaInvalida Int Int
  | NomeVazio Int
  deriving (Show, Eq)


separar :: Char -> String -> [String]
separar separador = foldr passo [""]
  where
    passo caractere campos
      | caractere == separador = "" : campos
      | otherwise =
          case campos of
            (atual : resto) -> (caractere : atual) : resto
            []              -> [[caractere]]


