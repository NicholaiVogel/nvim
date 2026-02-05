#!/bin/bash
set -e  # exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper function for colored output
print_green() { echo -e "${GREEN}$1${NC}"; }
print_yellow() { echo -e "${YELLOW}$1${NC}"; }
print_blue() { echo -e "${BLUE}$1${NC}"; }

# Helper function for prompts with defaults
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local result
    read -p "$(echo -e "${BLUE}$prompt${NC} [${GREEN}$default${NC}]: ")" result
    echo "${result:-$default}"
}

# This script sets up dotfiles and installs opencode:
# - Backs up and symlinks .tmux.conf from dotfiles/ to ~/
# - Backs up and symlinks starship.toml from dotfiles/ to ~/.config/
# - Installs opencode CLI if not already present
# - Generates config.json with interactive prompts

NVIM_CONFIG_DIR="$HOME/.config/nvim"

# ============================================
# Section 1: Interactive Config Generation
# ============================================
print_green "╔════════════════════════════════════════════╗"
print_green "║     Neovim Configuration Setup Wizard      ║"
print_green "╚════════════════════════════════════════════╝"
echo ""

# Check if config.json already exists
if [ -f "$NVIM_CONFIG_DIR/config.json" ]; then
    print_yellow "Existing config.json found."
    read -p "$(echo -e "${YELLOW}Overwrite? (y/N): ${NC}")" overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        print_blue "Keeping existing config.json"
        SKIP_CONFIG=true
    else
        # Backup existing config
        cp "$NVIM_CONFIG_DIR/config.json" "$NVIM_CONFIG_DIR/config.json.backup.$(date +%Y%m%d%H%M%S)"
        print_green "Backed up existing config.json"
        SKIP_CONFIG=false
    fi
else
    SKIP_CONFIG=false
fi

if [ "$SKIP_CONFIG" = false ]; then
    echo ""
    print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_blue "  Section 1: Paths"
    print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    OBSIDIAN_VAULT=$(prompt_with_default "Obsidian vault path" "~/Documents/obsidian-vault/")
    SRC_DIR=$(prompt_with_default "Source code directory" "~/.local/src/")
    SCRIPTS_DIR=$(prompt_with_default "Scripts directory" "~/scripts/")
    WALLPAPER_SCRIPT=$(prompt_with_default "Wallpaper script path" "~/scripts/pywal/wallpapermenu.sh")

    echo ""
    print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_blue "  Section 2: Editor Settings"
    print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    TAB_SIZE=$(prompt_with_default "Tab size" "4")
    SCROLL_OFFSET=$(prompt_with_default "Scroll offset" "8")
    echo ""
    print_yellow "Theme variants: wave (default), dragon (dark), lotus (light)"
    THEME=$(prompt_with_default "Kanagawa theme variant" "wave")

    echo ""
    print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_blue "  Section 3: Languages"
    print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    print_yellow "Enter comma-separated lists"
    echo ""
    LSP_SERVERS=$(prompt_with_default "LSP servers" "ts_ls, eslint, jsonls, html, cssls, tailwindcss")
    TS_LANGUAGES=$(prompt_with_default "Treesitter languages" "lua, vim, bash, javascript, typescript, tsx, json, yaml, html, css")

    echo ""
    print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_blue "  Section 4: AI Settings"
    print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    print_yellow "Claude models: claude-sonnet-4-5, claude-opus-4, haiku"
    AI_MODEL=$(prompt_with_default "Claude Code model" "claude-sonnet-4-5")
    OPENCODE_MODEL=$(prompt_with_default "OpenCode model (with provider prefix)" "anthropic/claude-sonnet-4-5")

    # Convert comma-separated strings to JSON arrays
    format_json_array() {
        echo "$1" | sed 's/,/\n/g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
        awk 'BEGIN{printf "["} NR>1{printf ", "} {printf "\"%s\"", $0} END{printf "]"}'
    }

    LSP_SERVERS_JSON=$(format_json_array "$LSP_SERVERS")
    TS_LANGUAGES_JSON=$(format_json_array "$TS_LANGUAGES")

    # Generate config.json
    cat > "$NVIM_CONFIG_DIR/config.json" << EOF
{
    "paths": {
        "obsidianVault": "$OBSIDIAN_VAULT",
        "srcDirectory": "$SRC_DIR",
        "scriptsDirectory": "$SCRIPTS_DIR",
        "wallpaperScript": "$WALLPAPER_SCRIPT"
    },
    "editor": {
        "tabSize": $TAB_SIZE,
        "scrollOffset": $SCROLL_OFFSET,
        "theme": "$THEME"
    },
    "ai": {
        "model": "$AI_MODEL",
        "openCodeModel": "$OPENCODE_MODEL"
    },
    "lsp": {
        "servers": $LSP_SERVERS_JSON
    },
    "treesitter": {
        "languages": $TS_LANGUAGES_JSON
    }
}
EOF

    echo ""
    print_green "✓ config.json generated successfully!"
    echo ""
fi

# ============================================
# Section 2: Dotfile Symlinks
# ============================================
print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_blue "  Setting up dotfile symlinks..."
print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check and backup/symlink .tmux.conf
TMUX_TARGET="$HOME/.config/nvim/dotfiles/.tmux.conf"
if [ -L ~/.tmux.conf ] && [ "$(readlink ~/.tmux.conf)" = "$TMUX_TARGET" ]; then
  print_green "✓ .tmux.conf already linked correctly"
elif [ -f ~/.tmux.conf ] || [ -L ~/.tmux.conf ]; then
  cp ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d%H%M%S)
  ln -sf "$TMUX_TARGET" ~/.tmux.conf
  print_green "✓ .tmux.conf backed up and linked"
elif [ -f "$TMUX_TARGET" ]; then
  ln -sf "$TMUX_TARGET" ~/.tmux.conf
  print_green "✓ .tmux.conf linked"
fi

# Check and backup/symlink starship.toml
STARSHIP_TARGET="$HOME/.config/nvim/dotfiles/starship.toml"
if [ -L ~/.config/starship.toml ] && [ "$(readlink ~/.config/starship.toml)" = "$STARSHIP_TARGET" ]; then
  print_green "✓ starship.toml already linked correctly"
elif [ -f ~/.config/starship.toml ] || [ -L ~/.config/starship.toml ]; then
  cp ~/.config/starship.toml ~/.config/starship.toml.backup.$(date +%Y%m%d%H%M%S)
  ln -sf "$STARSHIP_TARGET" ~/.config/starship.toml
  print_green "✓ starship.toml backed up and linked"
elif [ -f "$STARSHIP_TARGET" ]; then
  mkdir -p ~/.config
  ln -sf "$STARSHIP_TARGET" ~/.config/starship.toml
  print_green "✓ starship.toml linked"
fi

# ============================================
# Section 3: OpenCode Installation
# ============================================
echo ""
print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_blue "  Checking OpenCode installation..."
print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ! command -v opencode &> /dev/null; then
  print_yellow "Installing OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
  print_green "✓ OpenCode installed"
else
  print_green "✓ OpenCode already installed"
fi

# ============================================
# Section 4: Shell Aliases
# ============================================
echo ""
print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_blue "  Setting up shell aliases..."
print_blue "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

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
        print_green "✓ Shell aliases and functions added to $SHELL_RC"
    else
        print_green "✓ Shell aliases already exist in $SHELL_RC"
    fi

    # Clean up
    rm "$TEMP_ALIASES"
else
    print_yellow "⚠ No .bashrc or .zshrc found, skipping shell config setup"
fi

# ============================================
# Done!
# ============================================
echo ""
print_green "╔════════════════════════════════════════════╗"
print_green "║           Setup Complete!                  ║"
print_green "╚════════════════════════════════════════════╝"
echo ""
print_blue "Run 'nvim' to start using your configuration."
print_blue "Your config is stored in: $NVIM_CONFIG_DIR/config.json"
echo ""
