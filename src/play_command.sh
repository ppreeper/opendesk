local target playbook become_opts root
target="${args[target]}"
playbook="${args[playbook]}"

# Run from the repository root so ansible.cfg and relative paths resolve.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root" || exit 1

[ "$target" = "localhost" ] && become_opts="-K" || become_opts=""

echo "uv run ansible-playbook -l ${target} -b ${PLAYBOOK_DIR}/${playbook}.yml ${become_opts}"
uv run ansible-playbook -l "${target}" -b "${PLAYBOOK_DIR}/${playbook}.yml" ${become_opts}
