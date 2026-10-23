# Post-Installation Setup

Commands to run after initial system installation.
These configure services and applications that require user interaction
or cannot be fully automated through Nix.

## Server and desktop

```bash
tailscale up
```

## Desktop

Run these commands after first login:

```bash
flatpak install -y flathub com.heroicgameslauncher.hgl com.usebottles.bottles
```

**What these do:**

- **Tailscale**: Connect to your private network
- **Flatpak**: Install gaming tools
  (Heroic for Epic/GOG, Bottles for Windows apps)
