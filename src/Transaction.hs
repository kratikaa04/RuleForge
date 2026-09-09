{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Transaction
  ( Transaction (..)
  , TxnState (..)
  ) where

import Data.Aeson (ToJSON, FromJSON)
import GHC.Generics (Generic)

data TxnState = Pending | Approved | Rejected | Flagged
  deriving (Show, Eq, Generic)

instance ToJSON TxnState
instance FromJSON TxnState

data Transaction = Transaction
  { txnId    :: String
  , amount   :: Double
  , currency :: String
  , cardId   :: String
  , country  :: String
  } deriving (Show, Generic)

instance ToJSON Transaction
instance FromJSON Transaction