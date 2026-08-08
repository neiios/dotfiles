this repository contains my set of dotfiles

dotfiles are managed using a file-based dotfile manager tool `dotc`
filenames are verbatim: layers/<layer>/files/ mirrors $HOME, so layers/base/files/.zshrc deploys to ~/.zshrc
stacks.toml maps a machine's stack name to an ordered list of layers, later layers winning per path

workflow (repo -> home):
- edited managed files in the repository: `dotc apply`

workflow (home -> repo):
- already managed and changed in $HOME: `dotc sync [path...]`
- new unmanaged file in $HOME: `dotc add [--layer <name>] <path>...`

use `dotc status` to see what differs in either direction

~/dotfiles/bin is on PATH and is used for various scripts
