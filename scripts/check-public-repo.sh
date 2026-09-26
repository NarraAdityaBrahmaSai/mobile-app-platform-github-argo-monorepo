#!/usr/bin/env bash
set -euo pipefail

fail=0
patterns=(
  '-----BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----'
  'AKIA[0-9A-Z]{16}'
  'ASIA[0-9A-Z]{16}'
  'ghp_[A-Za-z0-9_]{20,}'
  'github_pat_[A-Za-z0-9_]{20,}'
)

for pattern in "${patterns[@]}"; do
  if grep -RInE --exclude-dir=.git --exclude='*.lock' --exclude='scripts/check-public-repo.sh' "$pattern" . >/tmp/public-repo-hit 2>/dev/null; then
    echo "Potential public-repo secret match: $pattern" >&2
    cat /tmp/public-repo-hit >&2
    fail=1
  fi
done

if grep -RInE --exclude-dir=.git 'REPLACE_WITH_|<ACCOUNT_ID>|<CERT_ID>|YOUR_GITHUB_OWNER' . >/dev/null 2>&1; then
  echo 'Placeholders exist; that is expected for a public reference repository.'
fi

exit "$fail"
