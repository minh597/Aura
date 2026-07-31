local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Elements = {}

function Elements.Init(Core, AuraPro)
    local UI = Core.UI

    function Elements.Label(Parent, Theme, Config)
        local Label = UI.Create("TextLabel", Parent, {
            Size = UDim2.new(0.98, 0, 0, 24),
            BackgroundTransparency = 1,
            Text = Config.Name or "Label",
            TextColor3 = Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left
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
        Core:SetFlag(SavedData, Flag, Toggled, AuraPro.ConfigName)

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
            Core:SetFlag(SavedData, Flag, Toggled, AuraPro.ConfigName)
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
        Core:SetFlag(SavedData, Flag, Value, AuraPro.ConfigName)

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
            Core:SetFlag(SavedData, Flag, Value, AuraPro.ConfigName)
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
        Core:SetFlag(SavedData, Flag, Selected, AuraPro.ConfigName)

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
                    Core:SetFlag(SavedData, Flag, Selected, AuraPro.ConfigName)
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
        Core:SetFlag(SavedData, Flag, TextVal, AuraPro.ConfigName)

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
            Core:SetFlag(SavedData, Flag, TextVal, AuraPro.ConfigName)
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
        Core:SetFlag(SavedData, Flag, typeof(DefaultKey) == "EnumItem" and DefaultKey.Name or tostring(DefaultKey), AuraPro.ConfigName)

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

        Core:TrackConnection(UserInputService.InputBegan:Connect(function(Input, Proc)
            if Listening and not Proc and Input.UserInputType == Enum.UserInputType.Keyboard then
                Listening = false
                CurrentKey = Input.KeyCode
                KeyBtn.Text = CurrentKey.Name
                Core:SetFlag(SavedData, Flag, CurrentKey.Name, AuraPro.ConfigName)
                pcall(Config.Callback or function() end, CurrentKey)
            end
        end))

        local Obj = {}
        function Obj:GetValue() return CurrentKey end
        return Obj
    end

    return Elements
end

return Elements
