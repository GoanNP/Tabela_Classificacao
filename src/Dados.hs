module Dados
  ( campeonatoTeste
  , dadosCampeonato
  , partidaEmpateSemGols
  , partidaMaiorGoleada
  , partidaFinalCoritiba
  ) where

import Tipos

campeonatoTeste :: [Partida]
campeonatoTeste =
  [ Partida 1 "Coritiba" 2 0 "Rio Branco"
  , Partida 1 "Athletico" 3 0 "Azuriz"
  , Partida 1 "Parana" 1 1 "Cianorte"
  , Partida 1 "Operario" 2 2 "Cascavel"
  , Partida 1 "Londrina" 0 0 "Maringa"
  , Partida 2 "Azuriz" 1 1 "Coritiba"
  , Partida 2 "Cianorte" 2 0 "Rio Branco"
  , Partida 2 "Cascavel" 1 2 "Athletico"
  , Partida 2 "Maringa" 2 1 "Parana"
  , Partida 2 "Londrina" 1 0 "Operario"
  , Partida 3 "Coritiba" 3 0 "Cianorte"
  , Partida 3 "Azuriz" 0 4 "Cascavel"
  , Partida 3 "Rio Branco" 1 2 "Maringa"
  , Partida 3 "Athletico" 1 1 "Londrina"
  , Partida 3 "Parana" 2 0 "Operario"
  , Partida 4 "Cascavel" 0 2 "Coritiba"
  , Partida 4 "Maringa" 1 1 "Cianorte"
  , Partida 4 "Londrina" 3 1 "Azuriz"
  , Partida 4 "Operario" 2 0 "Rio Branco"
  , Partida 4 "Parana" 1 2 "Athletico"
  , Partida 5 "Coritiba" 4 0 "Maringa"
  , Partida 5 "Cascavel" 2 1 "Londrina"
  , Partida 5 "Cianorte" 1 0 "Operario"
  , Partida 5 "Azuriz" 2 2 "Parana"
  , Partida 5 "Rio Branco" 0 3 "Athletico"
  , Partida 6 "Londrina" 1 2 "Coritiba"
  , Partida 6 "Operario" 1 0 "Maringa"
  , Partida 6 "Parana" 2 1 "Cascavel"
  , Partida 6 "Athletico" 0 0 "Cianorte"
  , Partida 6 "Rio Branco" 1 2 "Azuriz"
  , Partida 7 "Coritiba" 3 0 "Operario"
  , Partida 7 "Londrina" 2 0 "Parana"
  , Partida 7 "Maringa" 1 2 "Athletico"
  , Partida 7 "Cascavel" 3 0 "Rio Branco"
  , Partida 7 "Cianorte" 1 0 "Azuriz"
  ]

dadosCampeonato :: String
dadosCampeonato = unlines
  [ "# rodada;mandante;gols mandante;gols visitante;visitante"
  , "1;Coritiba;2;0;Rio Branco"
  , "1;Athletico;3;0;Azuriz"
  , "1;Parana;1;1;Cianorte"
  , "1;Operario;2;2;Cascavel"
  , "1;Londrina;0;0;Maringa"
  , "2;Azuriz;1;1;Coritiba"
  , "2;Cianorte;2;0;Rio Branco"
  , "2;Cascavel;1;2;Athletico"
  , "2;Maringa;2;1;Parana"
  , "2;Londrina;1;0;Operario"
  , "3;Coritiba;3;0;Cianorte"
  , "3;Azuriz;0;4;Cascavel"
  , "3;Rio Branco;1;2;Maringa"
  , "3;Athletico;1;1;Londrina"
  , "3;Parana;2;0;Operario"
  , "4;Cascavel;0;2;Coritiba"
  , "4;Maringa;1;1;Cianorte"
  , "4;Londrina;3;1;Azuriz"
  , "4;Operario;2;0;Rio Branco"
  , "4;Parana;1;2;Athletico"
  , "5;Coritiba;4;0;Maringa"
  , "5;Cascavel;2;1;Londrina"
  , "5;Cianorte;1;0;Operario"
  , "5;Azuriz;2;2;Parana"
  , "5;Rio Branco;0;3;Athletico"
  , "6;Londrina;1;2;Coritiba"
  , "6;Operario;1;0;Maringa"
  , "6;Parana;2;1;Cascavel"
  , "6;Athletico;0;0;Cianorte"
  , "6;Rio Branco;1;2;Azuriz"
  , "7;Coritiba;3;0;Operario"
  , "7;Londrina;2;0;Parana"
  , "7;Maringa;1;2;Athletico"
  , "7;Cascavel;3;0;Rio Branco"
  , "7;Cianorte;1;0;Azuriz"
  ]


-- | Entrada com um erro de cada tipo, para demonstrar a validação.
dadosComErros :: String
dadosComErros = unlines
  [ "# rodada;mandante;gols mandante;gols visitante;visitante"
  , "1;Coritiba;2;0;Athletico"
  , "1;Londrina;2;Maringa"
  , "1;Cascavel;dois;0;Azuriz"
  , "2;Athletico;1;-1;Londrina"
  , "2;Parana;0;0;Parana"
  , ""
  , "1;Coritiba;1;1;Operario"
  ]