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

mwhileEnum : Monad m =>
    (test : m Bool) ->
    (get : m x) ->
    (fun: x -> acctype -> acctype) ->
    (accstart: acctype) ->
    m acctype
mwhileEnum t g f acc = do
    v <- t
    if v then do
        line <- g
        mwhileEnum t g f (f line acc)
    else
        pure acc

export
linesAsEnum: (fileName: String) -> IO (Enumeration String)
linesAsEnum fileName = do
    file <- openFile fileName Read
    case file of
        Right h => do
            let ppp = mwhileEnum
                (do
                    x <- fEOF h
                    pure (not x) )
                (do
                    Right l <- fGetLine h
                    pure l )
                (\txt : String, n : Int => n+1)
                0
            closeFile h
--            let e = (makeEnum ["bubb"])
            pure $ MkEnumeration $ \f, acc =>
                        f "bubb" acc
        Left err => pure empty

whiff: File -> Enumeration (IO String)
whiff h = MkEnumeration $ \f, acc =>
--    let x = mwhileEnum
-- test
--         f
--         (pure acc) in
     let
        x = 2
        y = 3
        test = (do {
             x <- fEOF h
             pure (not x) })
--        get = 2 in
--        get = (fGetLine h) in
        qt: IO Int = (do {
            Right l <- fGetLine h
            pure 7
        })
        qq: IO Int = (do {
            buzz <- fGetLine h
            case buzz of
                Left err => pure 1
                Right l => pure 3
                _ => pure 7
        }) in
--        p = 8 in
--        get = (case (fGetLine h) of
--            Right l => 3
--            Left k => 1
--        ) in
--        get = (do { {- Right -} l <- fGetLine h
--                pure l }) in
        ?xx

batch: File -> IO Int
batch h = do
    buzz <- fGetLine h
    case buzz of
        Left err => pure 1
        Right l => pure 3


botch: Int
botch = let
    t = (
        case 7 of
            1 => 3
            8 => 1
    ) in
        t


{- need to make this function work:
mwhileEnum2 : Monad m =>
    (start: m (Either success fail)) ->
    (end: success -> m ()) ->
    (test : m Bool) ->
    (get : success -> m inp) ->
    (fun: inp -> acctype -> acctype) ->
    (accstart: acctype) ->
    m acctype
mwhileEnum2 s e t g f acc = do
    init <- start
    case init of
        Left token => ?xx
        -- ( do
        --    let newacc = mwhileEnum t g f (f line acc)
--            e token
--            newacc )
        Right failed =>
            ?pig -- pure acc

piff: File -> Enumeration (IO String)
piff h = MkEnumeration $ \f, acc =>
    mwhileEnum2
         (do {
               x <- fEOF h
               pure (not x) })
         (do { Right l <- fGetLine h
               pure l })
         f
         (pure acc)


-- mwhileEnum3 : (test : IO Bool) -> (get : IO inp) -> (fun: inp -> acctype -> acctype) -> (accstart: acctype) -> IO acctype
-- mwhileEnum3 t g f acc = do
--    v <- t
--    case v of
--        True => do {
--            line <- g
--            mwhileEnum3 t g f (f line acc)
--        }
--        False => pure acc



enumTheLines: File -> (func : String -> acc -> acc) -> (init : acc) -> IO acc
enumTheLines h f a =
    pure a -- do this properly

pest: File -> IO (Enumeration String)
pest h = MkEnumeration $ \f, acc =>
    mwhileEnum
        (do {
              x <- fEOF h
              pure (not x) })
        (do { Right l <- fGetLine h
              pure l })
        f
        acc


whinesAsEnum: (fileName: String) -> IO (Enumeration String)
whinesAsEnum fileName = do
    file <- openFile fileName Read
    let ans = case file of
        Right h => piff h
        Left err => pure empty
    closeFile h
    pure ans

the problem: We have to return an IO (Enumeration String)
Or an Enumeration (IO String) would do, then apply sequence
But, every time we enumerate: we have to open a file,
do the enumeration, then close it again.
So maybe mwhile is not the way forward.
Instead... write a function that does what we can with the bits available.
Given f and acc do:
    open the file (So we're in an IO context)
    error check
    while there are lines (use an mwhile variant here??):
        fold each line into acc
    close the file (still in IO context)
    return pure of the acc

Does it help if the acc was an "IO a" to begin with?
-}


