---
name: terminal-config
description: This skill should be used when the user asks to "configure ghostty", "set up terminal", "change terminal font", "configure kitty", "add terminal emulator", "show working directory in title", or wants to customize terminal emulator settings. Covers Ghostty, Kitty, and related shell tools.
---

# Terminal Configuration

Terminal emulator configs live in `home/terminal/`.

## Configuration Files

```
home/terminal/
  default.nix      # Aggregates all terminal configs
  ghostty.nix      # Ghostty terminal
  kitty.nix        # Kitty terminal
  starship.nix     # Starship prompt
  atuin.nix        # Shell history
  bat.nix          # Cat replacement with syntax highlighting
  cli-tools.nix    # CLI utilities (eza, ripgrep, etc.)
  dev-tools.nix    # Development tools (git, direnv)
```

## Ghostty Configuration

Ghostty uses a plain text config file:

```nix
# home/terminal/ghostty.nix
{ pkgs, ... }: {
  home.packages = [ pkgs.ghostty ];

  xdg.configFile."ghostty/config".text = ''
    # Font
    font-family = JetBrainsMono Nerd Font
    font-size = 12

    # Window
    window-padding-x = 8
    window-padding-y = 4
    gtk-titlebar = true
    gtk-single-instance = true

    # Theme
    theme = catppuccin-mocha
    background-opacity = 0.95

    # Shell integration
    shell-integration = detect
    shell-integration-features = cursor,sudo,title

    # Show working directory in title bar
    window-subtitle = working-directory

    # Keybinds
    keybind = global:ctrl+grave_accent=toggle_quick_terminal
  '';
}
```

### Key Ghostty Settings

| Setting | Purpose |
|---------|---------|
| `window-subtitle = working-directory` | Show PWD in window title |
| `gtk-titlebar = true` | Show GTK header bar |
| `gtk-single-instance = true` | Reuse existing Ghostty instance |
| `shell-integration-features` | Enable cursor, sudo, title updates |
| `background-opacity` | Transparency (0.0-1.0) |

### Ghostty + niri CSD

For Ghostty's title bar to show in niri, enable client-side decorations:

```nix
# home/desktop/wm/niri/default.nix
programs.niri.settings = {
  prefer-no-csd = false;  # Allow apps to draw title bars
};
```

## Kitty Configuration

```nix
# home/terminal/kitty.nix
{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    theme = "Catppuccin-Mocha";
    settings = {
      background_opacity = "0.95";
      window_padding_width = 8;
      enable_audio_bell = false;
      hide_window_decorations = "no";
    };
  };
}
```

## Starship Prompt

```nix
# home/terminal/starship.nix
{ ... }: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      format = ''
        $directory$git_branch$git_status$nix_shell$cmd_duration
        $character
      '';
      add_newline = false;

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      git_branch = {
        format = "[$branch]($style) ";
        style = "bold purple";
      };

      nix_shell = {
        symbol = "❄️ ";
        style = "bold blue";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
    };
  };
}
```

## Shell Aliases

Define in `home/terminal/default.nix`:

```nix
home.shellAliases = {
  cat = "bat";
  ls = "eza";
  ll = "eza -la";
};
```

## Adding New Terminal

1. Create `home/terminal/<terminal>.nix`
2. Add to `home/terminal/default.nix` imports
3. Rebuild: `./scripts/dev-sync rebuild`

## Verification

After rebuild, check config was applied:

```bash
# Ghostty
cat ~/.config/ghostty/config

# Starship
starship config
```

## Common Issues

### Title bar not showing
- Set `prefer-no-csd = false` in niri config
- Set `gtk-titlebar = true` in Ghostty

### Working directory not in title
- Use `window-subtitle = working-directory` in Ghostty
- Ensure `shell-integration = detect` is set
