#!/usr/bin/env bash
#
# install.sh -- bring a fresh Arch install up to match this dot-files setup.
#
# Assumes you have ALREADY:
#   * installed base Arch (kernel, bootloader, fstab)
#   * created a normal user in the 'wheel' group with sudo access
#   * got networking working (so pacman can reach the mirrors)
#
# Then, as that NORMAL user (never root):
#   git clone <this repo> ~/dot-files
#   cd ~/dot-files
#   ./bootstrap/install.sh
#
set -euo pipefail

# ---------------------------------------------------------------- paths -----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(cd "$SCRIPT_DIR/.." && pwd)"

# ------------------------------------------------------------- logging ------
c_reset=$'\e[0m'; c_blue=$'\e[1;34m'; c_green=$'\e[1;32m'
c_yellow=$'\e[1;33m'; c_red=$'\e[1;31m'
log()  { printf '%s==>%s %s\n'  "$c_blue"   "$c_reset" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$c_green"  "$c_reset" "$*"; }
warn() { printf '%s  !!%s %s\n' "$c_yellow" "$c_reset" "$*"; }
die()  { printf '%sERROR%s %s\n' "$c_red"   "$c_reset" "$*" >&2; exit 1; }

# -------------------------------------------------------------- guards ------
[[ ${EUID:-$(id -u)} -eq 0 ]] && die "Run as your normal user, not root (makepkg/yay refuse to run as root). sudo is invoked where needed."
command -v sudo >/dev/null || die "sudo not found -- install it and add your user to the wheel group first."
ping -c1 -W3 archlinux.org >/dev/null 2>&1 || warn "No network detected -- package steps will fail."

# strip comments + blank lines from a package list
pkglist() { grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$1"; }

# ============================================================ 1. multilib ===
# Required for Steam and the lib32-* GPU libraries.
enable_multilib() {
    if grep -q '^\[multilib\]' /etc/pacman.conf; then ok "multilib already enabled"; return; fi
    log "Enabling [multilib] repository"
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    sudo pacman -Sy
}

# ===================================================== 2. mirrors + update ===
update_system() {
    log "Refreshing mirror list with reflector (best-effort)"
    sudo pacman -S --needed --noconfirm reflector >/dev/null
    sudo reflector --latest 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist \
        || warn "reflector failed -- keeping existing mirrors"
    log "Full system upgrade"
    sudo pacman -Syu --noconfirm
}

# =================================================== 3. official packages ===
install_repo_pkgs() {
    log "Installing official repo packages from packages.txt"
    # shellcheck disable=SC2046
    sudo pacman -S --needed --noconfirm $(pkglist "$SCRIPT_DIR/packages.txt")
}

# =========================================================== 4. GPU stack ===
# GPU is hardware-specific, so we detect it instead of hardcoding.
# Handles hybrid laptops (Intel iGPU + NVIDIA dGPU -> installs BOTH stacks).
install_gpu() {
    local gpu; gpu="$(lspci | grep -Ei 'vga|3d|display' || true)"
    log "Detected display hardware:"; printf '     %s\n' "$gpu"
    local pkgs=(vulkan-tools)
    if grep -qi 'nvidia' <<<"$gpu"; then
        warn "NVIDIA found -> installing nvidia-open-dkms (see README for modeset notes)"
        pkgs+=(nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings libva-nvidia-driver)
    fi
    if grep -qiE 'intel' <<<"$gpu"; then
        pkgs+=(mesa vulkan-intel lib32-mesa lib32-vulkan-intel intel-media-driver)
    fi
    if grep -qiE 'amd|radeon|ati' <<<"$gpu"; then
        pkgs+=(mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon libva-mesa-driver)
    fi
    log "GPU packages: ${pkgs[*]}"
    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    log "Steam 32-bit runtime deps"
    sudo pacman -S --needed --noconfirm \
        lib32-gtk3 lib32-libxcomposite lib32-libxdamage lib32-libxi lib32-libxrandr lib32-libxtst \
        || warn "some lib32 Steam deps failed (fine if you don't use Steam)"
}

# ============================================================ 5. yay (AUR) ===
install_yay() {
    if command -v yay >/dev/null; then ok "yay already installed"; return; fi
    log "Bootstrapping yay from the AUR"
    local tmp; tmp="$(mktemp -d)"
    git clone --depth 1 https://aur.archlinux.org/yay.git "$tmp/yay"
    ( cd "$tmp/yay" && makepkg -si --noconfirm )
    rm -rf "$tmp"
}

# ======================================================== 6. AUR packages ===
install_aur_pkgs() {
    log "Installing AUR packages from aur.txt"
    # shellcheck disable=SC2046
    yay -S --needed --noconfirm $(pkglist "$SCRIPT_DIR/aur.txt")
}

# ===================================================== 7. dotfile symlinks ===
backup_and_link() {
    local src="$1" dst="$2"
    if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
        ok "already linked: $dst"; return
    fi
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" || -L "$dst" ]]; then
        local bak="$dst.bak.$(date +%s)"
        warn "backing up existing $dst -> $bak"
        mv "$dst" "$bak"
    fi
    ln -s "$src" "$dst"
    ok "linked: $dst -> $src"
}

deploy_dotfiles() {
    log "Deploying dotfiles via symlinks"
    backup_and_link "$DOTFILES/.bashrc"        "$HOME/.bashrc"
    backup_and_link "$DOTFILES/.bash_profile"  "$HOME/.bash_profile"
    backup_and_link "$DOTFILES/.tmux.conf"     "$HOME/.tmux.conf"
    backup_and_link "$DOTFILES/hypr"           "$HOME/.config/hypr"
    backup_and_link "$DOTFILES/nvim"           "$HOME/.config/nvim"
    backup_and_link "$DOTFILES/waybar"         "$HOME/.config/waybar"
    backup_and_link "$DOTFILES/dunst"          "$HOME/.config/dunst"
    backup_and_link "$DOTFILES/kitty"          "$HOME/.config/kitty"
    backup_and_link "$DOTFILES/wofi"           "$HOME/.config/wofi"
    backup_and_link "$DOTFILES/yazi"           "$HOME/.config/yazi"
    backup_and_link "$DOTFILES/starship.toml"  "$HOME/.config/starship.toml"
    backup_and_link "$DOTFILES/cava/config"    "$HOME/.config/cava/config"
    backup_and_link "$DOTFILES/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
    backup_and_link "$DOTFILES/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
    # gruvbox-dark named-color override for GTK4/libadwaita apps (pwvucontrol etc.)
    backup_and_link "$DOTFILES/gtk-4.0/gtk.css"       "$HOME/.config/gtk-4.0/gtk.css"
    backup_and_link "$DOTFILES/gsimplecal/config"     "$HOME/.config/gsimplecal/config"

    # WirePlumber 0.5 SPA-JSON drop-ins (pins the MOTU M4 to its "Direct"
    # profile; harmless no-op on machines without the interface).
    backup_and_link "$DOTFILES/wireplumber/wireplumber.conf.d" "$HOME/.config/wireplumber/wireplumber.conf.d"

    # Gruvbox theme for the gsimplecal calendar popup. GTK3 searches
    # ~/.local/share/themes; hyprland.conf launches it via GTK_THEME=Gruvbox-gsimplecal.
    backup_and_link "$DOTFILES/gtk/Gruvbox-gsimplecal" "$HOME/.local/share/themes/Gruvbox-gsimplecal"

    # SilverXMod cursor theme: downloaded, not packaged, so the files ride in the
    # repo. Deploy the theme plus the XDG "default" pointer that selects it (the
    # XCURSOR_THEME env in hypr/hyprland.conf already names it for XWayland apps).
    backup_and_link "$DOTFILES/local/share/icons/SilverXMod"          "$HOME/.local/share/icons/SilverXMod"
    backup_and_link "$DOTFILES/local/share/icons/default/index.theme" "$HOME/.local/share/icons/default/index.theme"

    # Icon + cursor theme also via gsettings (GTK/libadwaita read this on
    # Hyprland without a settings daemon).
    if command -v gsettings >/dev/null; then
        gsettings set org.gnome.desktop.interface icon-theme   'Papirus-Dark' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-theme 'SilverXMod'   2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-size  40             2>/dev/null || true
        # libadwaita derives its hover/border shades from the color scheme; force
        # dark so the gruvbox-dark gtk.css overrides above sit on the right base.
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'  2>/dev/null || true
    fi

    # This machine is the laptop -> pick the laptop host-config variants.
    # (Relative symlinks inside the repo dir; host.conf / config.jsonc are gitignored.)
    log "Selecting LAPTOP host-config variants"
    ln -sf host.laptop.conf    "$DOTFILES/hypr/host.conf"
    ln -sf config.laptop.jsonc "$DOTFILES/waybar/config.jsonc"
    ok "hypr/host.conf -> host.laptop.conf  |  waybar/config.jsonc -> config.laptop.jsonc"
}

# ====================================================== 8. caps2esc remap ===
# Recreates the /etc/ files that turn Caps Lock into Esc (tap) / Ctrl (hold).
setup_caps2esc() {
    log "Configuring caps2esc (Caps Lock -> Esc/Ctrl)"
    sudo install -d /etc/interception
    sudo tee /etc/interception/udevmon.yaml >/dev/null <<'YAML'
- JOB:
    intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_LEFTCTRL]
YAML
    sudo tee /etc/systemd/system/interception.service >/dev/null <<'UNIT'
[Unit]
Description=Interception Tools udevmon
After=local-fs.target

[Service]
ExecStart=/usr/bin/udevmon -c /etc/interception/udevmon.yaml
Restart=always
User=root

[Install]
WantedBy=multi-user.target
UNIT
    sudo systemctl daemon-reload
    sudo systemctl enable --now interception.service
}

# ================================================== 9. services + groups ====
enable_services() {
    log "Enabling system services"
    sudo systemctl enable --now NetworkManager.service
    sudo systemctl enable --now bluetooth.service
    sudo systemctl enable --now power-profiles-daemon.service
    sudo systemctl enable docker.service          # start after re-login
    log "Adding $USER to the docker group (takes effect after re-login)"
    sudo usermod -aG docker "$USER" || true
    log "Enabling per-user PipeWire audio"
    systemctl --user enable pipewire.socket pipewire-pulse.socket wireplumber.service 2>/dev/null \
        || warn "could not enable user audio sockets (will socket-activate on demand)"
}

# ====================================================== 10. rust toolchain ===
setup_rust() {
    command -v rustup >/dev/null || return 0
    log "Installing default Rust toolchain (stable)"
    rustup default stable || warn "rustup default failed -- run 'rustup default stable' yourself later"
}

# ===================================== 11. local rust tools (clock-map popup) ==
build_clock_map() {
    command -v cargo >/dev/null || { warn "cargo not found -- skipping clock-map build"; return 0; }
    log "Building + installing clock-map (waybar clock-pill time-zone map)"
    cargo install --path "$SCRIPT_DIR/../clock-map" \
        || warn "clock-map build failed -- run 'cargo install --path clock-map' yourself later"
}

# ===================================================================== main ==
main() {
    enable_multilib
    update_system
    install_repo_pkgs
    install_gpu
    install_yay
    install_aur_pkgs
    deploy_dotfiles
    setup_caps2esc
    enable_services
    setup_rust
    build_clock_map

    cat <<EOF

${c_green}====================  bootstrap complete  ====================${c_reset}

MANUAL steps still needed:

  1. Restore the files that live OUTSIDE this repo (copy from old machine):
       ~/.secrets          ~/.openai.env        ~/.dircolors
       ~/misc/.api_keys    ~/scripts/           ~/wallpapers/
     (Hyprland startup + day/night/audio aliases + wallpaper depend on these.)

  2. Log out and back in -- needed for the docker group and audio sockets.

  3. Check the display name:  hyprctl monitors
     If your internal panel is NOT eDP-1, edit  hypr/host.laptop.conf .

  4. NVIDIA only: if you get a black screen, add  nvidia_drm.modeset=1  to the
     kernel cmdline and the nvidia modules to mkinitcpio (see Arch wiki).

  5. Reboot. Logging in on tty1 auto-starts Hyprland (via ~/.bash_profile).

EOF
}

main "$@"
