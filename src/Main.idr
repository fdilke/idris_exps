module Main

import Lib
import MoreStuff.Acrostic
import MoreStuff.ShowBadRndInt

{-
main : IO ()
main = do
  putStrLn "In the MAIN entry point"
  someFun
  pure ()
-}

{-}
main : IO ()
main = do
  optionalLines <- loadFile "/tmp/botch.txt" -- "/usr/share/dict/words"
  let words = fromMaybe [] optionalLines
  putStrLn "=== words end"
  pure ()
-}

mwhile : (test : IO Bool) -> (body : IO ()) -> IO ()
mwhile t b = do v <- t
                case v of
                     True => do b
                                mwhile t b
                     False => pure ()

dumpFile : String -> IO ()
dumpFile fn = do { Right h <- openFile fn Read
                   mwhile (do { -- putStrLn "TEST"
                                x <- fEOF h
                                pure (not x) })
                          (do { Right l <- fGetLine h
                                putStr l })
                   closeFile h }
{-
main : IO ()
main = do
  dumpFile "/tmp/botch.txt"
  pure ()
-}

main : IO ()
main = putStr "Somebody define an app here"
-- main = doShowBadRndInt
-- doAcrostics

