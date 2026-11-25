local root
# Run from the repository root so ansible.cfg and relative paths resolve.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root" || exit 1

if [ -z "${args[target]}" ]; then
  uv run ansible all -m ping -v
else
  uv run ansible ${args[target]} -m ping -v
fi
