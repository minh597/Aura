-- Aura UI Pro - Main Entry with Remote Themes Link
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
    ConfigName = nil,
    KeyConfigName = "AuraKey_Save.json",
    ActiveConnections = {}
}

-- Load Themes directly from the remote link
local SuccessTheme, RemoteThemes = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/Themes.lua"))()
end)

AuraPro.Themes = (SuccessTheme and RemoteThemes and RemoteThemes.Themes) or {
    Dark = {
        Background = Color3.fromRGB(18, 19, 24),
        Card = Color3.fromRGB(25, 27, 34),
        Element = Color3.fromRGB(33, 36, 46),
        Border = Color3.fromRGB(48, 52, 66),
        Text = Color3.fromRGB(240, 242, 248),
        SubText = Color3.fromRGB(145, 152, 172),
        Accent = Color3.fromRGB(99, 102, 241),
        Success = Color3.fromRGB(34, 197, 94),
        Danger = Color3.fromRGB(239, 68, 68)
    }
}

function AuraPro:TrackConnection(Conn)
    table.insert(self.ActiveConnections, Conn)
    return Conn
end

function AuraPro:SaveConfig(FileName, Data)
    if FileName and writefile then
        pcall(function() writefile(FileName, HttpService:JSONEncode(Data)) end)
    end
end

function AuraPro:LoadConfig(FileName)
    if FileName and readfile and isfile and isfile(FileName) then
        local Success, Decoded = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if Success then return Decoded end
    end
    return {}
end

function AuraPro:SetFlag(SavedData, Flag, Value)
    if self.ConfigName then
        SavedData[Flag] = Value
        self:SaveConfig(self.ConfigName, SavedData)
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

local GlobalDragging = false
local GlobalDragInput, GlobalDragStart, GlobalStartPos, GlobalTargetFrame

AuraPro:TrackConnection(UserInputService.InputBegan:Connect(function(Input)
    if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and GlobalTargetFrame then
        GlobalDragging = true
        GlobalDragStart = Input.Position
        GlobalStartPos = GlobalTargetFrame.Position
    end
end))

AuraPro:TrackConnection(UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        GlobalDragging = false
    end
end))

AuraPro:TrackConnection(UserInputService.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        GlobalDragInput = Input
    end
    if GlobalDragging and GlobalTargetFrame and GlobalDragInput == Input then
        local Delta = Input.Position - GlobalDragStart
        GlobalTargetFrame.Position = UDim2.new(GlobalStartPos.X.Scale, GlobalStartPos.X.Offset + Delta.X, GlobalStartPos.Y.Scale, GlobalStartPos.Y.Offset + Delta.Y)
    end
end))

local function MakeDraggable(Frame, Handle)
    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            GlobalTargetFrame = Frame
        end
    end)
    Handle.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            if GlobalTargetFrame == Frame then GlobalTargetFrame = nil end
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
    function Obj:Set(Txt) Label.Text = Txt end
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
    local Div = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 4), BackgroundTransparency = 1 })
    UI.Create("Frame", Div, { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Theme.Border, BorderSizePixel = 0 })
end

function Elements.Section(Parent, Theme, Text)
    UI.Create("TextLabel", Parent, {
        Size = UDim2.new(0.98, 0, 0, 22), BackgroundTransparency = 1,
        Text = "• " .. string.upper(Text), TextColor3 = Theme.Accent,
        TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
    })
end

function Elements.Button(Parent, Theme, Config)
    local Btn = UI.Create("TextButton", Parent, {
        Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.Element,
        Text = "    " .. (Config.Name or "Button"), TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })
    UI.Corner(Btn, 6)
    UI.Stroke(Btn, Theme.Border)
    Btn.MouseButton1Click:Connect(function() pcall(Config.Callback or function() end) end)
end

function Elements.Toggle(Parent, Theme, SavedData, Config)
    local Flag = Config.Flag or Config.Name
    local Toggled = SavedData[Flag] ~= nil and SavedData[Flag] or (Config.Default or false)
    AuraPro:SetFlag(SavedData, Flag, Toggled)

    local Btn = UI.Create("TextButton", Parent, {
        Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.Element,
        Text = "    " .. (Config.Name or "Toggle"), TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })
    UI.Corner(Btn, 6)
    UI.Stroke(Btn, Theme.Border)

    local SwitchBG = UI.Create("Frame", Btn, {
        Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -42, 0.5, -9),
        BackgroundColor3 = Toggled and Theme.Accent or Theme.Border
    })
    UI.Corner(SwitchBG, 9)

    local SwitchPin = UI.Create("Frame", SwitchBG, {
        Size = UDim2.new(0, 14, 0, 14), Position = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    })
    UI.Corner(SwitchPin, 7)

    local function SetState(State)
        Toggled = State
        AuraPro:SetFlag(SavedData, Flag, Toggled)
        TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Theme.Accent or Theme.Border}):Play()
        TweenService:Create(SwitchPin, TweenInfo.new(0.2), {Position = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        pcall(Config.Callback or function() end, Toggled)
    end

    Btn.MouseButton1Click:Connect(function() SetState(not Toggled) end)
    if Toggled then pcall(Config.Callback or function() end, Toggled) end

    local Obj = {}
    function Obj:SetValue(v) SetState(v) end
    function Obj:GetValue() return Toggled end
    return Obj
end

function Elements.Slider(Parent, Theme, SavedData, Config)
    local Flag = Config.Flag or Config.Name
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Range = Max - Min
    local Value = SavedData[Flag] ~= nil and SavedData[Flag] or (Config.Default or Min)
    AuraPro:SetFlag(SavedData, Flag, Value)

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 48), BackgroundColor3 = Theme.Element })
    UI.Corner(Frame, 6)
    UI.Stroke(Frame, Theme.Border)

    UI.Create("TextLabel", Frame, {
        Size = UDim2.new(1, -60, 0, 22), Position = UDim2.new(0, 10, 0, 2),
        BackgroundTransparency = 1, Text = Config.Name or "Slider", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })

    local ValLbl = UI.Create("TextLabel", Frame, {
        Size = UDim2.new(0, 50, 0, 22), Position = UDim2.new(1, -55, 0, 2),
        BackgroundTransparency = 1, Text = tostring(Value), TextColor3 = Theme.Accent,
        TextSize = 12, Font = Enum.Font.GothamBold
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

    local function SetVal(Val)
        Value = math.clamp(Val, Min, Max)
        ValLbl.Text = tostring(Value)
        local Pos = Range > 0 and (Value - Min) / Range or 0
        AuraPro:SetFlag(SavedData, Flag, Value)
        TweenService:Create(Fill, TweenInfo.new(0.08), {Size = UDim2.new(Pos, 0, 1, 0)}):Play()
        pcall(Config.Callback or function() end, Value)
    end

    Bar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            local ActiveSlider = true
            local conn1, conn2
            conn1 = UserInputService.InputChanged:Connect(function(inp)
                if ActiveSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    local Pos = math.clamp((inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    SetVal(math.floor(Min + Range * Pos))
                end
            end)
            conn2 = UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    ActiveSlider = false
                    if conn1 then conn1:Disconnect() end
                    if conn2 then conn2:Disconnect() end
                end
            end)
            local Pos = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            SetVal(math.floor(Min + Range * Pos))
        end
    end)

    pcall(Config.Callback or function() end, Value)

    local Obj = {}
    function Obj:SetValue(v) SetVal(v) end
    function Obj:GetValue() return Value end
    return Obj
end

function Elements.Dropdown(Parent, Theme, SavedData, Config)
    local Flag = Config.Flag or Config.Name
    local Options = Config.Options or {}
    local SavedVal = SavedData[Flag]
    local Selected = SavedVal and table.find(Options, SavedVal) and SavedVal or (Config.Default or Options[1] or "")
    local DropdownOpen = false
    AuraPro:SetFlag(SavedData, Flag, Selected)

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.Element, ClipsDescendants = true })
    UI.Corner(Frame, 6)
    UI.Stroke(Frame, Theme.Border)

    UI.Create("TextLabel", Frame, {
        Size = UDim2.new(0.5, 0, 0, 36), Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Text = Config.Name or "Dropdown", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })

    local ValBtn = UI.Create("TextButton", Frame, {
        Size = UDim2.new(0, 120, 0, 24), Position = UDim2.new(1, -128, 0, 6),
        BackgroundColor3 = Theme.Card, Text = tostring(Selected), TextColor3 = Theme.Accent,
        TextSize = 11, Font = Enum.Font.GothamBold
    })
    UI.Corner(ValBtn, 4)

    local OptContainer = UI.Create("ScrollingFrame", Frame, {
        Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 42),
        BackgroundTransparency = 1, ScrollBarThickness = 2
    })
    local OptLayout = UI.Create("UIListLayout", OptContainer, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })
    OptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        OptContainer.CanvasSize = UDim2.new(0, 0, 0, OptLayout.AbsoluteContentSize.Y + 4)
    end)

    local function Build()
        for _, c in ipairs(OptContainer:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, opt in ipairs(Options) do
            local b = UI.Create("TextButton", OptContainer, {
                Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Card,
                Text = tostring(opt), TextColor3 = Theme.SubText, TextSize = 11, Font = Enum.Font.Gotham
            })
            UI.Corner(b, 4)
            b.MouseButton1Click:Connect(function()
                Selected = opt
                ValBtn.Text = tostring(opt)
                DropdownOpen = false
                TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(0.98, 0, 0, 36)}):Play()
                TweenService:Create(OptContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, 0)}):Play()
                AuraPro:SetFlag(SavedData, Flag, Selected)
                pcall(Config.Callback or function() end, Selected)
            end)
        end
    end
    Build()

    ValBtn.MouseButton1Click:Connect(function()
        DropdownOpen = not DropdownOpen
        local TargetH = DropdownOpen and math.clamp(#Options * 32 + 48, 48, 160) or 36
        local ContH = DropdownOpen and (TargetH - 48) or 0
        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(0.98, 0, 0, TargetH)}):Play()
        TweenService:Create(OptContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, ContH)}):Play()
    end)

    local Obj = {}
    function Obj:Refresh(newOpts)
        Options = newOpts
        if not table.find(Options, Selected) then
            Selected = Options[1] or ""
            ValBtn.Text = tostring(Selected)
        end
        Build()
    end
    function Obj:GetValue() return Selected end
    return Obj
end

function Elements.Textbox(Parent, Theme, SavedData, Config)
    local Flag = Config.Flag or Config.Name
    local TextVal = SavedData[Flag] ~= nil and SavedData[Flag] or (Config.Default or "")
    AuraPro:SetFlag(SavedData, Flag, TextVal)

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
        TextSize = 11, Font = Enum.Font.Gotham
    })
    UI.Corner(Box, 4)

    local function SetVal(Val, Trigger)
        TextVal = Val
        Box.Text = Val
        AuraPro:SetFlag(SavedData, Flag, TextVal)
        if Trigger then pcall(Config.Callback or function() end, TextVal, true) end
    end

    Box.FocusLost:Connect(function(Enter) SetVal(Box.Text, true) end)

    local Obj = {}
    function Obj:GetValue() return Box.Text end
    function Obj:SetValue(v) SetVal(v, true) end
    return Obj
end

function Elements.Keybind(Parent, Theme, SavedData, Config)
    local Flag = Config.Flag or Config.Name
    local SavedKeyName = SavedData[Flag]
    local DefaultKey = SavedKeyName and Enum.KeyCode[SavedKeyName] or (Config.Default or Enum.KeyCode.E)
    AuraPro:SetFlag(SavedData, Flag, typeof(DefaultKey) == "EnumItem" and DefaultKey.Name or tostring(DefaultKey))

    local Frame = UI.Create("Frame", Parent, { Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.Element })
    UI.Corner(Frame, 6)
    UI.Stroke(Frame, Theme.Border)

    UI.Create("TextLabel", Frame, {
        Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Text = Config.Name or "Keybind", TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left
    })

    local KeyBtn = UI.Create("TextButton", Frame, {
        Size = UDim2.new(0, 80, 0, 24), Position = UDim2.new(1, -88, 0.5, -12),
        BackgroundColor3 = Theme.Card, Text = typeof(DefaultKey) == "EnumItem" and DefaultKey.Name or tostring(DefaultKey),
        TextColor3 = Theme.Accent, TextSize = 11, Font = Enum.Font.GothamBold
    })
    UI.Corner(KeyBtn, 4)

    local CurrentKey = DefaultKey
    local Listening = false
    KeyBtn.MouseButton1Click:Connect(function() Listening = true; KeyBtn.Text = "..." end)

    AuraPro:TrackConnection(UserInputService.InputBegan:Connect(function(Input, Proc)
        if Listening and not Proc and Input.UserInputType == Enum.UserInputType.Keyboard then
            Listening = false
            CurrentKey = Input.KeyCode
            KeyBtn.Text = CurrentKey.Name
            AuraPro:SetFlag(SavedData, Flag, CurrentKey.Name)
            pcall(Config.Callback or function() end, CurrentKey)
        end
    end))

    local Obj = {}
    function Obj:GetValue() return CurrentKey end
    return Obj
end

function AuraPro:CreateKeySystem(Config)
    Config = Config or {}
    local TitleText = Config.Name or "Aura UI - Key System"
    local CorrectKey = Config.Key or "Aura2026"
    local LinkToGet = Config.Link or ""
    local SelectedTheme = Config.Theme or self.Themes.Dark
    local UserScale = (Config.Scale or 1.0) * 1.1
    local SuccessCallback = Config.Callback or function() end
    local KeySaveFile = Config.KeySave or self.KeyConfigName

    local KeyData = self:LoadConfig(KeySaveFile)
    if KeyData.SavedKey == CorrectKey then
        pcall(SuccessCallback)
        return
    end

    local KeyGui = UI.Create("ScreenGui", CachedParent, { Name = "Aura_KeySystem_UI", ResetOnSpawn = false })
    local MainFrame = UI.Create("Frame", KeyGui, {
        Size = UDim2.new(0, 380, 0, 220), Position = UDim2.new(0.5, -190, 0.5, -130),
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

    UI.Create("TextLabel", TopBar, {
        Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1,
        Text = TitleText, TextColor3 = SelectedTheme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
    })

    local KeyBox = UI.Create("TextBox", MainFrame, {
        Size = UDim2.new(1, -24, 0, 38), Position = UDim2.new(0, 12, 0, 58), BackgroundColor3 = SelectedTheme.Element,
        PlaceholderText = "Enter key here...", PlaceholderColor3 = SelectedTheme.SubText, Text = "", TextColor3 = SelectedTheme.Text, TextSize = 12, Font = Enum.Font.Gotham
    })
    UI.Corner(KeyBox, 6)

    local SubmitBtn = UI.Create("TextButton", MainFrame, {
        Size = UDim2.new(1, -24, 0, 36), Position = UDim2.new(0, 12, 0, 106), BackgroundColor3 = SelectedTheme.Accent,
        Text = "SUBMIT KEY", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBold
    })
    UI.Corner(SubmitBtn, 6)

    local GetKeyBtn = UI.Create("TextButton", MainFrame, {
        Size = UDim2.new(1, -24, 0, 32), Position = UDim2.new(0, 12, 0, 150), BackgroundColor3 = SelectedTheme.Element,
        Text = "GET KEY", TextColor3 = SelectedTheme.SubText, TextSize = 11, Font = Enum.Font.GothamMedium
    })
    UI.Corner(GetKeyBtn, 6)

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyBox.Text == CorrectKey then
            SubmitBtn.Text = "SUCCESS!"
            SubmitBtn.BackgroundColor3 = SelectedTheme.Success
            self:SaveConfig(KeySaveFile, {SavedKey = CorrectKey})
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
            local CloseAnim = TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
            CloseAnim:Play()
            CloseAnim.Completed:Connect(function() KeyGui:Destroy(); pcall(SuccessCallback) end)
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

function AuraPro:CreateWindow(Config)
    Config = Config or {}
    local TitleText = Config.Name or "Aura UI Pro"
    local SelectedTheme = Config.Theme or self.Themes.Dark
    local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    local BaseWidth = Config.Width or 640
    local BaseHeight = Config.Height or 440
    local UserScale = Config.Scale or 1.2
    local HubImage = Config.Image or ""

    self.ConfigName = Config.ConfigSave or nil
    local SavedData = self:LoadConfig(self.ConfigName)

    local ScreenGui = UI.Create("ScreenGui", CachedParent, { Name = "Aura_Pro_UI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    local NotifContainer = UI.Create("Frame", ScreenGui, { Size = UDim2.new(0, 300, 1, -20), Position = UDim2.new(1, -310, 0, 10), BackgroundTransparency = 1, ZIndex = 9999 })
    UI.Create("UIListLayout", NotifContainer, { VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 8) })

    function AuraPro:Notify(NotifConfig)
        NotifConfig = NotifConfig or {}
        local Card = UI.Create("Frame", NotifContainer, { Size = UDim2.new(1, 0, 0, 68), BackgroundColor3 = SelectedTheme.Card, Position = UDim2.new(1, 350, 0, 0) })
        UI.Corner(Card, 8)
        UI.Stroke(Card, SelectedTheme.Accent)

        UI.Create("TextLabel", Card, { Size = UDim2.new(1, -16, 0, 22), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1, Text = NotifConfig.Title or "Notification", TextColor3 = SelectedTheme.Accent, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left })
        UI.Create("TextLabel", Card, { Size = UDim2.new(1, -16, 0, 34), Position = UDim2.new(0, 10, 0, 28), BackgroundTransparency = 1, Text = NotifConfig.Content or "", TextColor3 = SelectedTheme.SubText, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true })

        TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(NotifConfig.Duration or 3.5, function()
            local Out = TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 350, 0, 0)})
            Out:Play()
            Out.Completed:Connect(function() Card:Destroy() end)
        end)
    end

    local MainFrame = UI.Create("Frame", ScreenGui, { Size = UDim2.new(0, BaseWidth, 0, BaseHeight), Position = UDim2.new(0.5, -BaseWidth / 2, 0.5, -BaseHeight / 2), BackgroundColor3 = SelectedTheme.Background })
    UI.Corner(MainFrame, 10)
    UI.Stroke(MainFrame, SelectedTheme.Border)
    local MainScale = UI.Create("UIScale", MainFrame, { Scale = 0 })
    TweenService:Create(MainScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = UserScale}):Play()

    local MinifiedGui = UI.Create("ScreenGui", CachedParent, { Name = "Aura_Minified_Icon", ResetOnSpawn = false, Enabled = false })
    local FloatBtn = UI.Create("ImageButton", MinifiedGui, { Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 50, 0, 200), BackgroundColor3 = SelectedTheme.Card, Image = HubImage ~= "" and HubImage or "rbxassetid://6023426915" })
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
    local MinBtn = UI.Create("TextButton", Controls, { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 0, 0.5, -14), BackgroundColor3 = SelectedTheme.Element, Text = "—", TextColor3 = SelectedTheme.SubText, TextSize = 12, Font = Enum.Font.GothamBold })
    UI.Corner(MinBtn, 6)
    local CloseBtn = UI.Create("ImageButton", Controls, { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 34, 0.5, -14), BackgroundColor3 = Color3.fromRGB(235, 60, 60), BackgroundTransparency = 0.85, Image = "rbxassetid://6035047409", ImageColor3 = Color3.fromRGB(255, 100, 100) })
    UI.Corner(CloseBtn, 6)

    local function ToggleUI(State)
        MainFrame.Visible = State
        MinifiedGui.Enabled = not State
    end

    MinBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
    FloatBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)

    local WindowObj = {CurrentTab = nil, Tabs = {}}
    function WindowObj:Destroy()
        for _, Conn in ipairs(self.ActiveConnections) do if Conn then Conn:Disconnect() end end
        table.clear(self.ActiveConnections)
        ScreenGui:Destroy()
        MinifiedGui:Destroy()
    end

    CloseBtn.MouseButton1Click:Connect(function()
        local Anim = TweenService:Create(MainScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
        Anim:Play()
        Anim.Completed:Connect(function() WindowObj:Destroy() end)
    end)

    self:TrackConnection(UserInputService.InputBegan:Connect(function(Input, Proc)
        if not Proc and Input.KeyCode == ToggleKey then ToggleUI(not MainFrame.Visible) end
    end))

    local TabBar = UI.Create("Frame", MainFrame, { Size = UDim2.new(0, 150, 1, -65), Position = UDim2.new(0, 10, 0, 58), BackgroundColor3 = SelectedTheme.Card })
    UI.Corner(TabBar, 8)
    local TabScroll = UI.Create("ScrollingFrame", TabBar, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 2 })
    UI.Create("UIListLayout", TabScroll, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })
    UI.Create("UIPadding", TabScroll, { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6) })

    local PagesArea = UI.Create("Frame", MainFrame, { Size = UDim2.new(1, -170, 1, -65), Position = UDim2.new(0, 170, 0, 58), BackgroundColor3 = SelectedTheme.Card, ClipsDescendants = true })
    UI.Corner(PagesArea, 8)

    function WindowObj:CreateTab(Name)
        local TabBtn = UI.Create("TextButton", TabScroll, { Size = UDim2.new(0, 138, 0, 32), BackgroundColor3 = SelectedTheme.Element, BackgroundTransparency = 0.7, Text = Name, TextColor3 = SelectedTheme.SubText, TextSize = 12, Font = Enum.Font.GothamMedium })
        UI.Corner(TabBtn, 6)

        local Page = UI.Create("ScrollingFrame", PagesArea, { Size = UDim2.new(1, -12, 1, -12), Position = UDim2.new(0, 6, 0, 6), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 3 })
        local PageLayout = UI.Create("UIListLayout", Page, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 12)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            if WindowObj.CurrentTab == Page then return end
            for _, t in ipairs(WindowObj.Tabs) do t.Page.Visible = false; t.Btn.BackgroundTransparency = 0.7; t.Btn.TextColor3 = SelectedTheme.SubText end
            WindowObj.CurrentTab = Page
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = SelectedTheme.Text
        end)

        if #WindowObj.Tabs == 0 then
            WindowObj.CurrentTab = Page
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = SelectedTheme.Text
        end

        table.insert(WindowObj.Tabs, {Btn = TabBtn, Page = Page})

        local TabElements = {}
        function TabElements:CreateLabel(c) return Elements.Label(Page, SelectedTheme, c) end
        function TabElements:CreateParagraph(c) return Elements.Paragraph(Page, SelectedTheme, c) end
        function TabElements:CreateDivider() return Elements.Divider(Page, SelectedTheme) end
        function TabElements:CreateSection(t) return Elements.Section(Page, SelectedTheme, t) end
        function TabElements:CreateButton(c) return Elements.Button(Page, SelectedTheme, c) end
        function TabElements:CreateToggle(c) return Elements.Toggle(Page, SelectedTheme, SavedData, c) end
        function TabElements:CreateSlider(c) return Elements.Slider(Page, SelectedTheme, SavedData, c) end
        function TabElements:CreateDropdown(c) return Elements.Dropdown(Page, SelectedTheme, SavedData, c) end
        function TabElements:CreateTextbox(c) return Elements.Textbox(Page, SelectedTheme, SavedData, c) end
        function TabElements:CreateKeybind(c) return Elements.Keybind(Page, SelectedTheme, SavedData, c) end

        return TabElements
    end

    return WindowObj
end

return AuraPro
