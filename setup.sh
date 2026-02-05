#!/bin/bash
set -e  # exit on error

# This script sets up dotfiles and installs opencode:
# - Backs up and symlinks .tmux.conf from dotfiles/ to ~/
# - Backs up and symlinks starship.toml from dotfiles/ to ~/.config/
# - Installs opencode CLI if not already present

# Check and backup/symlink .tmux.conf
TMUX_TARGET="$HOME/.config/nvim/dotfiles/.tmux.conf"
if [ -L ~/.tmux.conf ] && [ "$(readlink ~/.tmux.conf)" = "$TMUX_TARGET" ]; then
  echo ".tmux.conf already linked correctly"
elif [ -f ~/.tmux.conf ] || [ -L ~/.tmux.conf ]; then
  cp ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d%H%M%S)
  ln -sf "$TMUX_TARGET" ~/.tmux.conf
  echo ".tmux.conf backed up and linked"
elif [ -f "$TMUX_TARGET" ]; then
  ln -sf "$TMUX_TARGET" ~/.tmux.conf
  echo ".tmux.conf linked"
fi

# Check and backup/symlink starship.toml
STARSHIP_TARGET="$HOME/.config/nvim/dotfiles/starship.toml"
if [ -L ~/.config/starship.toml ] && [ "$(readlink ~/.config/starship.toml)" = "$STARSHIP_TARGET" ]; then
  echo "starship.toml already linked correctly"
elif [ -f ~/.config/starship.toml ] || [ -L ~/.config/starship.toml ]; then
  cp ~/.config/starship.toml ~/.config/starship.toml.backup.$(date +%Y%m%d%H%M%S)
  ln -sf "$STARSHIP_TARGET" ~/.config/starship.toml
  echo "starship.toml backed up and linked"
elif [ -f "$STARSHIP_TARGET" ]; then
  mkdir -p ~/.config
  ln -sf "$STARSHIP_TARGET" ~/.config/starship.toml
  echo "starship.toml linked"
fi

# Check if opencode is installed, if not, install opencode
if ! command -v opencode &> /dev/null; then
  curl -fsSL https://opencode.ai/install | bash
fi

# Detect shell config file
SHELL_RC=""
if [ -f ~/.zshrc ]; then
    SHELL_RC=~/.zshrc
elif [ -f ~/.bashrc ]; then
    SHELL_RC=~/.bashrc
fi

# Only proceed if we found a shell config
if [ -n "$SHELL_RC" ]; then
    # Create a temporary file with all our aliases and functions
    TEMP_ALIASES=$(mktemp)
    
    cat > "$TEMP_ALIASES" << 'EOF'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline'

# fastfetch
alias ff='fastfetch'

# Claude Aliases
alias cldy='claude --dangerously-skip-permissions'
alias cldyh='claude --dangerously-skip-permissions --model haiku'
alias cldys='claude --dangerously-skip-permissions --model sonnet'
alias cldyo='claude --dangerously-skip-permissions --model opus'

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip () {
    # Internal IP Lookup - auto-detect default interface
    if command -v ip &> /dev/null; then
        local iface=$(ip route | grep default | awk '{print $5}' | head -1)
        echo -n "Internal IP: "
        ip addr show "$iface" | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -s -4 ifconfig.me
    echo  # newline after curl output
}

# Automatically do an ls after each cd
if [[ -n "$ZSH_VERSION" ]]; then
    chpwd() { ls }
else
    cd() {
        if [ -n "$1" ]; then
            builtin cd "$@" && ls
        else
            builtin cd ~ && ls
        fi
    }
fi

# Create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

# Move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Check the window size after each command (bash only)
[[ -n "$BASH_VERSION" ]] && shopt -s checkwinsize

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias spico='sudo pico'
alias snano='sudo nano'
alias vim='nvim'
EOF

    # Check if these aliases/functions already exist in the shell config
    # Look for a marker comment or key aliases
    if ! grep -q "# Git shortcuts" "$SHELL_RC" && ! grep -q "alias gs='git status'" "$SHELL_RC"; then
        # Append to shell config
        echo "" >> "$SHELL_RC"
        echo "# Added by nvim dotfiles setup" >> "$SHELL_RC"
        cat "$TEMP_ALIASES" >> "$SHELL_RC"
        echo "Shell aliases and functions added to $SHELL_RC"
    else
        echo "Shell aliases already exist in $SHELL_RC, skipping..."
    fi
    
    # Clean up
    rm "$TEMP_ALIASES"
else
    echo "No .bashrc or .zshrc found, skipping shell config setup"
fi
