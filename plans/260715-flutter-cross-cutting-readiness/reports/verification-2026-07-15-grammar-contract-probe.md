# Grammar contract probe — 2026-07-15

The Go reference server registers public grammar routes, but content is not
present in the local checkout. Flutter must keep Grammar gated; replacing its
static provider with an endpoint that returns 500 would not make it live.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend ready | `200 {"status":"ok",...}` | ✅ |
| `curl http://127.0.0.1:8080/api/v1/grammar` | Usable public grammar index | `500 {"error":"failed to read grammar index"}` | ❌ |
| `find ... -path '*/grammar/index.json'` | Versioned grammar content asset in reference checkout | No matching asset | ❌ |

Required before implementation: source/version the grammar index and lesson
assets, prove the endpoint returns the documented array, then replace Flutter
static models with a tested API mapper and only enable the release gate after
that evidence exists.
