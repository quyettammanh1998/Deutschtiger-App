# Exam catalog contract probe — 2026-07-15

Production proves the Flutter Exam catalog has a live public source. The local
runtime is not suitable for catalog evidence until its deployed handler/data is
aligned: it returns JSON `null`, while the current Go handler initializes a
missing or nil index as an empty array before responding.

No Flutter fallback was added. Coercing `200 null` to an empty catalog would
hide an invalid server response; disabling Exam would contradict the production
response.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Local backend is reachable | `200 {"status":"ok",...}` | ✅ |
| `curl -s http://127.0.0.1:8080/api/v1/exams \| jq -r type` | JSON array catalog | `null` | ❌ |
| `curl -s https://deutschtiger.com/api/v1/exams \| jq -e 'type == "array" and length > 0'` | Non-empty public catalog | Valid non-empty array; first set `goethe-a1-01` includes parts | ✅ |
| `ExamHandler.readIndex` source inspection | Missing/nil index becomes array before response | `ExamSets: []ExamSetMeta{}` for a missing file; nil slice normalized to `[]` | ✅ |

Next evidence: run the local backend with the current handler and versioned
exam data, then exercise one Lesen and one Hören detail response against the
Flutter mapper.
