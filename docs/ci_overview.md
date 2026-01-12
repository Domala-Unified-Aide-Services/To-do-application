# CI Overview — Todo Application

## What the CI Pipeline Does

- Runs automatically on every push and pull request
- Validates repository structure
- Performs PHP syntax checks on backend code
- Fails fast if any check fails

This provides a basic CI safety net.

---

## When It Runs

- On `push`
- On `pull_request`

---

## What It Does Not Do (Yet)

- No AWS deployment
- No database access
- No frontend build
- No CD

These are intentionally deferred.

---

## One Future Improvement

- Add automated backend tests
- Add frontend build or lint checks
- Extend CI into CD (auto-deploy to AWS EC2)
