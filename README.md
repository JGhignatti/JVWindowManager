<p align="center">
  <img src="JVWindowManager/Assets.xcassets/AppIcon.appiconset/256x256.png">
</p>

# JV Window Manager

_Highly customizable shortcut-based window manager for macOS_

Position windows according to [_Layouts_](#layouts), or interact with them using [_Actions_](#actions).

## Installation

Check the step-by-step in the latest [release](https://github.com/JGhignatti/JVWindowManager/releases).

## Layouts

Layouts define the window's new position and size relative to the screen they're on.

### Default layouts

| Layout                 | Default shortcut                                                  |
| :--------------------- | :---------------------------------------------------------------- |
| Full screen            | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>return</kbd>        |
| Top half               | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;▲&nbsp;</kbd> |
| Bottom half            | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;▼&nbsp;</kbd> |
| Left half              | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;◀&nbsp;</kbd> |
| Right half             | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;▶&nbsp;</kbd> |
| Top left corner        | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;U&nbsp;</kbd> |
| Top right corner       | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;I&nbsp;</kbd> |
| Bottom left corner     | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;J&nbsp;</kbd> |
| Bottom right corner    | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;K&nbsp;</kbd> |
| Vertical center half   | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;V&nbsp;</kbd> |
| Horizontal center half | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;H&nbsp;</kbd> |
| Peek left              | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;O&nbsp;</kbd> |
| Peek right             | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>&nbsp;P&nbsp;</kbd> |

#### Stage manager

All default layouts support Stage Manager. By holding <kbd>shift</kbd> along with the rest of the shortcut keys, the layout is applied, but it leaves space on the left side of the screen for the stage manager.

### Custom layouts

Custom layouts can be created and assigned to shortcuts.

An inset configuration is required. Once the linked shortcut is triggered, the window's new position and size are defined by taking the available screen frame and applying the inset configuration.

Each inset side is an expression. To assist, the following variables are available:

| Variable       | Description                              |
| :------------- | :--------------------------------------- |
| `width`        | The width of the available screen frame  |
| `height`       | The height of the available screen frame |
| `padding`      | The configured padding size              |
| `gap`          | The configured gap size                  |
| `halfGap`      | Half the configured gap size             |
| `stageManager` | The configured stage manager size        |
| `peek`         | The configured peek size                 |

## Actions

While layouts are relative to the available screen frame, actions are meant to interact with the window's position and size relative to the window's current position and size.

### Default actions

| Action       | Default shortcut                                                                       |
| :----------- | :------------------------------------------------------------------------------------- |
| + All sides  | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;=&nbsp;</kbd> |
| + Horizontal | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;D&nbsp;</kbd> |
| + Vertical   | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;W&nbsp;</kbd> |
| - All sides  | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;–&nbsp;</kbd> |
| - Horizontal | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;A&nbsp;</kbd> |
| - Vertical   | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;S&nbsp;</kbd> |
| Move up      | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;▲&nbsp;</kbd> |
| Move down    | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;▼&nbsp;</kbd> |
| Move left    | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;◀&nbsp;</kbd> |
| Move right   | <kbd>control</kbd> + <kbd>option</kbd> + <kbd>command</kbd> + <kbd>&nbsp;▶&nbsp;</kbd> |

### Custom actions

Custom actions can be created and assigned to shortcuts.

An action configuration is required. Once the linked shortcut is triggered, the window's new position and size are defined by taking the window's current position and size and applying the action configuration.

Each action side is an expression. To assist, the following variables are available:

| Variable       | Description                       |
| :------------- | :-------------------------------- |
| `width`        | The width of the window           |
| `height`       | The height of the window          |
| `padding`      | The configured padding size       |
| `gap`          | The configured gap size           |
| `halfGap`      | Half the configured gap size      |
| `stageManager` | The configured stage manager size |
| `peek`         | The configured peek size          |
| `step`         | The configured step size          |

## Settings

|               | Description                                                                                            | Default value | Range     |
| :------------ | :----------------------------------------------------------------------------------------------------- | :------------ | :-------- |
| Padding       | The space between the edge of the screen and the window's available space                              | `16`          | `0...50`  |
| Gap           | The space between windows                                                                              | `16`          | `0...50`  |
| Stage manager | The left margin for the stage manager, between the edge of the screen and the window's available space | `180`         | `0...250` |
| Peek          | The space left on either left or right to peek the window behind                                       | `80`          | `0...100` |
| Step          | A configurable size that can be used as a step size for repeating actions                              | `16`          | `0...200` |
