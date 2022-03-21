{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module SourceData where

import           Data.Aeson
import           Data.ByteString.Lazy (readFile)
import  Data.ByteString.Lazy.Char8 (lines)


testJson :: IO ()
testJson = do
    let val = decode "{ \"foo\": false, \"bar\": [1, 2, 3], \"name\": \"Charlie\" }" :: Maybe Value
    print val

printFile :: String -> IO ()
printFile filename = do
    content <- Data.ByteString.Lazy.readFile filename
    print content

printJson :: String -> IO ()
printJson filename = do
    content <- Data.ByteString.Lazy.readFile filename
    let contentLines = Data.ByteString.Lazy.Char8.lines content 
    mapM_ go contentLines
    where 
        go content = do 
            let val = decode content :: Maybe Value 
            print val
        
