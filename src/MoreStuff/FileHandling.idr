module MoreStuff.FileHandling

import MoreStuff.Enumerations
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

{-
sampleMain : IO ()
sampleMain = run testFile


export
loadFile: (fileName: String) -> Maybe (List String)
loadFile fileName = Just [ "todo: fix this!" ]
-- want to replace it by other, which returns IO x not Maybe x:
-}

loadLines: (Either FileError String) -> Maybe (List String)
loadLines (Left error) = Nothing
loadLines (Right text) = Just (lines text)

export
loadFile: (fileName: String) -> IO (Maybe (List String))
loadFile fileName = do
    contents <- readFile fileName
    pure $ loadLines contents

--    run (effLoadFile fileName)

-- split out 'monadic stateful while' as a separate utility?
mwhile : (test : IO Bool) -> (body : IO ()) -> IO ()
mwhile t b = do
    v <- t
    case v of
         True => do b
                    mwhile t b
         False => pure ()

--mwhileEnum : (test : IO Bool) -> (getter: IO String) -> (body : IO ()) -> IO ()
--mwhileEnum t g b = do
--    v <- t
--    case v of
--         True => do b
--                    mwhileEnum t g b
--         False => pure ()

mwhileEnum : (test : IO Bool) -> (get : IO String) -> (fun: String -> acctype -> acctype) -> (accstart: acctype) -> IO acctype
mwhileEnum t g f acc = do
    v <- t
    case v of
        True => do {
            line <- g
            mwhileEnum t g f (f line acc)
        }
        False => pure acc

export
linesAsEnum: (fileName: String) -> IO (Enumeration String)
linesAsEnum fileName = do
    file <- openFile fileName Read
    case file of
        Right h => do {
            let ppp = mwhileEnum
                (do {
                      x <- fEOF h
                      pure (not x) })
                (do { Right l <- fGetLine h
                      pure l })
                (\txt, n => n+1)
                0
            closeFile h
--            let e = (makeEnum ["bubb"])
            let e = MkEnumeration $ \f, acc =>
                        f "bubb" acc
            pure e
        }
        Left err => pure empty
