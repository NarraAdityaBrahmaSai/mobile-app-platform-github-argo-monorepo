# GitHub Actions Architecture

The repository uses reusable workflows as the pipeline units and one dispatcher workflow as the orchestration layer. GitHub supports calling reusable workflows directly from jobs and conditioning those jobs with `if`/`needs`; this lets the root workflow decide which pipeline runs based on the files changed.

## Pipelines

| Workflow | Responsibility | Triggered by main dispatcher when |
|---|---|---|
| `main.yml` | Detect changes and orchestrate | Always for PR/main/tag/manual runs |
| `security.yml` | Secret/static/dependency/IaC scanning | Application, infra, platform, script, or workflow changes |
| `backend.yml` | Backend test/build/publish/GitOps PR | `app/backend/**` or promotion code |
| `web.yml` | Web test/build/publish | `app/web/**` |
| `android.yml` | Android test/build/Play promotion | `app/android/**` or Android release tag |
| `infra.yml` | Terraform validate/plan/apply | `infra/**` |
| `platform.yml` | Kustomize/Argo manifest validation | `platform/**` |
| `bootstrap.yml` | Manual private-runner Argo bootstrap | Manually dispatched |

## Why a dispatcher?

It prevents an Android-only pull request from running Terraform, or a documentation-only change from building Docker/Android artifacts. A workflow file change deliberately triggers the full suite so pipeline modifications are tested across the repository.
