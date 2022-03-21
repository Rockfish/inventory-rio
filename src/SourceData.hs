{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module SourceData where

import           Data.Aeson
import           Data.ByteString.Lazy (readFile, putStrLn)
import           GHC.Generics
import qualified RIO.Map              as Map
import           RIO.Text


testJson :: IO ()
testJson = do
    let val = decode "{ \"foo\": false, \"bar\": [1, 2, 3], \"name\": \"Charlie\" }" :: Maybe Value
    print val

printJson :: String -> IO ()
printJson filename = do
    content <- readFile filename
    let val = decode content
    putStrLn $ show val
