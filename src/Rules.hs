module Rules
  ( checkAmountLimit
  , checkBlacklist
  , checkCurrency
  , allRules
  ) where

import Transaction (Transaction (..))

-- Rule 1: transaction amount must not exceed a fixed limit
checkAmountLimit :: Transaction -> Bool
checkAmountLimit txn = amount txn <= 50000

-- Rule 2: cardId must not be on a hardcoded blacklist
blacklistedCards :: [String]
blacklistedCards = ["CARD_BLOCKED_1", "CARD_BLOCKED_2"]

checkBlacklist :: Transaction -> Bool
checkBlacklist txn = cardId txn `notElem` blacklistedCards

-- Rule 3: currency must be one of the supported currencies
checkCurrency :: Transaction -> Bool
checkCurrency txn = currency txn `elem` ["INR", "USD", "EUR"]

-- A list of all rules, so Engine.hs can run them together
allRules :: [Transaction -> Bool]
allRules = [checkAmountLimit, checkBlacklist, checkCurrency]