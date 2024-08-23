#!/bin/bash

# Fail script on errors
set -Eeuxo pipefail

trap "echo Encountered failure when running install.sh script!" ERR

START_TIME=$(date +%s)

# Identify platform and package manager
PLATFORM=""
PACKAGE_MANAGER=""
if [ -f /etc/redhat-release ] || [  -f /etc/os-release ]; then
    PLATFORM="AL2"
    PACKAGE_MANAGER="yum"
fi

if [ -f /etc/lsb-release ]; then
    PLATFORM="UBUNTU"
    PACKAGE_MANAGER="apt-get"
fi

if [  "$(uname)" == "Darwin" ]; then
    PLATFORM="MACOS"
    PACKAGE_MANAGER="brew"
fi

# Functions BEGIN
function backup_and_copy_file() {
	if [ "$#" -ne 2 ]; then
		echo "Error: source and destination file arguments are required!!! No. of arguments Passed = $#, Arguments = $*"
		return 1
    fi
    local src_file_path="$1"
    local dest_file_path="$2"

    if [ -e "$dest_file_path" ]; then
        mv "$dest_file_path" "$dest_file_path.bak"
        echo "Backup created: $dest_file_path.bak"
    fi

    cp "$src_file_path" "$dest_file_path"
}

function copy_config_files() {
    echo "Started copying config files"
    backup_and_copy_file ./vimrc "$HOME/.vimrc"
    backup_and_copy_file ./tmux.conf "$HOME/.tmux.conf"
    backup_and_copy_file ./screenrc "$HOME/.screenrc"
    backup_and_copy_file ./ackrc "$HOME/.ackrc"
    backup_and_copy_file ./vrapperrc "$HOME/.vrapperrc"
    backup_and_copy_file ./ideavimrc "$HOME/.ideavimrc"
    backup_and_copy_file ./gitignore "$HOME/.gitignore"
    backup_and_copy_file ./gitconfig "$HOME/.gitconfig"
    echo "Completed copying config files"
}

function install_tpm_and_plugins() {
    echo "Started installing tmux plugin manager and plugins"
    # Patch for AL2
    if [ "$PLATFORM" == "AL2" ]; then
        export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"
    fi
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    eval "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"
    echo "Completed installing tmux plugin manager and plugins"
}

function add_shortcuts_to_bashrc() {
    echo "Adding shortcuts to bashrc"
    if grep -v '# Custom Aliases added by ravikiranj dotfiles' "$HOME/.bashrc" > /dev/null; then
        cat ./bashrc_shortcuts >> "$HOME/.bashrc"
    fi
}

function install_oh_my_zsh_plugins() {
    OMZ_CUSTOM="$HOME/.oh-my-zsh/custom"
    echo "Started install zsh plugins"
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "$OMZ_CUSTOM/plugins/autoupdate"
    echo "Completed install zsh plugins"

    echo "Updating plugins in $HOME/.zshrc"
    if [ -f "$HOME/.zshrc" ]; then
        sed -i.bak 's/^plugins=.*/plugins=(git virtualenv autoupdate)/' "$HOME/.zshrc"
    fi
}

function add_shortcuts_to_zshrc() {
    echo "Adding shortcuts to zshrc"
    ZSHRC_CONFIG="$HOME/.zshrc"
    if [ ! -f "${ZSHRC_CONFIG}" ]; then
        touch "${ZSHRC_CONFIG}"
    fi
    if grep -v '# Custom Aliases added by ravikiranj dotfiles' "${ZSHRC_CONFIG}" > /dev/null; then
        cat ./zshrc_shortcuts >> "${ZSHRC_CONFIG}"
    fi
}

function install_powerlevel10k() {
    echo "Started installing powerlevel10k theme for zsh"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    echo "Changing theme to powerlevel10k"

    if [ -f "$HOME/.zshrc" ]; then
        sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
    fi

    echo "Copying p10k.zsh configuration"
    cp p10k.zsh "$HOME/.p10k.zsh"
    echo "Completed installing powerlevel10k theme for zsh"
}

function install_ohmyzsh() {
    echo "Started installing ohmyzsh"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    install_oh_my_zsh_plugins
    add_shortcuts_to_zshrc
    echo "Completed installing ohmyzsh"
}

function install_powerline_fonts() {
    echo "Started installing powerline fonts"
    pushd /tmp

    # clone
    git clone https://github.com/powerline/fonts.git --depth=1

    # install
    cd fonts
    ./install.sh

    popd
    echo "Completed installing powerline fonts"
}

function install_nerd_fonts() {
    echo "Started installing nerd fonts"
    ./install_nerd_fonts.sh
    echo "Completed installing nerd fonts"
}

function install_fzf() {
    echo "Started installing fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
    echo "Completed installing fzf"
}

function install_cargo() {
    echo "Started installing cargo"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    echo "Completed installing cargo"
}

function install_cargo_packages() {
    echo "Started installing cargo packages"
    eval "$HOME/.cargo/bin/cargo install ripgrep git-delta bat fd-find dua-cli"
    echo "Completed installing cargo"
}

function install_vim_plugins() {
    echo "Started installing vim plugins"
    # echo sends newline to any confirmation prompts that might come up
    echo | vim +PluginInstall +qall &> /dev/null
    echo "Completed installing vim plugins"
}

function change_default_shell() {
    eval "chsh -s $(which zsh)"
}
# Functions END

# Start Installation
copy_config_files
add_shortcuts_to_bashrc

if [ "$PACKAGE_MANAGER" == "yum" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER update && sudo $PACKAGE_MANAGER install -y gcc gcc-c++ kernel-devel make util-linux-user git vim tmux screen ack curl zsh wget jq tar
    install_vim_plugins
    install_tpm_and_plugins
    install_ohmyzsh
    install_fzf
    install_powerlevel10k
    install_powerline_fonts
    install_nerd_fonts
    install_cargo
    install_cargo_packages
    change_default_shell
elif [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    echo "Installing packages via $PACKAGE_MANAGER"
    sudo $PACKAGE_MANAGER update && sudo $PACKAGE_MANAGER install -y build-essential git vim tmux screen ack curl zsh ripgrep wget duf jq
    install_vim_plugins
    install_tpm_and_plugins
    install_ohmyzsh
    install_fzf
    install_powerlevel10k
    install_powerline_fonts
    install_nerd_fonts
    install_cargo
    install_cargo_packages
    change_default_shell
elif [ "$PACKAGE_MANAGER" == "brew" ]; then
    if which "$PACKAGE_MANAGER"; then
        echo "$PACKAGE_MANAGER is installed"
        $PACKAGE_MANAGER install git vim tmux screen coreutils ack curl zsh ripgrep wget duf jq
        install_vim_plugins
        install_tpm_and_plugins
        install_ohmyzsh
        install_fzf
        install_powerlevel10k
        install_powerline_fonts
        install_nerd_fonts
        install_cargo
        install_cargo_packages
        change_default_shell
    else
        echo "$PACKAGE_MANAGER is not installed, please install $PACKAGE_MANAGER by following instructions at https://brew.sh/ and run install.sh again"
    fi
else
    echo "Your operating system is not supported for installing packages, sorry!"
    exit 1
fi
# End Installation

# Post Install steps
echo "Your system dotfiles setup is complete."
echo "You should now do the following steps to complete the installations"
echo "1. Change terminal font to Meslo Nerd Font"

# Timing data
END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))
TOTAL_MINUTES=$((TOTAL_TIME / 60))
TOTAL_SECONDS=$((TOTAL_TIME % 60))
echo "Total Execution Time: $TOTAL_MINUTES minutes and $TOTAL_SECONDS seconds"
