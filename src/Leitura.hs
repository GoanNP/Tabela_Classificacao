
module Leitura
  ( Erro(..)
  , separar
  , lerPartida
  , lerCampeonato
  , todosOsErros
  , tabelaFormatada
  , descreverErro
  ) where

import Classificacao (pontosLinha, saldo)
import Data.Char (isSpace)
import Data.Either (lefts, rights)
import Data.List (dropWhileEnd)
import Data.Maybe (listToMaybe)
import Text.Read (readMaybe)
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


lerPartida :: Int -> String -> Either Erro Partida
lerPartida linha texto = do
  (r, m, gm, gv, v) <- cincoCampos linha (map removerEspacos (separar ';' texto))
  numeroRodada <- lerNumero linha r
  golsM <- lerNumero linha gm
  golsV <- lerNumero linha gv
  if numeroRodada <= 0 then Left (RodadaInvalida linha numeroRodada) else Right ()
  if null m then Left (NomeVazio linha) else Right ()
  if null v then Left (NomeVazio linha) else Right ()
  if golsM < 0 then Left (PlacarNegativo linha golsM) else Right ()
  if golsV < 0 then Left (PlacarNegativo linha golsV) else Right ()
  if m == v then Left (MesmoTime linha m) else Right ()
  Right (Partida numeroRodada m golsM golsV v)

cincoCampos :: Int -> [String] -> Either Erro (String, String, String, String, String)
cincoCampos _ [r, m, gm, gv, v] = Right (r, m, gm, gv, v)
cincoCampos linha campos        = Left (CamposInvalidos linha (length campos))

lerNumero :: Int -> String -> Either Erro Int
lerNumero linha campo = maybe (Left (NumeroInvalido linha campo)) Right (readMaybe campo)

removerEspacos :: String -> String
removerEspacos = dropWhileEnd isSpace . dropWhile isSpace

lerCampeonato :: String -> Either Erro [Partida]
lerCampeonato texto = do
  partidas <- traverse (uncurry lerPartida) (linhasRelevantes texto)
  maybe (Right partidas) Left (listToMaybe (timesRepetidos partidas))


todosOsErros :: String -> [Erro]
todosOsErros texto = lefts lidas ++ timesRepetidos (rights lidas)
  where
    lidas = map (uncurry lerPartida) (linhasRelevantes texto)

linhasRelevantes :: String -> [(Int, String)]
linhasRelevantes = filter (relevante . snd) . zip [1 ..] . lines
  where
    relevante linha =
      case dropWhile isSpace linha of
        ""      -> False
        '#' : _ -> False
        _       -> True

timesRepetidos :: [Partida] -> [Erro]
timesRepetidos partidas =
  [ TimeRepetidoNaRodada r t | (i, (r, t)) <- zip [0 ..] jogos, (r, t) `elem` take i jogos ]
  where
    jogos = concatMap (\p -> [(rodada p, mandante p), (rodada p, visitante p)]) partidas


tabelaFormatada :: [Linha] -> String
tabelaFormatada linhas =
  unlines (formatar "Pos" "Time" ["P", "J", "V", "E", "D", "SG"] : zipWith linhaDe [1 :: Int ..] linhas)
  where
    largura = maximum (length "Time" : map (length . timeLinha) linhas)
    formatar pos time numeros =
      direita 3 pos ++ "  " ++ take largura (time ++ repeat ' ') ++ concatMap (direita 5) numeros
    linhaDe pos l =
      formatar (show pos) (timeLinha l)
        (map show [pontosLinha l, jogos l, vitorias l, empates l, derrotas l] ++ [comSinal (saldo l)])
    direita n texto = replicate (max 0 (n - length texto)) ' ' ++ texto
    comSinal n = if n > 0 then '+' : show n else show n


descreverErro :: Erro -> String
descreverErro (CamposInvalidos l n) =
  "linha " ++ show l ++ ": esperados 5 campos separados por ';', encontrados " ++ show n
descreverErro (NumeroInvalido l t) =
  "linha " ++ show l ++ ": '" ++ t ++ "' nao e um numero valido"
descreverErro (PlacarNegativo l g) =
  "linha " ++ show l ++ ": placar negativo (" ++ show g ++ ")"
descreverErro (MesmoTime l t) =
  "linha " ++ show l ++ ": " ++ t ++ " nao pode jogar contra si mesmo"
descreverErro (TimeRepetidoNaRodada r t) =
  "rodada " ++ show r ++ ": " ++ t ++ " joga mais de uma vez"
descreverErro (RodadaInvalida l r) =
  "linha " ++ show l ++ ": rodada invalida (" ++ show r ++ ")"
descreverErro (NomeVazio l) =
  "linha " ++ show l ++ ": nome de time vazio"