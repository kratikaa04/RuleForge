import { useState } from 'react'
import './App.css'

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/evaluate'

function App() {
  const [form, setForm] = useState({
    txnId: '',
    amount: '',
    currency: 'INR',
    cardId: '',
    country: '',
  })
  const [log, setLog] = useState([])
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')

    if (!form.txnId || !form.amount || !form.cardId || !form.country) {
      setError('All fields are required.')
      return
    }

    setLoading(true)
    try {
      const res = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          txnId: form.txnId,
          amount: parseFloat(form.amount),
          currency: form.currency,
          cardId: form.cardId,
          country: form.country,
        }),
      })

      if (!res.ok) throw new Error('Server rejected the request.')

      const data = await res.json()
      setLog([{ ...data, timestamp: new Date().toLocaleTimeString() }, ...log])
      setForm({ txnId: '', amount: '', currency: 'INR', cardId: '', country: '' })
    } catch (err) {
      setError('Could not reach RuleForge API. Is the backend running on port 3000?')
    } finally {
      setLoading(false)
    }
  }

  const statusClass = (state) => {
    if (state === 'Approved') return 'badge approved'
    if (state === 'Flagged') return 'badge flagged'
    return 'badge rejected'
  }

  return (
    <div className="app">
      <header className="app-header">
        <h1>RuleForge</h1>
        <p>A functional rule engine for payment validation</p>
      </header>

      <div className="layout">
        <section className="panel form-panel">
          <h2>Submit a transaction</h2>
          <form onSubmit={handleSubmit}>
            <label>
              Transaction ID
              <input name="txnId" value={form.txnId} onChange={handleChange} placeholder="TXN001" />
            </label>

            <label>
              Amount
              <input name="amount" type="number" value={form.amount} onChange={handleChange} placeholder="25000" />
            </label>

            <label>
              Currency
              <select name="currency" value={form.currency} onChange={handleChange}>
                <option value="INR">INR</option>
                <option value="USD">USD</option>
                <option value="EUR">EUR</option>
                <option value="GBP">GBP (unsupported — for testing)</option>
              </select>
            </label>

            <label>
              Card ID
              <input name="cardId" value={form.cardId} onChange={handleChange} placeholder="CARD_GOOD_1" />
            </label>

            <label>
              Country
              <input name="country" value={form.country} onChange={handleChange} placeholder="IN" />
            </label>

            {error && <p className="error-text">{error}</p>}

            <button type="submit" disabled={loading}>
              {loading ? 'Evaluating...' : 'Evaluate transaction'}
            </button>
          </form>

          <p className="hint">
            Try card ID <code>CARD_BLOCKED_1</code> to see a flagged/rejected result.
          </p>
        </section>

        <section className="panel log-panel">
          <h2>Transaction ledger</h2>
          {log.length === 0 ? (
            <p className="empty-state">No transactions evaluated yet. Submit one to see it here.</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Time</th>
                  <th>Txn ID</th>
                  <th>State</th>
                  <th>Reasons</th>
                </tr>
              </thead>
              <tbody>
                {log.map((entry, i) => (
                  <tr key={i}>
                    <td className="mono">{entry.timestamp}</td>
                    <td className="mono">{entry.txnId}</td>
                    <td><span className={statusClass(entry.state)}>{entry.state}</span></td>
                    <td className="reasons">
                      {entry.reasons && entry.reasons.length > 0 ? entry.reasons.join(', ') : '—'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </section>
      </div>
    </div>
  )
}

export default App