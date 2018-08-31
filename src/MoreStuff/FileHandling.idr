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

export
oldloadFile: (fileName: String) -> IO (Maybe (List String))
oldloadFile fileName = do
    contents <- readFile fileName
    pure $
        case contents of
            (Left error) => Nothing
            (Right text) => Just (lines text)

-- split out 'monadic stateful while' as a separate utility?
mwhile : (test : IO Bool) -> (body : IO ()) -> IO ()
mwhile t b = do
    v <- t
    case v of
         True => do b
                    mwhile t b
         False => pure ()

mwhileEnum : Monad m =>
    (test : m Bool) ->
    (get : m x) ->
    (fun: x -> acc -> acc) ->
    (a: acc) ->
    m acc
mwhileEnum test get fun a = do
    v <- test
    if v then do
        next <- get
        mwhileEnum test get fun (fun next a)
    else
        pure a

rtrim : String -> String
rtrim xs = reverse (ltrim (reverse xs))

export
loadFile: (fileName: String) -> IO (Maybe (List String))
loadFile fileName = do
    file <- openFile fileName Read
    case file of
        Right h => do
            ppp <- mwhileEnum
                (do
                    x <- fEOF h
                    pure (not x) )
                (do
                    Right l <- fGetLine h
                    pure (rtrim l) )
                (\txt : String, list : List String => txt :: list)
                []
            closeFile h
            pure $ Just $ reverse ppp
        Left err => pure Nothing

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

{-
mwhileEnum2 : Monad m =>
    (test : m Bool) ->
    (get : m x) ->
    (fun: x -> acc -> acc) ->
    (a: m acc) ->
    m acc
mwhileEnum2 test get fun a = do
    v <- test
    if v then do
        next <- get
        mwhileEnum2 test get fun (map (fun next) a)
    else
        a

export
linesAsEnum2: (fileName: String) -> IO (Enumeration String)
linesAsEnum2 fileName = do
    Right h <- openFile fileName Read
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
    pure $ MkEnumeration $ \f, acc =>
                f "bubb" acc

linesAsEnum3: (fileName: String) -> IO (Enumeration String)
linesAsEnum3 fileName = do
    Right h <- openFile fileName Read
    let ppp: IO Int = mwhileEnum
        (do
            x <- fEOF h
            pure (not x) )
        (do
            Right l <- fGetLine h
            pure l )
        (\txt : String, n : Int => n+1)
        0
    closeFile h
    pure $ MkEnumeration $ \f, acc =>
                f "bubb" acc

whiff: File -> Enumeration (IO String)
whiff h = MkEnumeration doFold where
    doFold: { acc: Type } ->
        (f : IO String -> acc -> acc) ->
        (init : acc) ->
        acc
    doFold { acc } f a =
         let
            test: IO Bool = (do {
                 x <- fEOF h
                 pure (not x) })
            get: IO String = (do {
                Right l <- fGetLine h
                pure l
            })
            fing: IO acc = mwhileEnum test (pure get) f a
            p = 8 in
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


