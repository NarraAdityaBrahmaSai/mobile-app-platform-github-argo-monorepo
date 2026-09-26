#!/usr/bin/env bash
set -euo pipefail

: "${GITHUB_OWNER:?Set GITHUB_OWNER to the GitHub owner/organization}"
REPOSITORY_NAME="${GITHUB_REPOSITORY_NAME:-mobile-platform-github-argo}"

command -v gh >/dev/null || { echo "GitHub CLI (gh) is required" >&2; exit 1; }
gh auth status >/dev/null
./scripts/check-public-repo.sh

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Using existing git repository"
else
  git init
  git branch -M main
fi

git add .
git commit -m "feat: initial mobile platform monorepo" || true
git branch -M main

if ! gh repo view "${GITHUB_OWNER}/${REPOSITORY_NAME}" >/dev/null 2>&1; then
  gh repo create "${GITHUB_OWNER}/${REPOSITORY_NAME}" --public --description "AWS + EKS Android/Web/Backend platform with GitHub Actions and Argo CD" --source=. --remote=origin --push
else
  git remote remove origin >/dev/null 2>&1 || true
  git remote add origin "https://github.com/${GITHUB_OWNER}/${REPOSITORY_NAME}.git"
  git push -u origin main
fi

echo "Published: https://github.com/${GITHUB_OWNER}/${REPOSITORY_NAME}"
