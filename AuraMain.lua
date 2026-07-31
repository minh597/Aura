--[[
    Aura UI Pro - Optimized, Secured & Upgraded Version
    - Clean architecture, high-performance tensing, robust event pooling.
    - Added modern features like Search bar for Dropdowns, smooth color transitions, 
      improved notification stacking, and enhanced key system handling.
]]

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
    Version = "2.5.0"
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
        Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1,
        Text = Config.Name or "Label", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })
    local Obj = {}
    function Obj:Set(t) Label.Text = t end
    function Obj:Get() return Label.Text end
    return Obj
end

function Elements.Paragraph(Parent, Theme, Config)
    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 56), BackgroundColor3 = Theme.Element })
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
    local Div = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 6), BackgroundTransparency = 1 })
    UI.Create("Frame", Div, { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Theme.Border, BorderSizePixel = 0 })
end

function Elements.Section(Parent, Theme, Text)
    UI.Create("TextLabel", Parent, {
        Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1,
        Text = "  " .. string.upper(Text), TextColor3 = Theme.Accent,
        TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
    })
end

function Elements.Button(Parent, Theme, Config)
    local Btn = UI.Create("TextButton", Parent, {
        Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.Element,
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
        Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.Element,
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

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 50), BackgroundColor3 = Theme.Element })
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

    local Open, Frame = false, UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.Element, ClipsDescendants = true })
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
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(0.98, 0, 0, 36)}):Play()
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
        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(0.98, 0, 0, targetH)}):Play()
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

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 52), BackgroundColor3 = Theme.Element })
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

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.Element })
    UI.Corner(Frame, 6)
    UI.Stroke(Frame, Theme.Border)

    UI.Create("TextLabel", Frame, {
        Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Text = Config.Name or "Keybind", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })

    local KeyBtn = UI.Create("TextButton", Frame, {
        Size = UDim2.new(0, 90, 0, 24), Position = UDim2.new(1, -98, 0.5, -12),
        BackgroundColor3 = Theme.Card, Text = typeof(DefaultKey) == "EnumItem" and DefaultKey.Name or tostring(DefaultKey),
        TextColor3 = Theme.Accent, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false
    })
    UI.Corner(KeyBtn, 4)

    local currentKey = DefaultKey
    local listening = false
    KeyBtn.MouseButton1Click:Connect(function() listening = true; KeyBtn.Text = "..." end)

    TrackConn(ActiveConns, UserInputService.InputBegan:Connect(function(input, proc)
        if listening and not proc and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            currentKey = input.KeyCode
            KeyBtn.Text = currentKey.Name
            UpdateFlag(SelfRef, SavedData, Flag, currentKey.Name)
            pcall(Config.Callback or function() end, currentKey)
        end
    end))

    local Obj = {}
    function Obj:GetValue() return currentKey end
    return Obj
end

function AuraPro:CreateKeyTab(Config)
    Config = Config or {}
    local TitleText = Config.Name or "Aura UI - Key System"
    local CorrectKey = Config.Key or "Aura2026"
    local LinkToGet = Config.Link or ""
    local SelectedTheme = Config.Theme or self.Themes.Dark
    local UserScale = (Config.Scale or 1.0) * 1.1
    local SuccessCallback = Config.Callback or function() end
    local KeySaveFile = Config.KeySave or self.KeyConfigName
    local KeyIcon = Config.Image or ""

    local KeyData = LoadDataFromFile(KeySaveFile)
    if KeyData.SavedKey == CorrectKey then
        pcall(SuccessCallback)
        return
    end

    local KeyGui = UI.Create("ScreenGui", CachedParent, { Name = "Aura_KeySystem_UI", ResetOnSpawn = false })
    local MainFrame = UI.Create("Frame", KeyGui, {
        Size = UDim2.new(0, 380, 0, 230), Position = UDim2.new(0.5, -190, 0.5, -135),
        BackgroundTransparency = 1, BackgroundColor3 = SelectedTheme.Background
    })
    UI.Corner(MainFrame, 10)
    UI.Stroke(MainFrame, SelectedTheme.Border)
    local UIScale = UI.Create("UIScale", MainFrame, { Scale = 0 })

    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = UserScale}):Play()

    local TopBar = UI.Create("Frame", MainFrame, { Size = UDim2.new(1, -16, 0, 36), Position = UDim2.new(0, 8, 0, 8), BackgroundColor3 = SelectedTheme.Card })
    UI.Corner(TopBar, 6)
    MakeDraggable(MainFrame, TopBar)

    if KeyIcon ~= "" then
        local IconObj = UI.Create("ImageLabel", TopBar, { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 8, 0.5, -11), BackgroundTransparency = 1, Image = KeyIcon })
        UI.Corner(IconObj, 4)
        UI.Create("TextLabel", TopBar, {
            Size = UDim2.new(1, -38, 1, 0), Position = UDim2.new(0, 34, 0, 0), BackgroundTransparency = 1,
            Text = TitleText, TextColor3 = SelectedTheme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
        })
    else
        UI.Create("TextLabel", TopBar, {
            Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1,
            Text = TitleText, TextColor3 = SelectedTheme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
        })
    end

    local KeyBox = UI.Create("TextBox", MainFrame, {
        Size = UDim2.new(1, -24, 0, 38), Position = UDim2.new(0, 12, 0, 58), BackgroundColor3 = SelectedTheme.Element,
        PlaceholderText = "Enter key here...", PlaceholderColor3 = SelectedTheme.SubText, Text = "", TextColor3 = SelectedTheme.Text, TextSize = 12, Font = Enum.Font.Gotham
    })
    UI.Corner(KeyBox, 6)

    local SubmitBtn = UI.Create("TextButton", MainFrame, {
        Size = UDim2.new(1, -24, 0, 36), Position = UDim2.new(0, 12, 0, 106), BackgroundColor3 = SelectedTheme.Accent,
        Text = "SUBMIT KEY", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false
    })
    UI.Corner(SubmitBtn, 6)

    local GetKeyBtn = UI.Create("TextButton", MainFrame, {
        Size = UDim2.new(1, -24, 0, 32), Position = UDim2.new(0, 12, 0, 150), BackgroundColor3 = SelectedTheme.Element,
        Text = "GET KEY", TextColor3 = SelectedTheme.SubText, TextSize = 11, Font = Enum.Font.GothamMedium, AutoButtonColor = false
    })
    UI.Corner(GetKeyBtn, 6)

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyBox.Text == CorrectKey then
            SubmitBtn.Text = "SUCCESS!"
            SubmitBtn.BackgroundColor3 = SelectedTheme.Success
            SaveDataToFile(KeySaveFile, {SavedKey = CorrectKey})
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
            local closeAnim = TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
            closeAnim:Play()
            closeAnim.Completed:Connect(function() KeyGui:Destroy(); pcall(SuccessCallback) end)
        else
            SubmitBtn.Text = "INVALID KEY!"
            SubmitBtn.BackgroundColor3 = SelectedTheme.Danger
            task.wait(1)
            SubmitBtn.Text = "SUBMIT KEY"
            SubmitBtn.BackgroundColor3 = SelectedTheme.Accent
        end
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(LinkToGet) end
        GetKeyBtn.Text = "COPIED LINK TO CLIPBOARD!"
        task.wait(2)
        GetKeyBtn.Text = "GET KEY"
    end)
end

function AuraPro:CreateKeySystem(Config)
    return self:CreateKeyTab(Config)
end

function AuraPro:CreateWindow(Config)
    Config = Config or {}
    local TitleText = Config.Name or "Aura UI Pro"
    local SelectedTheme = Config.Theme or self.Themes.Dark
    local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    local BaseWidth = Config.Width or 640
    local BaseHeight = Config.Height or 440
    local UserScale = Config.Scale or 1.2
    local HubImage = Config.Image or ""

    self._configName = Config.ConfigSave or nil
    local activeConns = {}
    local savedData = LoadDataFromFile(self._configName)

    local ScreenGui = UI.Create("ScreenGui", CachedParent, { Name = "Aura_Pro_UI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    local NotifContainer = UI.Create("Frame", ScreenGui, { Size = UDim2.new(0, 300, 1, -20), Position = UDim2.new(1, -310, 0, 10), BackgroundTransparency = 1, ZIndex = 9999 })
    UI.Create("UIListLayout", NotifContainer, { VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

    function AuraPro:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local card = UI.Create("Frame", NotifContainer, { Size = UDim2.new(1, 0, 0, 68), BackgroundColor3 = SelectedTheme.Card, Position = UDim2.new(1, 350, 0, 0) })
        UI.Corner(card, 8)
        UI.Stroke(card, SelectedTheme.Accent)

        UI.Create("TextLabel", card, { Size = UDim2.new(1, -16, 0, 22), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1, Text = notifConfig.Title or "Notification", TextColor3 = SelectedTheme.Accent, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left })
        UI.Create("TextLabel", card, { Size = UDim2.new(1, -16, 0, 34), Position = UDim2.new(0, 10, 0, 28), BackgroundTransparency = 1, Text = notifConfig.Content or "", TextColor3 = SelectedTheme.SubText, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true })

        TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(notifConfig.Duration or 3.5, function()
            local out = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 350, 0, 0)})
            out:Play()
            out.Completed:Connect(function() card:Destroy() end)
        end)
    end

    local MainFrame = UI.Create("Frame", ScreenGui, { Size = UDim2.new(0, BaseWidth, 0, BaseHeight), Position = UDim2.new(0.5, -BaseWidth / 2, 0.5, -BaseHeight / 2), BackgroundColor3 = SelectedTheme.Background })
    UI.Corner(MainFrame, 10)
    UI.Stroke(MainFrame, SelectedTheme.Border)
    local MainScale = UI.Create("UIScale", MainFrame, { Scale = 0 })
    TweenService:Create(MainScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = UserScale}):Play()

    local MinifiedGui = UI.Create("ScreenGui", CachedParent, { Name = "Aura_Minified_Icon", ResetOnSpawn = false, Enabled = false })
    local FloatBtn = UI.Create("ImageButton", MinifiedGui, { Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 50, 0, 200), BackgroundColor3 = SelectedTheme.Card, Image = HubImage ~= "" and HubImage or "rbxassetid://6023426915", AutoButtonColor = false })
    UI.Corner(FloatBtn, 25)
    UI.Stroke(FloatBtn, SelectedTheme.Accent, 2)
    MakeDraggable(FloatBtn, FloatBtn)

    local TopBar = UI.Create("Frame", MainFrame, { Size = UDim2.new(1, -20, 0, 42), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = SelectedTheme.Card })
    UI.Corner(TopBar, 8)
    MakeDraggable(MainFrame, TopBar)

    if HubImage ~= "" then
        local HubIcon = UI.Create("ImageLabel", TopBar, { Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 10, 0.5, -13), BackgroundTransparency = 1, Image = HubImage })
        UI.Corner(HubIcon, 6)
        UI.Create("TextLabel", TopBar, { Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 44, 0, 0), BackgroundTransparency = 1, Text = TitleText, TextColor3 = SelectedTheme.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left })
    else
        UI.Create("TextLabel", TopBar, { Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1, Text = TitleText, TextColor3 = SelectedTheme.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left })
    end

    local Controls = UI.Create("Frame", TopBar, { Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -75, 0, 0), BackgroundTransparency = 1 })
    local MinBtn = UI.Create("TextButton", Controls, { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 0, 0.5, -14), BackgroundColor3 = SelectedTheme.Element, Text = "—", TextColor3 = SelectedTheme.SubText, TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false })
    UI.Corner(MinBtn, 6)
    local CloseBtn = UI.Create("ImageButton", Controls, { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 34, 0.5, -14), BackgroundColor3 = Color3.fromRGB(235, 60, 60), BackgroundTransparency = 0.85, Image = "rbxassetid://6035047409", ImageColor3 = Color3.fromRGB(255, 100, 100), AutoButtonColor = false })
    UI.Corner(CloseBtn, 6)

    local function ToggleUI(state)
        MainFrame.Visible = state
        MinifiedGui.Enabled = not state
    end

    MinBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
    FloatBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)

    local WindowObj = {CurrentTab = nil, Tabs = {}}
    function WindowObj:Destroy()
        for _, conn in ipairs(activeConns) do if conn then conn:Disconnect() end end
        table.clear(activeConns)
        ScreenGui:Destroy()
        MinifiedGui:Destroy()
    end

    CloseBtn.MouseButton1Click:Connect(function()
        local anim = TweenService:Create(MainScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
        anim:Play()
        anim.Completed:Connect(function() WindowObj:Destroy() end)
    end)

    TrackConn(activeConns, UserInputService.InputBegan:Connect(function(input, proc)
        if not proc and input.KeyCode == ToggleKey then ToggleUI(not MainFrame.Visible) end
    end))

    local TabBar = UI.Create("Frame", MainFrame, { Size = UDim2.new(0, 150, 1, -65), Position = UDim2.new(0, 10, 0, 58), BackgroundColor3 = SelectedTheme.Card })
    UI.Corner(TabBar, 8)
    local TabScroll = UI.Create("ScrollingFrame", TabBar, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 2 })
    UI.Create("UIListLayout", TabScroll, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })
    UI.Create("UIPadding", TabScroll, { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6) })

    local PagesArea = UI.Create("Frame", MainFrame, { Size = UDim2.new(1, -170, 1, -65), Position = UDim2.new(0, 170, 0, 58), BackgroundColor3 = SelectedTheme.Card, ClipsDescendants = true })
    UI.Corner(PagesArea, 8)

    function WindowObj:CreateTab(Name, TabImage)
        local TabBtn = UI.Create("TextButton", TabScroll, { Size = UDim2.new(0, 138, 0, 32), BackgroundColor3 = SelectedTheme.Element, BackgroundTransparency = 0.7, Text = "", TextColor3 = SelectedTheme.SubText, TextSize = 12, Font = Enum.Font.GothamMedium, AutoButtonColor = false })
        UI.Corner(TabBtn, 6)

        if TabImage and TabImage ~= "" then
            UI.Create("ImageLabel", TabBtn, { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 8, 0.5, -9), BackgroundTransparency = 1, Image = TabImage })
            UI.Create("TextLabel", TabBtn, { Size = UDim2.new(1, -32, 1, 0), Position = UDim2.new(0, 30, 0, 0), BackgroundTransparency = 1, Text = Name, TextColor3 = SelectedTheme.SubText, TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left })
        else
            UI.Create("TextLabel", TabBtn, { Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = Name, TextColor3 = SelectedTheme.SubText, TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left })
        end

        local Page = UI.Create("ScrollingFrame", PagesArea, { Size = UDim2.new(1, -12, 1, -12), Position = UDim2.new(0, 6, 0, 6), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 3 })
        local PageLayout = UI.Create("UIListLayout", Page, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 12)
        end)

        local function SelectThisTab()
            if WindowObj.CurrentTab == Page then return end
            for _, t in ipairs(WindowObj.Tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundTransparency = 0.7
                t.Btn.TextColor3 = SelectedTheme.SubText
                for _, child in ipairs(t.Btn:GetChildren()) do
                    if child:IsA("TextLabel") then child.TextColor3 = SelectedTheme.SubText end
                end
            end
            WindowObj.CurrentTab = Page
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = SelectedTheme.Text
            for _, child in ipairs(TabBtn:GetChildren()) do
                if child:IsA("TextLabel") then child.TextColor3 = SelectedTheme.Text end
            end
        end

        TabBtn.MouseButton1Click:Connect(SelectThisTab)

        if #WindowObj.Tabs == 0 then
            WindowObj.CurrentTab = Page
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = SelectedTheme.Text
            for _, child in ipairs(TabBtn:GetChildren()) do
                if child:IsA("TextLabel") then child.TextColor3 = SelectedTheme.Text end
            end
        end

        table.insert(WindowObj.Tabs, {Btn = TabBtn, Page = Page})

        local TabElements = {}
        function TabElements:CreateLabel(c) return Elements.Label(Page, SelectedTheme, c) end
        function TabElements:CreateParagraph(c) return Elements.Paragraph(Page, SelectedTheme, c) end
        function TabElements:CreateDivider() return Elements.Divider(Page, SelectedTheme) end
        function TabElements:CreateSection(t) return Elements.Section(Page, SelectedTheme, t) end
        function TabElements:CreateButton(c) return Elements.Button(Page, SelectedTheme, c) end
        function TabElements:CreateToggle(c) return Elements.Toggle(Page, SelectedTheme, savedData, AuraPro, c) end
        function TabElements:CreateSlider(c) return Elements.Slider(Page, SelectedTheme, savedData, AuraPro, c) end
        function TabElements:CreateDropdown(c) return Elements.Dropdown(Page, SelectedTheme, savedData, AuraPro, c) end
        function TabElements:CreateTextbox(c) return Elements.Textbox(Page, SelectedTheme, savedData, AuraPro, c) end
        function TabElements:CreateKeybind(c) return Elements.Keybind(Page, SelectedTheme, savedData, AuraPro, activeConns, c) end

        return TabElements
    end

    return WindowObj
end

return AuraPro
