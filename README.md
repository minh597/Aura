# Aura Pro UI

**Load:**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()
```

---

## CreateWindow

```lua
AuraPro.CreateWindow({
    Title = "Title",                       -- Window title
    ToggleKey = Enum.KeyCode.RightShift,  -- Toggle visibility key
    HubImage = "rbxassetid://..."          -- [Optional] Hub icon
})
```

**Returns:** `Window` object

---

## CreateTab

```lua
Window:CreateTab("TabName", "rbxassetid://...") -- [Optional] Tab icon
```

**Returns:** `Tab` object

---

## Elements

### Label
```lua
Tab:CreateLabel({
    Name = "Text"
})
```

### Section
```lua
Tab:CreateSection("SECTION NAME")
```

### Divider
```lua
Tab:CreateDivider()
```

### Paragraph
```lua
Tab:CreateParagraph({
    Title = "Title",
    Content = "Description...",
    Callback = function(title, content)
        -- Called when title or content changes
    end
})
```

### Button
```lua
Tab:CreateButton({
    Name = "Button",
    Callback = function()
        -- Called on click
    end
})
```

### Toggle
```lua
Tab:CreateToggle({
    Name = "Toggle",
    Flag = "toggle_flag",   -- Save key
    Default = false,
    Callback = function(value)
        -- value = true/false
    end
})
```

### Slider
```lua
Tab:CreateSlider({
    Name = "Slider",
    Flag = "slider_flag",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        -- value = current number
    end
})
```

### Dropdown
```lua
Tab:CreateDropdown({
    Name = "Dropdown",
    Flag = "dropdown_flag",
    Options = {"Option1", "Option2", "Option3"},
    Default = 1,
    Callback = function(selected)
        -- selected = current option string
    end
})
```

### Textbox
```lua
Tab:CreateTextbox({
    Name = "Textbox",
    Flag = "textbox_flag",
    Placeholder = "Enter...",
    Default = "",
    Callback = function(value)
        -- value = input text
    end
})
```

### Keybind
```lua
Tab:CreateKeybind({
    Name = "Keybind",
    Flag = "keybind_flag",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        -- key = current Enum.KeyCode
    end
})
```

---

## Themes

`Dark`, `Midnight`, `Crimson`, `Emerald`, `Amethyst`, `Sunset`, `Cyberpunk`, `Nordic`

Themes auto-load from remote. Edit `Themes.lua` to customize.

---

## Full Example

```lua
local AuraPro = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()

local Window = AuraPro.CreateWindow({
    Title = "My Script",
    ToggleKey = Enum.KeyCode.RightShift,
    HubImage = "rbxassetid://6031091004"
})

local Tab1 = Window:CreateTab("Home", "rbxassetid://6031091004")
local Tab2 = Window:CreateTab("Settings", "rbxassetid://6031094678")

Tab1:CreateSection("Info")
Tab1:CreateParagraph({ Title = "Welcome", Content = "Aura UI Library" })
Tab1:CreateButton({ Name = "Start", Callback = function() end })

Tab2:CreateToggle({ Name = "Enabled", Flag = "enabled", Default = true, Callback = function(v) print(v) end })
Tab2:CreateSlider({ Name = "Speed", Flag = "speed", Min = 10, Max = 100, Default = 50, Callback = function(v) print(v) end })
Tab2:CreateDropdown({ Name = "Mode", Flag = "mode", Options = {"A", "B", "C"}, Default = 1, Callback = function(v) print(v) end })
Tab2:CreateKeybind({ Name = "Toggle", Flag = "key", Default = Enum.KeyCode.F, Callback = function(v) print(v.Name) end })
```

---

## Version: 2.5.0
