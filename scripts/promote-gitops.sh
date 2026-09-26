#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1:?immutable image reference is required}"
ENVIRONMENT="${2:-prod}"
GH_TOKEN="${GH_TOKEN:?GH_TOKEN is required}"
PLATFORM_REPOSITORY="${PLATFORM_REPOSITORY:?owner/repository is required}"
GITHUB_SHA="${GITHUB_SHA:?GITHUB_SHA is required}"
GITHUB_RUN_ID="${GITHUB_RUN_ID:?GITHUB_RUN_ID is required}"

[[ "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]] || { echo "Unsupported environment: $ENVIRONMENT" >&2; exit 1; }
command -v gh >/dev/null || { echo "gh CLI is required" >&2; exit 1; }
command -v git >/dev/null || { echo "git is required" >&2; exit 1; }

export GH_TOKEN
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

git -c "http.extraHeader=Authorization: Bearer ${GH_TOKEN}" clone --depth 1 "https://github.com/${PLATFORM_REPOSITORY}.git" "$WORKDIR/repo"
cd "$WORKDIR/repo"

git config user.name 'mobile-platform-gitops[bot]'
git config user.email 'mobile-platform-gitops[bot]@users.noreply.github.com'

TARGET="platform/clusters/${ENVIRONMENT}/apps/backend/kustomization.yaml"
[[ -f "$TARGET" ]] || { echo "Missing GitOps target: $TARGET" >&2; exit 1; }

python3 - "$TARGET" "$IMAGE_REF" <<'PY'
from pathlib import Path
import re, sys

path = Path(sys.argv[1])
image_ref = sys.argv[2]
if '@' not in image_ref:
    raise SystemExit('IMAGE_REF must be an immutable image reference in name@sha256:digest form')
name, digest = image_ref.split('@', 1)
text = path.read_text()
text = re.sub(r'(?m)^\s+newName:.*$', f'    newName: {name}', text, count=1)
text = re.sub(r'(?m)^\s+digest:.*$', f'    digest: {digest}', text, count=1)
path.write_text(text)
PY

BRANCH="promote/backend-${GITHUB_SHA:0:12}-${GITHUB_RUN_ID}"
git checkout -b "$BRANCH"
git add "$TARGET"
git diff --cached --quiet && { echo 'No GitOps change required.'; exit 0; }
git commit -m "chore: promote backend ${IMAGE_REF##*@}"
git push --set-upstream origin HEAD

gh pr create \
  --repo "$PLATFORM_REPOSITORY" \
  --base main \
  --head "$BRANCH" \
  --title "chore: promote backend ${GITHUB_SHA:0:12}" \
  --body "Automated promotion from ${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}. Environment: ${ENVIRONMENT}. Image: ${IMAGE_REF}. Argo CD reconciles after merge."
