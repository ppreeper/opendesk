# opendesk

Configuration management for desktop Linux, built on Ansible.

The current focus is Linux desktop provisioning from a fresh install:

| Distribution | Playbook |
| --- | --- |
| Linux Mint 22 (Ubuntu-based) | `playbooks/desktop-mint22.yml` |
| LMDE 7 (Debian-based) | `playbooks/desktop-lmde7.yml` |

## Quick start

On a fresh machine, bootstrap the prerequisites (uv, a Python virtual
environment, and the Ansible collections) with a single command:

```bash
wget -qO- https://raw.githubusercontent.com/ppreeper/opendesk/main/opendesk | bash -s -- setup
```

The `setup` command:

1. installs [uv](https://docs.astral.sh/uv/) if it is missing,
2. clones (or updates) the repository into `~/.local/share/opendesk`,
3. runs `uv sync` to create the virtual environment with Ansible,
4. installs the Ansible collections into `./collections`,
5. wires up a `direnv` hook so the virtualenv activates automatically.

Once bootstrapped, change into the checkout and use the CLI:

```bash
cd ~/.local/share/opendesk

./opendesk detect          # show the detected distribution and playbook
./opendesk desktop         # run the matching desktop playbook on localhost
./opendesk play <playbook> # run an explicit playbook (e.g. desktop-lmde7)
./opendesk role <role>     # apply a single role (e.g. baseline)
./opendesk syntax <playbook>
./opendesk ping [target]
```

The `desktop` command reads `/etc/os-release` and automatically selects
`desktop-mint22` or `desktop-lmde7`.

## Repository layout

```
ansible.cfg                 Ansible configuration (inventory, roles, collections)
collections/requirements.yml Ansible Galaxy collection dependencies
inventory/                  Inventories and group/host vars
playbooks/                  Playbooks and roles
  desktop-mint22.yml        Linux Mint 22 desktop
  desktop-lmde7.yml         LMDE 7 desktop
  roles/                    Ansible roles
src/                        bashly source for the `opendesk` CLI
opendesk                    Generated CLI (bashly output, committed)
```

## Development

The `opendesk` CLI is generated from `src/` with
[bashly](https://bashly.dannyb.co/):

```bash
make build     # regenerate ./opendesk (runs bashly in a container)
```

Linting and role tests:

```bash
make lint      # uv run ansible-lint
make test      # uv run molecule test
```
