# Security Policy

## Public repository rule

This repository is safe to publish only when it contains no AWS credentials, private keys, Android signing material, Google Play service-account JSON, GitHub App private keys, database passwords, tokens, or other production secrets.

## Reporting

For a public demonstration repository, open a GitHub security advisory or private security report instead of posting exploitable details in a public issue.

## Secret handling

- GitHub Actions authenticates to AWS with GitHub OIDC and short-lived role sessions.
- Runtime secrets are stored in AWS Secrets Manager and surfaced through External Secrets.
- Android signing and Google Play credentials belong in protected GitHub environments/secrets.
- Never commit `.env`, keystore files, service-account JSON, or private-key files.
