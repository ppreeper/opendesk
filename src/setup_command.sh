sudo apt update -y && sudo apt install -y python3-pip python3-venv pipenv direnv git

if grep -q "direnv hook bash" $HOME/.bashrc; then
  echo
else
  echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc
fi

source $HOME/.bashrc
