module Main

import Lib

main : IO ()
main = do
  putStrLn "In the TEST entry point"
  someFun
  pure ()
