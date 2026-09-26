
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
for f in $(find . -type f -name '*.sh'); do bash -n "$f"; done
python3 - <<'PY_YAML'
from pathlib import Path
import yaml
for path in list(Path('.').rglob('*.yaml')) + list(Path('.').rglob('*.yml')):
    list(yaml.safe_load_all(path.read_text()))
print('YAML/YML parse: PASS')
PY_YAML
python3 - <<'PY_VALIDATE'
from pathlib import Path
import yaml
for path in Path('.').rglob('*.yaml'):
    list(yaml.safe_load_all(path.read_text()))
print('YAML parse: PASS')
PY_VALIDATE
if command -v terraform >/dev/null 2>&1; then
  terraform -chdir=infra/live/prod fmt -check -recursive
  terraform -chdir=infra/live/prod init -backend=false -input=false
  terraform -chdir=infra/live/prod validate
else
  echo 'Terraform binary not installed; Terraform validation skipped.'
fi
