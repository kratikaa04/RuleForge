## RuleForge

A small rule engine for validating payment transactions, built in Haskell with a React dashboard on top.

##What it does

Before a payment goes through, it usually needs to pass a few checks — is the amount within limits, is the card blacklisted, is the currency supported. RuleForge handles this with independent, pure functions instead of a big tangled if-else block. Each rule runs on its own, and the results combine into a final decision: Approved, Flagged, or Rejected, with reasons attached.

##Why Haskell

I wanted to explore how functional programming handles this kind of problem — Haskell's pure functions and type system make each rule easy to test in isolation, and invalid transaction states (like something being both approved and rejected) simply can't be represented.

##How it's built
Transaction (data model)
    → Rules (independent validation functions)
    → Engine (combines rules into a decision)
    → API (Scotty, exposes /evaluate)
    → React dashboard (form + live results)
##Stack
Backend: Haskell, Scotty, Aeson
Frontend: React, Vite
Running it locally

##Backend

bash
stack build
stack run

Runs on http://localhost:3000

##Frontend

bash
cd frontend
npm install
npm run dev

Runs on http://localhost:5173

Both need to be running together for the dashboard to work.

##API
POST /evaluate
json
{
  "txnId": "TXN001",
  "amount": 25000,
  "currency": "INR",
  "cardId": "CARD_GOOD_1",
  "country": "IN"
}

##Returns:

json
{ "txnId": "TXN001", "state": "Approved", "reasons": [] }
Current rules
Amount can't exceed ₹50,000
Card can't be on the blacklist
Currency must be INR, USD, or EUR
Next up
Load transactions from JSON instead of hardcoding them
Add tests for each rule
Deploy it live

Built by Kratika Bansal
