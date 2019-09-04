cd $HOME

INSTALL_DIR="$HOME/dotfiles"
EXTRA_FILE="$INSTALL_DIR/bash_extra"
if [[ ! -f "$EXTRA_FILE" ]]; then
    echo "Dotfiles not found, downloading."

    if [[ ! -d "$INSTALL_DIR" ]]; then
        echo "$INSTALL_DIR not found, creating."
        mkdir "$INSTALL_DIR"
    fi

    cd "$INSTALL_DIR"
    curl -L https://github.com/Ryckes/dotfiles/tarball/master --output - 2>/dev/null \
        | tar -xz \
        && mv Ryckes-dotfiles-*/* . \
        && rmdir Ryckes-dotfiles-*

    if [[ ! -f "$EXTRA_FILE" ]]; then
        echo "Could not download dotfiles."
        exit 1
    fi
fi

cd $HOME
HINT=": dotfiles"
# Ampersands are special characters in sed.
INSTALL_COMMAND="$HINT \&\& . \"$HOME/dotfiles/bash_extra\""
grep "$HINT" .bashrc &>/dev/null

if [[ $? == "0" ]]; then
    echo "Dotfiles already installed, reinstalling."
    SED_PATTERN="s@^.*$HINT.*\$@$INSTALL_COMMAND@"
    sed -i "$SED_PATTERN" .bashrc
else
    echo "Setting up dotfiles for the first time."

    echo >> .bashrc
    echo "$INSTALL_COMMAND" >> .bashrc
fi
