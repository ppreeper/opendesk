local root
# Run from the repository root so ansible.cfg and relative paths resolve.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root" || exit 1

uv run ansible-playbook --syntax-check ${PLAYBOOK_DIR}/${args[playbook]}.yml
