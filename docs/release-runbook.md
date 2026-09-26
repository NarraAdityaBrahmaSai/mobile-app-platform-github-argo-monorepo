
# Release runbook

## Backend

1. Merge application code to `main`.
2. Actions runs tests and security gates.
3. Build/scan/publish the container.
4. Resolve the immutable ECR digest.
5. Open the platform GitOps PR.
6. Review/merge the platform PR.
7. Argo CD reconciles the backend Application.
8. Verify health, latency, errors and saturation.
9. Roll back with a Git revert or previous verified digest.

## Web

Merge -> test -> build -> upload immutable release -> update index -> CloudFront invalidation.

## Android

Tag -> test -> sign/build once -> internal track -> validate -> approve protected production job -> promote the same AAB.
