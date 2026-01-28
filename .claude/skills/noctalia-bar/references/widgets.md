# Noctalia Bar Widgets Reference

**IMPORTANT:** All widgets must be objects with an `id` field. Plain strings don't work.

## Core Widgets

### Launcher
Application launcher button.
```nix
{ id = "Launcher"; }
# or with settings:
{
  id = "Launcher";
  icon = "rocket";
  usePrimaryColor = false;
}
```

### ActiveWindow
Shows the currently focused window title.
```nix
{ id = "ActiveWindow"; }
# with settings:
{
  id = "ActiveWindow";
  colorizeIcons = false;
  hideMode = "hidden";
  maxWidth = 145;
  scrollingMode = "hover";
  showIcon = true;
  useFixedWidth = false;
}
```

### Workspace
Workspace indicator (shows workspace numbers/icons).
```nix
{ id = "Workspace"; }
# with settings:
{
  id = "Workspace";
  characterCount = 2;
  colorizeIcons = false;
  emptyColor = "secondary";
  enableScrollWheel = true;
  focusedColor = "primary";
  followFocusedScreen = false;
  hideUnoccupied = false;
  iconScale = 0.8;
  labelMode = "index";
  occupiedColor = "secondary";
  reverseScroll = false;
  showApplications = false;
  showBadge = true;
  showLabelsOnlyWhenOccupied = true;
}
```

### Clock
Date and time display.
```nix
{ id = "Clock"; }
# with settings:
{
  id = "Clock";
  customFont = "";
  formatHorizontal = "HH:mm ddd, MMM dd";
  formatVertical = "HH mm - dd MM";
  tooltipFormat = "HH:mm ddd, MMM dd";
  useCustomFont = false;
  usePrimaryColor = false;
}
```

### SystemMonitor
CPU, memory, network statistics.
```nix
{ id = "SystemMonitor"; }
# with settings:
{
  id = "SystemMonitor";
  compactMode = false;
  diskPath = "/";
  showCpuTemp = true;
  showCpuUsage = true;
  showDiskUsage = false;
  showGpuTemp = false;
  showLoadAverage = false;
  showMemoryAsPercent = false;
  showMemoryUsage = true;
  showNetworkStats = true;
  showSwapUsage = false;
  useMonospaceFont = true;
  usePrimaryColor = false;
}
```

### Tray
System tray icons.
```nix
{ id = "Tray"; }
# with settings:
{
  id = "Tray";
  blacklist = [];
  colorizeIcons = false;
  drawerEnabled = true;
  hidePassive = false;
  pinned = [];
}
```

### NotificationHistory
Notification bell/history.
```nix
{ id = "NotificationHistory"; }
# with settings:
{
  id = "NotificationHistory";
  hideWhenZero = false;
  hideWhenZeroUnread = false;
  showUnreadBadge = true;
}
```

### Battery
Battery status indicator.
```nix
{ id = "Battery"; }
# with settings:
{
  id = "Battery";
  deviceNativePath = "";
  displayMode = "onhover";
  hideIfIdle = false;
  hideIfNotDetected = true;
  showNoctaliaPerformance = false;
  showPowerProfiles = false;
  warningThreshold = 30;
}
```

### Volume
Audio volume control.
```nix
{ id = "Volume"; }
# with settings:
{
  id = "Volume";
  displayMode = "onhover";
  middleClickCommand = "pwvucontrol || pavucontrol";
}
```

### Brightness
Screen brightness control.
```nix
{ id = "Brightness"; }
# with settings:
{
  id = "Brightness";
  displayMode = "onhover";
}
```

### MediaMini
Media player controls.
```nix
{ id = "MediaMini"; }
# with settings:
{
  id = "MediaMini";
  compactMode = false;
  compactShowAlbumArt = true;
  compactShowVisualizer = false;
  hideMode = "hidden";
  hideWhenIdle = false;
  maxWidth = 145;
  panelShowAlbumArt = true;
  panelShowVisualizer = true;
  scrollingMode = "hover";
  showAlbumArt = true;
  showArtistFirst = true;
  showProgressRing = true;
  showVisualizer = false;
  useFixedWidth = false;
  visualizerType = "linear";
}
```

### ControlCenter
Quick settings panel toggle.
```nix
{ id = "ControlCenter"; }
# with settings:
{
  id = "ControlCenter";
  colorizeDistroLogo = false;
  colorizeSystemIcon = "none";
  customIconPath = "";
  enableColorization = false;
  icon = "noctalia";
  useDistroLogo = false;
}
```

## Current Configuration

As of last update, the bar layout is:

**Left:** SystemMonitor (with detailed settings), ActiveWindow, Workspace
**Center:** Clock
**Right:** Tray, NotificationHistory, Battery, Volume, Brightness, MediaMini, ControlCenter

Note: Launcher was removed from the bar.
