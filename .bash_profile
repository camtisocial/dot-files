#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# pipx / user-local binaries
export PATH="$HOME/.local/bin:$PATH"

# Auto-start Hyprland on the first virtual terminal (tty1).
# Logging in on tty1 drops you straight into the desktop; other TTYs stay text.
if [[ -z "${WAYLAND_DISPLAY:-}" && -z "${DISPLAY:-}" && "$(tty)" == "/dev/tty1" ]]; then
    exec Hyprland
fi
