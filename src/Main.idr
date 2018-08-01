module Main

import Lib
import MoreStuff.FileHandling

{-
main : IO ()
main = do
  putStrLn "In the MAIN entry point"
  someFun
  pure ()
-}

main : IO ()
main = do
  optionalLines <- loadFile "/usr/share/dict/words"
  let words = fromMaybe [] optionalLines
  putStrLn "=== words end"
  pure ()
