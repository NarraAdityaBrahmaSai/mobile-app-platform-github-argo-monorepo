# Local Development

## Backend

```bash
python3 -m pip install --require-hashes -r app/backend/requirements.lock
python3 -m compileall app/backend
pytest -q app/backend/tests
```

## Web

```bash
cd app/web
npm ci
npm test
RELEASE_ID=local npm run build
```

## Android

Use JDK 17 and Android SDK 36. The CI workflow pins the Gradle version through `gradle/actions/setup-gradle`.

## Terraform

```bash
terraform -chdir=infra/live/prod fmt -check -recursive
terraform -chdir=infra/live/prod init -backend=false
terraform -chdir=infra/live/prod validate
```

## Kubernetes

```bash
kustomize build platform/clusters/prod
kustomize build platform/argocd
```
