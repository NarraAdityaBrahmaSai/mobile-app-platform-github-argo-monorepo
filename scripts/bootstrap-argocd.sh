#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:=ap-south-1}"
: "${EKS_CLUSTER_NAME:?EKS_CLUSTER_NAME must be set}"
: "${GITHUB_OWNER:?GITHUB_OWNER must be set}"
: "${GITHUB_REPOSITORY_NAME:?GITHUB_REPOSITORY_NAME must be set}"

command -v aws >/dev/null || { echo "aws CLI is required" >&2; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl is required" >&2; exit 1; }
command -v helm >/dev/null || { echo "helm is required" >&2; exit 1; }

aws eks update-kubeconfig --region "$AWS_REGION" --name "$EKS_CLUSTER_NAME"
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argo/argo-cd --namespace argocd --create-namespace --values platform/argocd/bootstrap/values.yaml --wait --timeout 15m

sed \
  -e "s#<GITHUB_OWNER>#$GITHUB_OWNER#g" \
  -e "s#<GITHUB_REPOSITORY_NAME>#$GITHUB_REPOSITORY_NAME#g" \
  platform/argocd/bootstrap/root-app.yaml | kubectl apply -f -
