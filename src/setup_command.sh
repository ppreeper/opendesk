# opendesk bootstrap: install the prerequisites needed to run the Ansible setup.
# Safe to re-run; an existing checkout is updated in place.

OPENDESK_HOME="${OPENDESK_HOME:-$HOME/.local/share/opendesk}"
OPENDESK_REPO="${OPENDESK_REPO:-https://github.com/ppreeper/opendesk.git}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }

# 1. Ensure uv (fast Python package manager and runner) is available.
if ! command -v uv >/dev/null 2>&1; then
  info "Installing uv"
  if command -v curl >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- https://astral.sh/uv/install.sh | sh
  else
    warn "Neither curl nor wget is available to install uv"
    exit 1
  fi
  # shellcheck disable=SC1090
  . "$HOME/.local/bin/env" 2>/dev/null || true
  export PATH="$HOME/.local/bin:$PATH"
fi

command -v uv >/dev/null 2>&1 || { warn "uv is not on PATH after install"; exit 1; }

# 2. Clone the repository, or update it if it already exists.
if [ -d "$OPENDESK_HOME/.git" ]; then
  info "Updating $OPENDESK_HOME"
  git -C "$OPENDESK_HOME" pull --ff-only
else
  info "Cloning $OPENDESK_REPO into $OPENDESK_HOME"
  mkdir -p "$(dirname "$OPENDESK_HOME")"
  git clone "$OPENDESK_REPO" "$OPENDESK_HOME"
fi

cd "$OPENDESK_HOME" || exit 1

# 3. Sync the Python virtual environment (ansible, ansible-lint, molecule).
info "Syncing Python dependencies (uv sync)"
uv sync

# 4. Install the Ansible collection dependencies into ./collections.
info "Installing Ansible collections"
uv run ansible-galaxy collection install -r collections/requirements.yml -p collections

# 5. Wire up direnv so the virtualenv activates automatically on `cd`.
if command -v direnv >/dev/null 2>&1; then
  if ! grep -qs "direnv hook bash" "$HOME/.bashrc"; then
    printf '\neval "$(direnv hook bash)"\n' >> "$HOME/.bashrc"
    info "Added direnv hook to ~/.bashrc"
  fi
  direnv allow "$OPENDESK_HOME" >/dev/null 2>&1 || true
fi

info "Setup complete"
cat <<EOF

opendesk is installed at: $OPENDESK_HOME

Next steps:
  cd $OPENDESK_HOME
  ./opendesk detect            # show which desktop playbook applies
  ./opendesk desktop           # run it against localhost
  ./opendesk play <playbook>   # run an explicit playbook
  ./opendesk role <role>       # run a single role

EOF
