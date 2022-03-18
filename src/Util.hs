{-# LANGUAGE NoImplicitPrelude #-}

module Util where

import RIO
import System.Environment
import System.IO (putStrLn)

-- | Little function used to demonstrate how to write a test case
plus2 :: Int -> Int
plus2 = (+ 2)

showEnv :: IO ()
showEnv = do
  env <- getEnvironment
  mapM_ go env
  where go (name, value) = putStrLn $ name ++ "=" ++ value
