local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local CachedParent = (gethui and gethui()) or (CoreGui:FindFirstChild("RobloxGui") and CoreGui) or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui")) or CoreGui

if CachedParent:FindFirstChild("Aura_Pro_UI") then CachedParent.Aura_Pro_UI:Destroy() end
if CachedParent:FindFirstChild("Aura_KeySystem_UI") then CachedParent.Aura_KeySystem_UI:Destroy() end
if CachedParent:FindFirstChild("Aura_Minified_Icon") then CachedParent.Aura_Minified_Icon:Destroy() end

local AuraPro = {
    KeyConfigName = "AuraKey_Save.json",
    Version = "2.5.1"
}

local SuccessTheme, RemoteThemes = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/Themes.lua"))()
end)

AuraPro.Themes = (SuccessTheme and RemoteThemes and RemoteThemes.Themes) or {
    Dark = {
        Background = Color3.fromRGB(15, 16, 21),
        Card = Color3.fromRGB(22, 24, 31),
        Element = Color3.fromRGB(30, 33, 42),
        Border = Color3.fromRGB(44, 48, 62),
        Text = Color3.fromRGB(245, 247, 255),
        SubText = Color3.fromRGB(135, 142, 165),
        Accent = Color3.fromRGB(99, 102, 241),
        Success = Color3.fromRGB(34, 197, 94),
        Danger = Color3.fromRGB(239, 68, 68)
    },
    Midnight = {
        Background = Color3.fromRGB(10, 10, 15),
        Card = Color3.fromRGB(16, 17, 26),
        Element = Color3.fromRGB(24, 26, 38),
        Border = Color3.fromRGB(38, 42, 60),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(120, 128, 150),
        Accent = Color3.fromRGB(139, 92, 246),
        Success = Color3.fromRGB(16, 185, 129),
        Danger = Color3.fromRGB(244, 63, 94)
    }
}

local function TrackConn(tbl, conn)
    table.insert(tbl, conn)
    return conn
end

local function SaveDataToFile(file, data)
    if file and writefile then
        pcall(function() writefile(file, HttpService:JSONEncode(data)) end)
    end
end

local function LoadDataFromFile(file)
    if file and readfile and isfile and isfile(file) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(file)) end)
        if success then return decoded end
    end
    return {}
end

local function UpdateFlag(selfRef, savedData, flag, val)
    if selfRef._configName then
        savedData[flag] = val
        SaveDataToFile(selfRef._configName, savedData)
    end
end

local UI = {}
function UI.Create(Class, Parent, Properties)
    local Obj = Instance.new(Class)
    for Key, Value in pairs(Properties or {}) do Obj[Key] = Value end
    if Parent then Obj.Parent = Parent end
    return Obj
end

function UI.Corner(Obj, Radius)
    return UI.Create("UICorner", Obj, { CornerRadius = UDim.new(0, Radius or 6) })
end

function UI.Stroke(Obj, Color, Thickness)
    return UI.Create("UIStroke", Obj, { Color = Color, Thickness = Thickness or 1 })
end

local gDragging, gDragInput, gDragStart, gStartPos, gTargetFrame
UserInputService.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and gTargetFrame then
        gDragging = true
        gDragStart = input.Position
        gStartPos = gTargetFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        gDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        gDragInput = input
    end
    if gDragging and gTargetFrame and gDragInput == input then
        local delta = input.Position - gDragStart
        gTargetFrame.Position = UDim2.new(gStartPos.X.Scale, gStartPos.X.Offset + delta.X, gStartPos.Y.Scale, gStartPos.Y.Offset + delta.Y)
    end
end)

local function MakeDraggable(Frame, Handle)
    Handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            gTargetFrame = Frame
        end
    end)
    Handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if gTargetFrame == Frame then gTargetFrame = nil end
        end
    end)
end

local Elements = {}

function Elements.Label(Parent, Theme, Config)
    local Label = UI.Create("TextLabel", Parent, {
        Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
        Text = Config.Name or "Label", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })
    local Obj = {}
    function Obj:Set(t) Label.Text = t end
    function Obj:Get() return Label.Text end
    return Obj
end

function Elements.Paragraph(Parent, Theme, Config)
    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = Theme.Element })
    UI.Corner(Frame, 6)
    UI.Stroke(Frame, Theme.Border)
    local Title = UI.Create("TextLabel", Frame, {
        Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1, Text = Config.Title or "Title", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
    })
    local Desc = UI.Create("TextLabel", Frame, {
        Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 10, 0, 24),
        BackgroundTransparency = 1, Text = Config.Content or "Content...", TextColor3 = Theme.SubText,
        TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
    })
    local Obj = {}
    function Obj:SetTitle(t) Title.Text = t end
    function Obj:SetContent(c) Desc.Text = c end
    return Obj
end

function Elements.Divider(Parent, Theme)
    local Div = UI.Create("Frame", Parent, { Size = UDim2.new(1, 0, 0, 6), BackgroundTransparency = 1 })
    UI.Create("Frame", Div, { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Theme.Border, BorderSizePixel = 0 })
end

function Elements.Section(Parent, Theme, Text)
    UI.Create("TextLabel", Parent, {
        Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
        Text = "  " .. string.upper(Text), TextColor3 = Theme.Accent,
        TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
    })
end

function Elements.Button(Parent, Theme, Config)
    local Btn = UI.Create("TextButton", Parent, {
        Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Element,
        Text = "    " .. (Config.Name or "Button"), TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })
    UI.Corner(Btn, 6)
    UI.Stroke(Btn, Theme.Border)

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Card}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Element}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        pcall(Config.Callback or function() end)
    end)
end

function Elements.Toggle(Parent, Theme, SavedData, SelfRef, Config)
    local Flag = Config.Flag or Config.Name
    local Toggled = SavedData[Flag] ~= nil and SavedData[Flag] or (Config.Default or false)
    UpdateFlag(SelfRef, SavedData, Flag, Toggled)

    local Btn = UI.Create("TextButton", Parent, {
        Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Element,
        Text = "    " .. (Config.Name or "Toggle"), TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })
    UI.Corner(Btn, 6)
    UI.Stroke(Btn, Theme.Border)

    local SwitchBG = UI.Create("Frame", Btn, {
        Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -46, 0.5, -10),
        BackgroundColor3 = Toggled and Theme.Accent or Theme.Border
    })
    UI.Corner(SwitchBG, 10)

    local SwitchPin = UI.Create("Frame", SwitchBG, {
        Size = UDim2.new(0, 16, 0, 16), Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    })
    UI.Corner(SwitchPin, 8)

    local function SetState(state)
        Toggled = state
        UpdateFlag(SelfRef, SavedData, Flag, Toggled)
        TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Theme.Accent or Theme.Border}):Play()
        TweenService:Create(SwitchPin, TweenInfo.new(0.2), {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        pcall(Config.Callback or function() end, Toggled)
    end

    Btn.MouseButton1Click:Connect(function() SetState(not Toggled) end)
    if Toggled then pcall(Config.Callback or function() end, Toggled) end

    local Obj = {}
    function Obj:SetValue(v) SetState(v) end
    function Obj:GetValue() return Toggled end
    return Obj
end

function Elements.Slider(Parent, Theme, SavedData, SelfRef, Config)
    local Flag = Config.Flag or Config.Name
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Range = Max - Min
    local Value = SavedData[Flag] ~= nil and SavedData[Flag] or (Config.Default or Min)
    UpdateFlag(SelfRef, SavedData, Flag, Value)

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Theme.Element })
    UI.Corner(Frame, 6)
    UI.Stroke(Frame, Theme.Border)

    UI.Create("TextLabel", Frame, {
        Size = UDim2.new(1, -60, 0, 22), Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1, Text = Config.Name or "Slider", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })

    local ValLbl = UI.Create("TextLabel", Frame, {
        Size = UDim2.new(0, 60, 0, 22), Position = UDim2.new(1, -65, 0, 4),
        BackgroundTransparency = 1, Text = tostring(Value), TextColor3 = Theme.Accent,
        TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Right
    })

    local Bar = UI.Create("Frame", Frame, {
        Size = UDim2.new(0.92, 0, 0, 6), Position = UDim2.new(0.04, 0, 0.7, 0),
        BackgroundColor3 = Theme.Border
    })
    UI.Corner(Bar, 3)

    local InitPos = Range > 0 and (Value - Min) / Range or 0
    local Fill = UI.Create("Frame", Bar, {
        Size = UDim2.new(InitPos, 0, 1, 0), BackgroundColor3 = Theme.Accent
    })
    UI.Corner(Fill, 3)

    local function SetVal(val)
        Value = math.clamp(val, Min, Max)
        ValLbl.Text = tostring(Value)
        local pos = Range > 0 and (Value - Min) / Range or 0
        UpdateFlag(SelfRef, SavedData, Flag, Value)
        TweenService:Create(Fill, TweenInfo.new(0.08), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        pcall(Config.Callback or function() end, Value)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local activeSlider = true
            local conn1, conn2
            conn1 = UserInputService.InputChanged:Connect(function(inp)
                if activeSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    SetVal(math.floor(Min + Range * pos + 0.5))
                end
            end)
            conn2 = UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    activeSlider = false
                    if conn1 then conn1:Disconnect() end
                    if conn2 then conn2:Disconnect() end
                end
            end)
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            SetVal(math.floor(Min + Range * pos + 0.5))
        end
    end)

    pcall(Config.Callback or function() end, Value)

    local Obj = {}
    function Obj:SetValue(v) SetVal(v) end
    function Obj:GetValue() return Value end
    return Obj
end

function Elements.Dropdown(Parent, Theme, SavedData, SelfRef, Config)
    local Flag, Options, IsMulti = Config.Flag or Config.Name, Config.Options or {}, Config.MultiSelect or false
    local SavedVal = SavedData[Flag]
    local Selected = IsMulti and (type(SavedVal) == "table" and SavedVal or (type(Config.Default) == "table" and Config.Default or {})) or (SavedVal and table.find(Options, SavedVal) and SavedVal or (Config.Default or Options[1] or ""))

    local function UpdateFlagVal()
        if SelfRef._configName then SavedData[Flag] = Selected SaveDataToFile(SelfRef._configName, SavedData) end
    end
    UpdateFlagVal()

    local Open, Frame = false, UI.Create("Frame", Parent, { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Element, ClipsDescendants = true })
    UI.Corner(Frame, 6) UI.Stroke(Frame, Theme.Border)

    UI.Create("TextLabel", Frame, { Size = UDim2.new(0.5, 0, 0, 36), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = Config.Name or "Dropdown", TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left })

    local function GetText() return IsMulti and (#Selected == 0 and "None" or (#Selected == #Options and "All" or table.concat(Selected, ", "))) or tostring(Selected) end

    local ValBtn = UI.Create("TextButton", Frame, { Size = UDim2.new(0, 130, 0, 24), Position = UDim2.new(1, -138, 0, 6), BackgroundColor3 = Theme.Card, Text = GetText(), TextColor3 = Theme.Accent, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, TextTruncate = Enum.TextTruncate.AtEnd })
    UI.Corner(ValBtn, 4)

    local OptContainer = UI.Create("ScrollingFrame", Frame, { Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 42), BackgroundTransparency = 1, ScrollBarThickness = 2 })
    local OptLayout = UI.Create("UIListLayout", OptContainer, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })
    OptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() OptContainer.CanvasSize = UDim2.new(0, 0, 0, OptLayout.AbsoluteContentSize.Y + 4) end)

    local function Build()
        for _, c in ipairs(OptContainer:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, opt in ipairs(Options) do
            local isSel = IsMulti and (table.find(Selected, opt) ~= nil) or (Selected == opt)
            local b = UI.Create("TextButton", OptContainer, { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Card, Text = (IsMulti and "    " or "") .. tostring(opt), TextColor3 = isSel and Theme.Text or Theme.SubText, TextSize = 11, Font = isSel and Enum.Font.GothamBold or Enum.Font.Gotham, TextXAlignment = IsMulti and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center, AutoButtonColor = false })
            UI.Corner(b, 4)
            local Check = IsMulti and UI.Create("Frame", b, { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -20, 0.5, -7), BackgroundColor3 = isSel and Theme.Accent or Theme.Element })
            if Check then UI.Corner(Check, 3) UI.Stroke(Check, Theme.Border) end

            b.MouseButton1Click:Connect(function()
                if IsMulti then
                    local idx = table.find(Selected, opt)
                    if idx then table.remove(Selected, idx) isSel = false else table.insert(Selected, opt) isSel = true end
                    b.TextColor3 = isSel and Theme.Text or Theme.SubText b.Font = isSel and Enum.Font.GothamBold or Enum.Font.Gotham Check.BackgroundColor3 = isSel and Theme.Accent or Theme.Element
                    ValBtn.Text = GetText() UpdateFlagVal() pcall(Config.Callback or function() end, Selected)
                else
                    Selected = opt ValBtn.Text = tostring(opt) Open = false
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                    TweenService:Create(OptContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, 0)}):Play()
                    UpdateFlagVal() pcall(Config.Callback or function() end, Selected)
                end
            end)
        end
    end
    Build()

    ValBtn.MouseButton1Click:Connect(function()
        Open = not Open
        local targetH = Open and math.clamp(#Options * 32 + 48, 48, 170) or 36
        local contH = Open and (targetH - 48) or 0
        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
        TweenService:Create(OptContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, contH)}):Play()
    end)

    local Obj = {}
    function Obj:Refresh(newOpts)
        Options = newOpts
        if IsMulti then for i = #Selected, 1, -1 do if not table.find(Options, Selected[i]) then table.remove(Selected, i) end end
        else if not table.find(Options, Selected) then Selected = Options[1] or "" end end
        ValBtn.Text = GetText() Build()
    end
    function Obj:GetValue() return Selected end
    return Obj
end

function Elements.Textbox(Parent, Theme, SavedData, SelfRef, Config)
    local Flag = Config.Flag or Config.Name
    local TextVal = SavedData[Flag] ~= nil and SavedData[Flag] or (Config.Default or "")
    UpdateFlag(SelfRef, SavedData, Flag, TextVal)

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Theme.Element })
    UI.Corner(Frame, 6)
    UI.Stroke(Frame, Theme.Border)

    UI.Create("TextLabel", Frame, {
        Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1, Text = Config.Name or "Textbox", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })

    local Box = UI.Create("TextBox", Frame, {
        Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 0, 24),
        BackgroundColor3 = Theme.Card, PlaceholderText = Config.Placeholder or "Type...",
        PlaceholderColor3 = Theme.SubText, Text = TextVal, TextColor3 = Theme.Accent,
        TextSize = 11, Font = Enum.Font.Gotham, ClearTextOnFocus = false
    })
    UI.Corner(Box, 4)

    local function SetVal(val, trigger)
        TextVal = val
        Box.Text = val
        UpdateFlag(SelfRef, SavedData, Flag, TextVal)
        if trigger then pcall(Config.Callback or function() end, TextVal, true) end
    end

    Box.FocusLost:Connect(function(enter) SetVal(Box.Text, true) end)

    local Obj = {}
    function Obj:GetValue() return Box.Text end
    function Obj:SetValue(v) SetVal(v, true) end
    return Obj
end

function Elements.Keybind(Parent, Theme, SavedData, SelfRef, ActiveConns, Config)
    local Flag = Config.Flag or Config.Name
    local SavedKeyName = SavedData[Flag]
    local DefaultKey = SavedKeyName and Enum.KeyCode[SavedKeyName] or (Config.Default or Enum.KeyCode.E)
    UpdateFlag(SelfRef, SavedData, Flag, typeof(DefaultKey) == "EnumItem" and DefaultKey.Name or tostring(DefaultKey))

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Elem