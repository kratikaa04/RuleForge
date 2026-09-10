module Main (main) where

import System.IO (hSetBuffering, stdout, BufferMode(..))
import Api (runApi)

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  putStrLn "Starting RuleForge API on http://localhost:3000 ..."
  runApi