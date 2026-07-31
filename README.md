# Aura Pro UI

**Main:**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()
```

**Config:** `CreateWindow`, `CreateTab`

---

## Elements

### Label
```lua
Tab:CreateLabel({ Name = "Text here" })
```

### Section
```lua
Tab:CreateSection("HEADER TEXT")
```

### Divider
```lua
Tab:CreateDivider()
```

### Paragraph
```lua
Tab:CreateParagraph({
    Title = "Title",
    Content = "Description..."
})
```

### Button
```lua
Tab:CreateButton({
    Name = "Click Me",
    Callback = function() end
})
```

### Toggle
```lua
Tab:CreateToggle({
    Name = "Enable",
    Flag = "flag_name",
    Default = false
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
    Increment = 1
})
```

### Dropdown
```lua
Tab:CreateDropdown({
    Name = "Mode",
    Flag = "mode",
    Options = {"A", "B", "C"},
    Default = 1
})
```

### Textbox
```lua
Tab:CreateTextbox({
    Name = "Name",
    Flag = "name",
    Placeholder = "Enter...",
    Default = ""
})
```

### Keybind
```lua
Tab:CreateKeybind({
    Name = "Key",
    Flag = "keybind",
    Default = Enum.KeyCode.F
})
```
