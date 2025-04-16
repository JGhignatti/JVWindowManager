<p align="center">
  <img src="JVWindowManager/Assets.xcassets/AppIcon.appiconset/256.png">
</p>

# JV Window Manager

_Shortcut-based window manager app for macOS_

## Hardcoded shortcuts

_⏹️ = Supports stage manager with + <kbd>shift</kbd>_

| Key | Modifiers | Layout ||
|:-:|-|-|:-:|
| <kbd>return</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Full screen | ⏹️ |
| <kbd>&nbsp;▲&nbsp;</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Top half | ⏹️ |
| <kbd>&nbsp;▼&nbsp;</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Bottom half | ⏹️ |
| <kbd>&nbsp;◀&nbsp;</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Left half | ⏹️ |
| <kbd>&nbsp;▶&nbsp;</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Right half | ⏹️ |
| <kbd>&nbsp;V&nbsp;</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Vertical center half | ⏹️ |
| <kbd>&nbsp;H&nbsp;</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Horizontal center half | ⏹️ |
| <kbd>&nbsp;O&nbsp;</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Peek left | ⏹️ |
| <kbd>&nbsp;P&nbsp;</kbd> | <kbd>control</kbd> + <kbd>option</kbd> | Peek right | ⏹️ |

### Stage manager support

Shortcuts that support Stage Manager will leave space on the left side of the screen.

To trigger the Stage Manager shortcut, hold <kbd>shift</kbd> with the other modifiers.

## Settings

### Gap size

Configures both padding for the screen frame and gap between windows.

|||
|-|-|
| Default value | 16px |
| Range | 0...50px |

### Stage manager size

Configures the left margin left on screen for the stange manager.

|||
|-|-|
| Default value | 180px |
| Range | 0...250px |

### Peek size

Configures the space left to peek the window behind.

|||
|-|-|
| Default value | 48px |
| Range | 0...100px |

