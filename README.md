# dotfiles

## Must install
- Font: [MesloLGS NF](https://github.com/romkatv/powerlevel10k/blob/master/font.md#manual-font-installation)
- [WezTerm](https://wezterm.org/index.html), then install `wezterm` TERM definition:
  ```bash
  $ tempfile=$(mktemp) \
    && curl -o $tempfile https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo \
    && tic -x -o ~/.terminfo $tempfile \
    && rm $tempfile
  ```
- [pyenv](https://github.com/pyenv/pyenv)
- [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
- [oh-my-zsh](https://ohmyz.sh/)
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
  - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh)
