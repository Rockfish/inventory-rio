{-# LANGUAGE NoImplicitPrelude #-}

module Types where

import RIO
import RIO.Process

-- | Command line arguments
data AppOptions = AppOptions
  { optionsVerbose :: Bool,
    sourceFilePath :: String,
    outputFilePath :: String
  }
  deriving (Show)

data App = App
  { appLogFunc :: !LogFunc,
    appProcessContext :: !ProcessContext,
    appOptions :: !AppOptions
    -- Add other app-specific configuration information here
  }

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x {appLogFunc = y})

instance HasProcessContext App where
  processContextL = lens appProcessContext (\x y -> x {appProcessContext = y})
