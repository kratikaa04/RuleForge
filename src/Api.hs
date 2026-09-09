{-# LANGUAGE OverloadedStrings #-}

module Api
  ( runApi
  ) where

import Web.Scotty
import Network.Wai.Middleware.Cors
import Network.HTTP.Types (hContentType)
import Data.Aeson (object, (.=))

import Transaction (Transaction (..), TxnState (..))
import Engine (evaluateTransaction, failedRuleNames)

corsPolicy :: CorsResourcePolicy
corsPolicy = simpleCorsResourcePolicy
  { corsMethods = ["GET", "POST", "OPTIONS"]
  , corsRequestHeaders = [hContentType]
  }

runApi :: IO ()
runApi = scotty 3000 $ do
  middleware (cors (const (Just corsPolicy)))
  get "/" $ do
    text "RuleForge API is running. POST a transaction to /evaluate"
  post "/evaluate" $ do
    txn <- jsonData :: ActionM Transaction
    let state = evaluateTransaction txn
        reasons = failedRuleNames txn
    json (object
      [ "txnId"   .= txnId txn
      , "state"   .= show state
      , "reasons" .= reasons
      ])