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

# ---------------
# - Shell setup -
# ---------------
cd $HOME
HINT=": dotfiles"
# Ampersands are special characters in sed. They must not be escaped
# for the first-time setup, so we add the hint and then run the sed
# command we'll use for updating existing configs.
INSTALL_COMMAND="$HINT \&\& . \"$HOME/dotfiles/bash_extra\""


grep "$HINT" .bashrc &>/dev/null
if [[ $? == "0" ]]; then
    echo "Dotfiles already installed, reinstalling."
else
    echo "Setting up dotfiles for the first time."

    echo >> .bashrc
    echo "$HINT" >> .bashrc
fi
SED_PATTERN="s@^.*$HINT.*\$@$INSTALL_COMMAND@"
sed -i "$SED_PATTERN" .bashrc

# ---------------
# - Emacs setup -
# ---------------
if [[ ! -d "$HOME/bin" ]]; then
    echo "Creating $HOME/bin"
    mkdir "$HOME/bin"
fi

EC_PATH="$HOME/bin/ec"
if [[ ! -f "$EC_PATH" ]]; then
    # If ~/bin/ec already exists, don't touch it.
    echo "Setting up $EC_PATH"
    cp "$INSTALL_DIR/ec" "$EC_PATH"
    chmod +x "$EC_PATH"
fi

which emacsclient &>/dev/null
if [[ "$?" != 0 ]]; then
    echo "emacsclient not found in path, ec won't work."
fi
