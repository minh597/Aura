# Aura Pro UI Library

A powerful, lightweight, and customizable UI library for Roblox games.

![Version](https://img.shields.io/badge/version-2.5.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

- 🎨 **8 Built-in Themes** - Dark, Midnight, Crimson, Emerald, Amethyst, Sunset, Cyberpunk, Nordic
- 🪟 **Draggable Windows** - Smooth drag functionality with minify/close controls
- 📑 **Tab-based Navigation** - Organize content with multiple tabs
- 💾 **Persistent Config** - Save and load user preferences automatically
- ⌨️ **Keybind System** - Customizable keyboard shortcuts
- 🎯 **Rich UI Elements** - Labels, Paragraphs, Buttons, Toggles, Sliders, Dropdowns, Textboxes, Keybinds
- ✨ **Smooth Animations** - Tween-based hover effects and transitions

## Installation

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()
```

Or copy `AuraMain.lua` and `Themes.lua` into your Roblox project.

## Quick Start

```lua
local AuraPro = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()

-- Create a new window
local Window = AuraPro.CreateWindow({
    Title = "My Script",
    ToggleKey = Enum.KeyCode.RightShift
})

-- Create a tab
local Tab = Window:CreateTab("Home", "rbxassetid://6031091004")

-- Add UI elements
Tab:CreateLabel({ Name = "Welcome to Aura!" })
Tab:CreateParagraph({ Title = "Getting Started", Content = "Build your UI with ease." })
Tab:CreateButton({ Name = "Click Me", Callback = function()
    print("Button clicked!")
end })
Tab:CreateToggle({ Name = "Enable Feature", Flag = "feature_enabled", Default = false })
```

## UI Elements

### Label
```lua
Tab:CreateLabel({ Name = "Simple Label" })
```

### Paragraph
```lua
Tab:CreateParagraph({
    Title = "Section Title",
    Content = "Description text goes here..."
})
```

### Button
```lua
Tab:CreateButton({
    Name = "Execute Action",
    Callback = function()
        -- Your code here
    end
})
```

### Toggle
```lua
Tab:CreateToggle({
    Name = "Enable Option",
    Flag = "option_flag",     -- Unique flag for saving
    Default = false           -- Default state
})
```

### Slider
```lua
Tab:CreateSlider({
    Name = "Volume",
    Flag = "volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Volume:", value)
    end
})
```

### Dropdown
```lua
Tab:CreateDropdown({
    Name = "Select Mode",
    Flag = "mode",
    Options = {"Easy", "Medium", "Hard"},
    Default = 1,
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

### Textbox
```lua
Tab:CreateTextbox({
    Name = "Enter Name",
    Flag = "player_name",
    Placeholder = "Your name...",
    Default = "",
    Callback = function(value)
        print("Name:", value)
    end
})
```

### Keybind
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
```lua
Tab:CreateSection("Settings")
```

### Divider
```lua
Tab:CreateDivider()
```

## Themes

Aura comes with 8 beautiful themes:

| Theme | Accent Color | Description |
|-------|--------------|-------------|
| Dark | Indigo (#6366F1) | Classic dark theme |
| Midnight | Sky Blue (#0EA5E9) | Deep blue variant |
| Crimson | Rose Red (#E11D48) | Bold red accent |
| Emerald | Green (#10B981) | Nature-inspired |
| Amethyst | Purple (#8B5CF6) | Purple tones |
| Sunset | Orange (#F97316) | Warm sunset vibes |
| Cyberpunk | Cyan (#00F0FF) | Neon cyberpunk style |
| Nordic | Teal (#88C0D0) | Clean Nordic design |

### Using Remote Themes

Themes are automatically loaded from the GitHub repository:

```lua
-- This is handled automatically by AuraPro
-- Themes are fetched from: https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/Themes.lua
```

## API Reference

### AuraPro.CreateWindow(config)

Creates a new UI window.

| Parameter | Type | Description |
|-----------|------|-------------|
| `config.Title` | string | Window title |
| `config.ToggleKey` | Enum.KeyCode | Key to toggle window visibility |
| `config.HubImage` | string | Optional hub icon (image ID) |

### Window:CreateTab(name, imageId)

Creates a new tab in the window.

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | string | Tab display name |
| `imageId` | string | Optional tab icon (image ID) |

## Version History

- **2.5.0** - Latest version with full theme support

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.
