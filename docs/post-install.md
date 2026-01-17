# Post-Installation Setup

Commands to run after initial system installation. These configure services and applications that require user interaction or cannot be fully automated through Nix.

## Desktop

Run these commands after first login:

```bash
sudo tailscale up --operator=$USER

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak config --set languages "zh;ja;en"
flatpak install -y flathub com.heroicgameslauncher.hgl com.usebottles.bottles

sudo virsh net-autostart default
```

**What these do:**

- **Tailscale**: Connect to your private network and allow non-root management
- **Flatpak**: Add Flathub repository and install gaming tools (Heroic for Epic/GOG, Bottles for Windows apps)
- **libvirt**: Enable automatic start of default virtual network for VMs
