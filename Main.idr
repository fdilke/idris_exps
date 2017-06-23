module Main

import Lib

main : IO ()
main = do
  putStrLn "In the MAIN entry point"
  someFun
  pure ()
