module Engine
  ( evaluateTransaction
  , failedRuleNames
  ) where

import Transaction (Transaction (..), TxnState (..))
import Rules

-- Runs all rules on a transaction and decides the final state
evaluateTransaction :: Transaction -> TxnState
evaluateTransaction txn
  | all (\rule -> rule txn) allRules = Approved
  | length failed == 1               = Flagged
  | otherwise                        = Rejected
  where
    failed = failedRuleNames txn

-- Returns names of rules that failed, for reporting/debugging
failedRuleNames :: Transaction -> [String]
failedRuleNames txn = [name | (name, rule) <- namedRules, not (rule txn)]
  where
    namedRules =
      [ ("Amount limit exceeded", checkAmountLimit)
      , ("Card is blacklisted",   checkBlacklist)
      , ("Unsupported currency",  checkCurrency)
      ]