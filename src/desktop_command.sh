local target playbook become_opts root
target="${args[target]:-localhost}"

# Run from the repository root so ansible.cfg and relative paths resolve.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root" || exit 1

playbook="$(opendesk_distro_playbook)" || exit 1

printf 'Detected desktop playbook: %s\n' "$playbook"

[ "$target" = "localhost" ] && become_opts="-K" || become_opts=""

echo "uv run ansible-playbook -l ${target} -b ${PLAYBOOK_DIR}/${playbook}.yml ${become_opts}"
uv run ansible-playbook -l "${target}" -b "${PLAYBOOK_DIR}/${playbook}.yml" ${become_opts}
