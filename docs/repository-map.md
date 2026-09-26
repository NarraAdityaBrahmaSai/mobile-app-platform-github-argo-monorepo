# Monorepo Map

```text
.github/workflows/main.yml        # dispatcher
.github/workflows/security.yml    # reusable security pipeline
.github/workflows/backend.yml     # reusable backend pipeline
.github/workflows/web.yml         # reusable web pipeline
.github/workflows/android.yml     # reusable Android pipeline
.github/workflows/infra.yml       # reusable Terraform pipeline
.github/workflows/platform.yml    # reusable Argo/Kubernetes validation
.github/workflows/bootstrap.yml   # manual Argo bootstrap

app/backend/                      # API + tests + container
app/web/                          # web application
app/android/                      # Android + Fastlane

infra/live/bootstrap/             # state foundation
infra/live/prod/                  # production AWS root
infra/modules/                    # AWS reusable modules

platform/argocd/                 # Argo CD Projects/Applications
platform/clusters/prod/          # prod desired state
platform/clusters/staging/       # staging desired state
platform/clusters/dev/           # dev desired state

docs/                            # design + runbooks
scripts/                          # validation/bootstrap/promotion/publish
```
