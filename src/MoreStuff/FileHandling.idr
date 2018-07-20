module MoreStuff.FileHandling

import Effects
import Effect.File
import Effect.State
import Effect.StdIO
import Control.IOExcept
import Effect.Select

data Count : Type where


TestFileIO : Type -> Type -> Type
TestFileIO st t = Eff t [FILE st, STDIO, Count ::: STATE Int]

readFileCount : Eff (FileOpResult (List String)) [FILE R, STDIO, Count ::: STATE Int]
readFileCount = readAcc []
  where
    readAcc : List String
           -> Eff (FileOpResult (List String)) [FILE R, STDIO, Count ::: STATE Int]
    readAcc acc = do
      e <- eof
      if (not e)
         then do
           (Result str) <- readLine
                         | (FError err) => pure (FError err)
           Count :- put (!(Count :- get) + 1)
           readAcc (str :: acc)
         else do
           let res = reverse acc
           pure $ Result res

testFile : TestFileIO () ()
testFile = do
    Success <- open "testFile" Read
             | (FError err) => do
                 putStrLn "Error!"
                 pure ()
    (Result fcontents) <- readFileCount
                        | (FError err) => do
                            close
                            putStrLn "Error!"
                            pure ()
    putStrLn (show fcontents)
    close
    putStrLn (show !(Count :- get))

-- Eff (List String) [SELECT]
-- Eff () [FILE (), STDIO, Count ::: STATE Int]
-- TestFileIO () ()
-- effLoadFile: (fileName: String) -> Eff (List String) [SELECT]
effLoadFile: (fileName: String) -> Eff (List String) [FILE (), STDIO, Count ::: STATE Int]
effLoadFile fileName = pure [ "Um, dunno" ]
-- effLoadFile col qs = do row <- select (rowsIn col qs)
--                      addQueens (col - 1) ((row, col) :: qs)

sampleMain : IO ()
sampleMain = run testFile

export
loadFile: (fileName: String) -> Maybe (List String)
loadFile fileName = Just [ "todo: fix this!" ]

-- want to replace it by this, which returns IO x not Maybe x:
properLoadFile: (fileName: String) -> IO (List String)
properLoadFile fileName =
    run (effLoadFile fileName)

