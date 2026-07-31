# Aura Pro UI

**Load:**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()
```

---

## CreateKeySystem

Key verification popup (optional).

```lua
AuraPro:CreateKeySystem({
    Name = "Title",              -- Popup title
    Key = "YOUR_KEY",            -- Correct key
    Link = "https://...",        -- Link to get key (copies to clipboard)
    Image = "rbxassetid://...",  -- [Optional] Icon
    Callback = function()
        -- Called when key is correct
    end
})
```

---

## CreateWindow

```lua
AuraPro:CreateWindow({
    Name = "Title",                    -- Window title
    ToggleKey = Enum.KeyCode.RightShift, -- Toggle key
    Image = "rbxassetid://...",        -- [Optional] Hub icon
    Theme = AuraPro.Themes.Dark,       -- [Optional] Theme
    ConfigSave = "config.json"         -- [Optional] Auto-save config
})
```

**Returns:** `Window` object

---

## AuraPro:Notify

Show notification popup.

```lua
AuraPro:Notify({
    Title = "Title",
    Content = "Message...",
    Duration = 3.5  -- seconds
})
```

---

## Window:CreateTab

```lua
Window:CreateTab("TabName", "rbxassetid://...") -- [Optional] Icon
```

**Returns:** `Tab` object

---

## Elements

### Label
```lua
Tab:CreateLabel({ Name = "Text" })
```

### Section
```lua
Tab:CreateSection("HEADER")
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
    Callback = function(title, content) end
})
```

### Button
```lua
Tab:CreateButton({
    Name = "Button",
    Callback = function() end
})
```

### Toggle
```lua
Tab:CreateToggle({
    Name = "Toggle",
    Default = false,
    Callback = function(value) end  -- true/false
})
```

### Slider
```lua
Tab:CreateSlider({
    Name = "Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value) end  -- number
})
```

### Dropdown
```lua
Tab:CreateDropdown({
    Name = "Dropdown",
    Options = {"A", "B", "C"},
    Default = 1,
    Callback = function(selected) end  -- string
})

-- MultiSelect: chọn nhiều mục
Tab:CreateDropdown({
    Name = "Multi Select",
    Options = {"Option1", "Option2", "Option3"},
    Default = {"Option1"},  -- table for multi
    MultiSelect = true,
    Callback = function(selectedList)  -- table
        for _, item in ipairs(selectedList) do
            print(item)
        end
    end
})
```

### Textbox
```lua
Tab:CreateTextbox({
    Name = "Textbox",
    Placeholder = "Enter...",
    Default = "",
    Callback = function(value) end  -- string
})
```

### Keybind
```lua
Tab:CreateKeybind({
    Name = "Keybind",
    Default = Enum.KeyCode.F,
    Callback = function(key) end  -- Enum.KeyCode
})
```

---

## Themes

`Dark`, `Midnight`, `Crimson`, `Emerald`, `Amethyst`, `Sunset`, `Cyberpunk`, `Nordic`

---

## Features

- ✅ Notification/Toast (`AuraPro:Notify`)
- ✅ MultiDropdown (`MultiSelect = true`)
- ✅ Config Save/Load (`ConfigSave`)
- ✅ Destroy UI (`Window:Destroy()`)
- ⏳ ColorPicker (sắp ra)
- ⏳ Search trong Dropdown (sắp ra)

---

## Example

```lua
local AuraPro = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()

AuraPro:CreateKeySystem({
    Name = "My Script",
    Key = "KEY123",
    Link = "https://link-to-get-key.com",
    Callback = function()
        local Window = AuraPro:CreateWindow({
            Name = "My Script",
            ToggleKey = Enum.KeyCode.RightShift,
            ConfigSave = "config.json"
        })

        local Tab = Window:CreateTab("Home")
        Tab:CreateToggle({ Name = "Enabled", Default = true, Callback = function(v) end })
        Tab:CreateSlider({ Name = "Speed", Min = 10, Max = 100, Default = 50, Callback = function(v) end })

        AuraPro:Notify({ Title = "Ready!", Content = "Script loaded." })
        -- Window:Destroy() -- destroy UI
    end
})
```

---

## Version: 2.5.0
