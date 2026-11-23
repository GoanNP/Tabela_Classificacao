module Main where

import Dados
import Tipos

main :: IO ()
main = do
  putStrLn ("Quantidade de times: " ++ show (length (times campeonatoTeste)))
  putStrLn ("Quantidade de rodadas: 7")
  putStrLn ("Quantidade de partidas: " ++ show (length campeonatoTeste))
  putStrLn ("Times: " ++ show (times campeonatoTeste))