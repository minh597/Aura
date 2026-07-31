local Window = {}

function Window.Init(Core, AuraPro, ElementsModule)
    local UI = Core.UI
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CachedParent = (gethui and gethui()) or Core.CachedParent

    function Window:CreateWindow(Config)
        Config = Config or {}
        local TitleText = Config.Name or "Aura UI Pro"
        local SelectedTheme = Config.Theme or AuraPro.Themes.Dark
        local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
        local BaseWidth = Config.Width or 640
        local BaseHeight = Config.Height or 440
        local UserScale = Config.Scale or 1.2
        local HubImage = Config.Image or ""

        AuraPro.ConfigName = Config.ConfigSave or nil
        local SavedData = Core:LoadConfig(AuraPro.ConfigName)

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
        Core.MakeDraggable(FloatBtn, FloatBtn)

        local TopBar = UI.Create("Frame", MainFrame, { Size = UDim2.new(1, -20, 0, 42), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = SelectedTheme.Card })
        UI.Corner(TopBar, 8)
        Core.MakeDraggable(MainFrame, TopBar)

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
            for _, Conn in ipairs(Core.ActiveConnections) do if Conn then Conn:Disconnect() end end
            table.clear(Core.ActiveConnections)
            ScreenGui:Destroy()
            MinifiedGui:Destroy()
        end

        CloseBtn.MouseButton1Click:Connect(function()
            local Anim = TweenService:Create(MainScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
            Anim:Play()
            Anim.Completed:Connect(function() WindowObj:Destroy() end)
        end)

        Core:TrackConnection(UserInputService.InputBegan:Connect(function(Input, Proc)
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
            function TabElements:CreateLabel(c) return ElementsModule.Label(Page, SelectedTheme, c) end
            function TabElements:CreateParagraph(c) return ElementsModule.Paragraph(Page, SelectedTheme, c) end
            function TabElements:CreateDivider() return ElementsModule.Divider(Page, SelectedTheme) end
            function TabElements:CreateSection(t) return ElementsModule.Section(Page, SelectedTheme, t) end
            function TabElements:CreateButton(c) return ElementsModule.Button(Page, SelectedTheme, c) end
            function TabElements:CreateToggle(c) return ElementsModule.Toggle(Page, SelectedTheme, SavedData, c) end
            function TabElements:CreateSlider(c) return ElementsModule.Slider(Page, SelectedTheme, SavedData, c) end
            function TabElements:CreateDropdown(c) return ElementsModule.Dropdown(Page, SelectedTheme, SavedData, c) end
            function TabElements:CreateTextbox(c) return ElementsModule.Textbox(Page, SelectedTheme, SavedData, c) end
            function TabElements:CreateKeybind(c) return ElementsModule.Keybind(Page, SelectedTheme, SavedData, c) end

            return TabElements
        end

        return WindowObj
    end

    return Window
end

return Window
