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

HINT=": dotfiles"
grep "$HINT" .bashrc &>/dev/null

if [[ $? == "0" ]]; then
    echo "Dotfiles already installed, reinstalling."
    # TODO: fix .bashrc to update ot latest version, in case the INSTALL_COMMAND changes.
else
    echo "Setting up dotfiles for the first time."

    INSTALL_COMMAND="\`$HINT\` && echo '. $HOME/dotfiles/bash_extra'"
    echo >> .bashrc
    echo "$INSTALL_COMMAND" >> .bashrc
fi
