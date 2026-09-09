module Main (main) where

import Api (runApi)

main :: IO ()
main = do
  putStrLn "Starting RuleForge API on http://localhost:3000 ..."
  runApi