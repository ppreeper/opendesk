local target role_name become_opts root
target="${args[target]}"
role_name="${args[role]}"

# Run from the repository root so ansible.cfg and relative paths resolve.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root" || exit 1

[ "$target" = "localhost" ] && become_opts="-K" || become_opts=""

echo "uv run ansible-playbook -l ${target} -e role=${role_name} -b ${PLAYBOOK_DIR}/apply_role.yml ${become_opts}"
uv run ansible-playbook -l "${target}" -e "role=${role_name}" -b "${PLAYBOOK_DIR}/apply_role.yml" ${become_opts}
