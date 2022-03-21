{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# LANGUAGE FlexibleContexts  #-}
module Run (run) where

import           Import
import SourceData ( printJson )

import           Data.Array
import           Data.List          (head, tail)
import           RIO.Directory      (listDirectory)
import qualified RIO.Map            as Map
import           System.Environment
import           System.IO
import           Text.Regex.PCRE

data CollectionRecord = CollectionRecord {
  collectionDate       :: String,
  collectorName        :: String,
  collectionRecordName :: String,
  collectionRegion     :: String,
  collectionFilename   :: String
} deriving (Show, Eq)

run :: RIO App ()
run = do
  env <- liftIO getEnvironment
  app <- ask
  let ops = appOptions app
      sourcePath = sourceFilePath ops
      outputPath = outputFilePath ops
      envMap = Map.fromList env
      home = fromMaybe "~" (Map.lookup "HOME" envMap)
      fullSourcePath = home ++ tail sourcePath
      fullOutputPath = home ++ tail outputPath
      sourceFiles = getFilelist fullSourcePath

  logInfo $ "Home: " <> fromString home
  logInfo $ "Source folder: " <> fromString fullSourcePath
  logInfo $ "Output folder: " <> fromString fullOutputPath
  logInfo "\nSource files:"
  liftIO $ showFilelist sourceFiles
  logInfo "\nCollection records:"
  liftIO $ showCollectionRecords sourceFiles
  liftIO $ showJson sourceFiles


getFilelist :: FilePath -> IO [FilePath]
getFilelist filepath = do listDirectory filepath


showFilelist :: IO [FilePath] -> IO ()
showFilelist ioFiles = do
  files <- ioFiles
  mapM_ go files
  where go file = print file

showJson :: IO [FilePath] -> IO ()
showJson ioFiles = do
  files <- ioFiles
  mapM_ go files
  where go file = printJson file

showCollectionRecords :: IO [FilePath] -> IO ()
showCollectionRecords ioFiles = do
  files <- ioFiles
  mapM_ go files
  where go file = print (parseFilename file)


parseFilename :: String -> CollectionRecord
parseFilename filename = collection
  where pattern = "(?<timestamp>\\d+-\\d+-\\d+T\\d+\\.\\d+\\.\\d+Z)_(?<collector>\\S+)_(?<record>\\S+)_(?<number>\\d+)_(?<region>[^.]*).*" :: String
        matches :: [Array Int String]
        matches = getAllTextMatches $ filename =~ pattern
        arr = head matches
        collection = CollectionRecord {
          collectionDate = arr ! 1,
          collectorName = arr ! 2,
          collectionRecordName = arr ! 3,
          collectionRegion = arr ! 5,
          collectionFilename = filename
        }


