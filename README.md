# Aura Pro UI

**Load:**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/AuraMain.lua"))()
```

---

## CreateWindow

```lua
AuraPro.CreateWindow({
    Title = "Title",                    -- Window title
    ToggleKey = Enum.KeyCode.RightShift, -- Toggle key
    HubImage = "rbxassetid://..."        -- [Optional] Hub icon
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

### Label - Text hiển thị
```lua
Tab:CreateLabel({ Name = "Text" })
-- .obj:Set("New Text")  -- Thay đổi text
-- .obj:Get()           -- Lấy text hiện tại
```

### Section - Tiêu đề section
```lua
Tab:CreateSection("SECTION NAME")
```

### Divider - Đường kẻ
```lua
Tab:CreateDivider()
```

### Paragraph - Box tiêu đề + mô tả
```lua
Tab:CreateParagraph({
    Title = "Title",
    Content = "Description..."
})
-- .obj:SetTitle("New")     -- Đổi title
-- .obj:SetContent("New")   -- Đổi content
```

### Button - Nút bấm
```lua
Tab:CreateButton({
    Name = "Button",
    Callback = function()
        print("Clicked!")
    end
})
```

### Toggle - Công tắc bật/tắt
```lua
Tab:CreateToggle({
    Name = "Toggle",
    Flag = "toggle_flag",    -- Key lưu data
    Default = false          -- Mặc định
})
-- .obj:Get()                -- Lấy trạng thái (true/false)
```

### Slider - Thanh trượt số
```lua
Tab:CreateSlider({
    Name = "Slider",
    Flag = "slider_flag",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1            -- Bước nhảy
})
-- .obj:Get()                -- Lấy giá trị
```

### Dropdown - Danh sách chọn
```lua
Tab:CreateDropdown({
    Name = "Dropdown",
    Flag = "dropdown_flag",
    Options = {"Option1", "Option2", "Option3"},
    Default = 1              -- Index mặc định (1 = Option1)
})
-- .obj:Get()                -- Lấy option đang chọn
```

### Textbox - Ô nhập text
```lua
Tab:CreateTextbox({
    Name = "Textbox",
    Flag = "textbox_flag",
    Placeholder = "Enter...",
    Default = ""
})
-- .obj:Get()                -- Lấy text nhập
```

### Keybind - Phím tắt
```lua
Tab:CreateKeybind({
    Name = "Keybind",
    Flag = "keybind_flag",
    Default = Enum.KeyCode.F
})
-- .obj:Get()                -- Lấy key đang bind
```

---

## Themes

`Dark`, `Midnight`, `Crimson`, `Emerald`, `Amethyst`, `Sunset`, `Cyberpunk`, `Nordic`

Themes load tự động từ remote. Tự chỉnh trong `Themes.lua`.

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

Tab2:CreateToggle({ Name = "Enabled", Flag = "enabled", Default = true })
Tab2:CreateSlider({ Name = "Speed", Flag = "speed", Min = 10, Max = 100, Default = 50 })
Tab2:CreateDropdown({ Name = "Mode", Flag = "mode", Options = {"A", "B", "C"}, Default = 1 })
Tab2:CreateKeybind({ Name = "Toggle", Flag = "key", Default = Enum.KeyCode.F })
```

---

## Version: 2.5.0
