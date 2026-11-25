if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
fi

printf 'Distribution: %s\n' "${PRETTY_NAME:-unknown}"

if playbook="$(opendesk_distro_playbook)"; then
  printf 'Desktop playbook: %s\n' "$playbook"
else
  exit 1
fi
