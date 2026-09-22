#!/usr/bin/env bash
# Installs the bootcamp tools. Runs once, when the Codespace is created.
set -euo pipefail

# Pinned versions, checked in September 2026.
# Never use Trivy 0.69.4, 0.69.5 or 0.69.6. Those builds were malicious.
GITLEAKS_VERSION="8.30.1"
TRIVY_VERSION="0.74.0"

echo "Installing Semgrep, Checkov and pre-commit, each in its own space..."
if ! command -v pipx > /dev/null; then
  python -m pip install --quiet --user pipx
  export PATH="$HOME/.local/bin:$PATH"
fi
pipx install semgrep
pipx install checkov
pipx install pre-commit

echo "Installing Flask for the demo app..."
pip install --quiet flask

echo "Installing Gitleaks ${GITLEAKS_VERSION}..."
tmp="$(mktemp -d)"
curl -sSfL "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz" | tar -xz -C "$tmp"
sudo install "$tmp/gitleaks" /usr/local/bin/gitleaks

echo "Installing Trivy ${TRIVY_VERSION}..."
tmp="$(mktemp -d)"
curl -sSfL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" | tar -xz -C "$tmp"
sudo install "$tmp/trivy" /usr/local/bin/trivy

echo ""
gitleaks version
semgrep --version
trivy --version
checkov --version
echo ""
echo "Setup finished. You are ready for the bootcamp."
