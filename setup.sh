pushd $HOME

INSTALL_DIR='~/dotfiles'
EXTRA_FILE="$INSTALL_DIR/bash_extra"
if [[ ! -f "$EXTRA_FILE" ]]; then
    echo "Dotfiles not found, downloading."
    echo "ERR: Not implemented yet." >&2
fi

if [[ ! -f "$EXTRA_FILE" ]]; then
    echo "Could not download dotfiles."
    exit 1    
fi

HINT=": dotfiles"
grep "$HINT" .bashrc &>/dev/null

if [[ $? == "0" ]]; then
    echo "Dotfiles already installed, reinstalling."
    # TODO: fix .bashrc to update ot latest version, in case the INSTALL_COMMAND changes.
else
    echo "Setting up dotfiles for the first time."

    INSTALL_COMMAND="\`$HINT\` && echo '. ~/dotfiles/bash_extra'"
    echo >> .bashrc
    echo "$INSTALL_COMMAND" >> .bashrc
fi
