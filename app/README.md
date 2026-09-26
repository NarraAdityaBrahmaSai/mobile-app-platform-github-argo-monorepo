# Application

The application layer contains three delivery surfaces:

- `backend/` — Python API packaged as a non-root container
- `web/` — static web frontend published to private S3 behind CloudFront
- `android/` — Android application built as a signed AAB and delivered through Google Play tracks

CI/CD is orchestrated from the monorepo root under `.github/workflows`.
