# bootstrap

Automated setup for a fresh Arch install, mirroring this dot-files config.

## Prerequisites
- Base Arch installed (kernel, bootloader, fstab)
- A normal user in the `wheel` group with sudo
- Working network

## Usage
```sh
git clone <repo> ~/dot-files
cd ~/dot-files
./bootstrap/install.sh
```

## What it does
1. Enables the `multilib` repo (Steam + lib32 GPU libs)
2. Refreshes mirrors (reflector) and runs a full update
3. Installs `packages.txt` (official repo)
4. **Detects the GPU** and installs the matching driver stack
   (NVIDIA / AMD / Intel; installs both on a hybrid laptop)
5. Bootstraps `yay`, then installs `aur.txt`
6. Symlinks dotfiles into place (backs up anything pre-existing)
7. Recreates the caps2esc Caps Lock remap under `/etc/interception/`
8. Enables services: NetworkManager, bluetooth, power-profiles-daemon,
   docker, interception
9. Sets the default Rust toolchain

## Per-machine config
Monitor-specific bits live behind **gitignored selector symlinks** so the
desktop and laptop can share everything else:

| symlink (gitignored)   | desktop ->            | laptop ->            |
|------------------------|-----------------------|----------------------|
| `hypr/host.conf`       | `host.desktop.conf`   | `host.laptop.conf`   |
| `waybar/config.jsonc`  | `config.desktop.jsonc`| `config.laptop.jsonc`|

`install.sh` points these at the **laptop** variants.

## NOT in this repo — restore manually on a new machine
`~/.secrets`, `~/.openai.env`, `~/.dircolors`, `~/misc/.api_keys`,
`~/scripts/` (audio.sh, day.sh, night.sh), and `~/wallpapers/`.
