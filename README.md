# Aura Pro UI Library

A lightweight, customizable UI library for Roblox games.

## Installation

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()
```

---

## API Reference

### AuraPro.CreateWindow(config)

Creates a new UI window.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `Title` | string | ✅ | Window title text |
| `ToggleKey` | Enum.KeyCode | ✅ | Key to toggle window visibility |
| `HubImage` | string | ❌ | Hub icon image ID (e.g., `"rbxassetid://6031091004"`) |

**Returns:** `Window` object

### Window:CreateTab(name, imageId)

Creates a new tab in the window.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | string | ✅ | Tab display name |
| `imageId` | string | ❌ | Tab icon image ID |

**Returns:** `TabElements` object with element creation methods

---

## UI Elements

### Label
Simple text display.
```lua
Tab:CreateLabel({ Name = "Welcome!" })
```

### Paragraph
Title and description box.
```lua
Tab:CreateParagraph({
    Title = "Information",
    Content = "Your description here..."
})
```

### Button
Clickable button with callback.
```lua
Tab:CreateButton({
    Name = "Execute",
    Callback = function()
        print("Clicked!")
    end
})
```

### Toggle
On/off switch with saved state.
```lua
Tab:CreateToggle({
    Name = "Enable Feature",
    Flag = "feature_enabled",    -- Unique flag for saving
    Default = false               -- Default state
})
```

### Slider
Numeric slider with min/max values.
```lua
Tab:CreateSlider({
    Name = "Volume",
    Flag = "volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,                -- Step size
    Callback = function(value)
        print("Volume:", value)
    end
})
```

### Dropdown
Selection list with options.
```lua
Tab:CreateDropdown({
    Name = "Mode",
    Flag = "mode",
    Options = {"Option1", "Option2", "Option3"},
    Default = 1,                   -- Default selected index
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

### Textbox
Text input field.
```lua
Tab:CreateTextbox({
    Name = "Username",
    Flag = "username",
    Placeholder = "Enter name...",
    Default = "",
    Callback = function(value)
        print("Name:", value)
    end
})
```

### Keybind
Keyboard shortcut binder.
```lua
Tab:CreateKeybind({
    Name = "Toggle UI",
    Flag = "toggle_key",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("Pressed:", key.Name)
    end
})
```

### Section
Styled section header text.
```lua
Tab:CreateSection("SETTINGS")
```

### Divider
Horizontal separator line.
```lua
Tab:CreateDivider()
```

---

## Quick Example

```lua
local AuraPro = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()

local Window = AuraPro.CreateWindow({
    Title = "My Script",
    ToggleKey = Enum.KeyCode.RightShift
})

local Tab = Window:CreateTab("Home", "rbxassetid://6031091004")

Tab:CreateSection("Main")
Tab:CreateLabel({ Name = "Welcome to Aura!" })
Tab:CreateToggle({ Name = "Enabled", Flag = "enabled", Default = true })
Tab:CreateSlider({ Name = "Speed", Flag = "speed", Min = 10, Max = 100, Default = 50 })
Tab:CreateButton({ Name = "Execute", Callback = function() print("Done!") end })
```

---

## Themes

8 built-in themes: **Dark**, **Midnight**, **Crimson**, **Emerald**, **Amethyst**, **Sunset**, **Cyberpunk**, **Nordic**

Themes are loaded automatically from remote. Edit `Themes.lua` to customize.
