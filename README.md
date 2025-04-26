<p align="center">
  <img src="JVWindowManager/Assets.xcassets/AppIcon.appiconset/256.png">
</p>

# JV Window Manager

_Customizable shortcut-based window manager app for macOS_

---

Once a shortcut is triggered, the window is resized to the corresponding Layout. Use one of the [Default layouts](#default-layouts) or create a [Custom layout](#custom-layouts).

## Settings

|                                 | Description                                                                                            | Default value | Range     |
|:--------------------------------|:-------------------------------------------------------------------------------------------------------|:--------------|:----------|
| Padding                         | The space between the edge of the screen and the window's available space                              | `16`          | `0...50`  |
| Gap                             | The space between windows                                                                              | `16`          | `0...50`  |
| Stage manager                   | The left margin between the edge of the screen and the window's availbale  space for the stage manager | `180`         | `0...250` |
| Peek                            | The space left on either left or right to peek the window behind                                       | `80`          | `0...100` |

## Default layouts

_⏹️ = Supports stage manager with + <kbd>shift</kbd>_\
_✏️ = Shortcut is customizable_\
_⌫ = Shortcut can be disabled by clearing the shortcut_

| Layout                 | Default shortcut                                                  | ⏹️ ✏️ ⌫                  |
|:-----------------------|:------------------------------------------------------------------|:-----------------------:|
| Full screen            | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>return</kbd>        | &check; &check; &check; |
| Top half               | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;▲&nbsp;</kbd> | &check; &check; &check; |
| Bottom half            | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;▼&nbsp;</kbd> | &check; &check; &check; |
| Left half              | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;◀&nbsp;</kbd> | &check; &check; &check; |
| Right half             | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;▶&nbsp;</kbd> | &check; &check; &check; |
| Top left corner        | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;U&nbsp;</kbd> | &check; &check; &check; |
| Top right corner       | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;I&nbsp;</kbd> | &check; &check; &check; |
| Bottom left corner     | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;J&nbsp;</kbd> | &check; &check; &check; |
| Bottom right corner    | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;K&nbsp;</kbd> | &check; &check; &check; |
| Vertical center half   | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;V&nbsp;</kbd> | &check; &check; &check; |
| Horizontal center half | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;H&nbsp;</kbd> | &check; &check; &check; |
| Peek left              | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;O&nbsp;</kbd> | &check; &check; &check; |
| Peek right             | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;P&nbsp;</kbd> | &check; &check; &check; |

### Stage manager support

Shortcuts that support Stage Manager will leave space on the left side of the screen.

To trigger the shortcut's Stage Manager version, hold <kbd>shift</kbd> along with the other modifiers.

## Custom layouts

Custom layouts can be created and assigned to shortcuts.

An inset configuration is required. Once the linked shortcut is triggered, the window's size is defined by taking the available screen frame and applying the inset configuration.

Each inset side is an expression. To assist, the following variables are available:

| Variable       | Description                                |
|:---------------|:-------------------------------------------|
| `width`        | The width of the window's available space  |
| `height`       | The height of the window's available space |
| `padding`      | The configured padding size                |
| `gap`          | The configured gap size                    |
| `halfGap`      | Half the configured gap size               |
| `stageManager` | The configured stage manager size          |
| `peek`         | The configured peek size                   |

### Default layouts as inset configuration

#### Full screen

| Side   | Expression |
|:-------|:-----------|
| Top    | `padding`  |
| Bottom | `padding`  |
| Left   | `padding`  |
| Right  | `padding`  |

#### Top half

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `padding`              |
| Bottom | `height / 2 + halfGap` |
| Left   | `padding`              |
| Right  | `padding`              |

#### Bottom half

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `height / 2 + halfGap` |
| Bottom | `padding`              |
| Left   | `padding`              |
| Right  | `padding`              |

#### Left half

| Side   | Expression            |
|:-------|:----------------------|
| Top    | `padding`             |
| Bottom | `padding`             |
| Left   | `padding`             |
| Right  | `width / 2 + halfGap` |

#### Right half

| Side   | Expression            |
|:-------|:----------------------|
| Top    | `padding`             |
| Bottom | `padding`             |
| Left   | `width / 2 + halfGap` |
| Right  | `padding`             |

#### Top left corner

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `padding`              |
| Bottom | `height / 2 + halfGap` |
| Left   | `padding`              |
| Right  | `width / 2 + halfGap`  |

#### Top right corner

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `padding`              |
| Bottom | `height / 2 + halfGap` |
| Left   | `width / 2 + halfGap`  |
| Right  | `padding`              |

#### Bottom left corner

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `height / 2 + halfGap` |
| Bottom | `padding`              |
| Left   | `padding`              |
| Right  | `width / 2 + halfGap`  |

#### Bottom right corner

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `height / 2 + halfGap` |
| Bottom | `padding`              |
| Left   | `width / 2 + halfGap`  |
| Right  | `padding`              |

#### Vertical center half

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `height / 4 + halfGap` |
| Bottom | `height / 4 + halfGap` |
| Left   | `padding`              |
| Right  | `padding`              |

#### Horizontal center half

| Side   | Expression            |
|:-------|:----------------------|
| Top    | `padding`             |
| Bottom | `padding`             |
| Left   | `width / 4 + halfGap` |
| Right  | `width / 4 + halfGap` |

#### Peek left

| Side   | Expression |
|:-------|:-----------|
| Top    | `padding`  |
| Bottom | `padding`  |
| Left   | `peek`     |
| Right  | `padding`  |

#### Peek left

| Side   | Expression |
|:-------|:-----------|
| Top    | `padding`  |
| Bottom | `padding`  |
| Left   | `padding`  |
| Right  | `peek`     |

#### Stage manager full screen

| Side   | Expression     |
|:-------|:---------------|
| Top    | `padding`      |
| Bottom | `padding`      |
| Left   | `stageManager` |
| Right  | `padding`      |

#### Stage manager top half

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `padding`              |
| Bottom | `height / 2 + halfGap` |
| Left   | `stageManager`         |
| Right  | `padding`              |

#### Stage manager bottom half

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `height / 2 + halfGap` |
| Bottom | `padding`              |
| Left   | `stageManager`         |
| Right  | `padding`              |

#### Stage manager left half

| Side   | Expression                             |
|:-------|:---------------------------------------|
| Top    | `padding`                              |
| Bottom | `padding`                              |
| Left   | `stageManager`                         |
| Right  | `(width - stageManager) / 2 + halfGap` |

#### Stage manager right half

| Side   | Expression                                          |
|:-------|:----------------------------------------------------|
| Top    | `padding`                                           |
| Bottom | `padding`                                           |
| Left   | `stageManager (width - stageManager) / 2 + halfGap` |
| Right  | `padding`                                           |

#### Stage manager top left corner

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `padding`              |
| Bottom | `height / 2 + halfGap` |
| Left   | `stageManager`              |
| Right  | `(width - stageManager) / 2 + halfGap` |

#### Stage manager top right corner

| Side   | Expression                                            |
|:-------|:------------------------------------------------------|
| Top    | `padding`                                             |
| Bottom | `height / 2 + halfGap`                                |
| Left   | `stageManager + (width - stageManager) / 2 + halfGap` |
| Right  | `padding`                                             |

#### Stage manager bottom left corner

| Side   | Expression                             |
|:-------|:---------------------------------------|
| Top    | `height / 2 + halfGap`                 |
| Bottom | `padding`                              |
| Left   | `stageManager`                         |
| Right  | `(width - stageManager) / 2 + halfGap` |

#### Stage manager bottom right corner

| Side   | Expression                                            |
|:-------|:------------------------------------------------------|
| Top    | `height / 2 + halfGap`                                |
| Bottom | `padding`                                             |
| Left   | `stageManager + (width - stageManager) / 2 + halfGap` |
| Right  | `padding`                                             |

#### Stage manager vertical center half

| Side   | Expression             |
|:-------|:-----------------------|
| Top    | `height / 4 + halfGap` |
| Bottom | `height / 4 + halfGap` |
| Left   | `stageManager`         |
| Right  | `padding`              |

#### Stage manager horizontal center half

| Side   | Expression                                            |
|:-------|:------------------------------------------------------|
| Top    | `padding`                                             |
| Bottom | `padding`                                             |
| Left   | `stageManager + (width - stageManager) / 4 + halfGap` |
| Right  | `(width - stageManager) / 4 + halfGap`                |

#### Peek left

| Side   | Expression            |
|:-------|:----------------------|
| Top    | `padding`             |
| Bottom | `padding`             |
| Left   | `stageManager + peek` |
| Right  | `padding`             |

#### Peek left

| Side   | Expression     |
|:-------|:---------------|
| Top    | `padding`      |
| Bottom | `padding`      |
| Left   | `stageManager` |
| Right  | `peek`         |
