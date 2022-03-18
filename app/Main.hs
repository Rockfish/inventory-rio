{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell   #-}

module Main (main) where

import           Import
import           Options.Applicative.Simple
import qualified Paths_inventory_rio
import           RIO.Process
import           Run

-- data Sample = Sample
--   { hello      :: String
--   , quiet      :: Bool
--   , enthusiasm :: Int }

-- sample :: Parser Sample
-- sample = Sample
--       <$> strOption
--           ( long "hello"
--          <> metavar "TARGET"
--          <> help "Target for the greeting" )
--       <*> switch
--           ( long "quiet"
--          <> short 'q'
--          <> help "Whether to be quiet" )
--       <*> option auto
--           ( long "enthusiasm"
--          <> help "How enthusiastically to greet"
--          <> showDefault
--          <> value 1
--          <> metavar "INT" )

--
-- https://hackage.haskell.org/package/options
--
optionsConfig :: Parser AppOptions
optionsConfig =
  AppOptions
    <$> switch
      (long "verbose"
      <> short 'v'
      <> help "Verbose output?"
      )
    <*> strOption
      ( long "sourcefolder"
          <> showDefault
          <> value "~/Records/Source"
          <> metavar "filepath"
          <> help "File path with source files"
      )
    <*> strOption
      ( long "outputfolder"
          <> showDefault
          <> value "~/Records/Output"
          <> metavar "filepath"
          <> help "File path for output files"
      )

main :: IO ()
main = do
  (options, ()) <-
    simpleOptions
      $(simpleVersion Paths_inventory_rio.version)
      "Tiny Inventory in Haskell."
      "Small inventory app to parse json data and output some entities."
      optionsConfig
      empty

  lo <- logOptionsHandle stderr (optionsVerbose options)
  pc <- mkDefaultProcessContext

  withLogFunc lo $ \lf ->
    let app =
          App
            { appLogFunc = lf,
              appProcessContext = pc,
              appOptions = options
            }
     in runRIO app run
