local KeySystem = {}--666

function KeySystem.Init(Core, AuraPro)
    local UI = Core.UI
    local TweenService = game:GetService("TweenService")
    local CachedParent = (gethui and gethui()) or Core.CachedParent

    local FallbackTheme = {
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

    function KeySystem:Create(Config)
        Config = Config or {}
        local TitleText = Config.Name or "Aura UI - Key System"
        local CorrectKey = Config.Key or "Aura2026"
        local LinkToGet = Config.Link or ""
        
        local SelectedTheme = (Config.Theme and type(Config.Theme) == "table") and Config.Theme or ((AuraPro.Themes and AuraPro.Themes.Dark) or FallbackTheme)
        
        local BackgroundColor = SelectedTheme.Background or FallbackTheme.Background
        local BorderColor = SelectedTheme.Border or FallbackTheme.Border
        local CardColor = SelectedTheme.Card or FallbackTheme.Card
        local TextColor = SelectedTheme.Text or FallbackTheme.Text
        local ElementColor = SelectedTheme.Element or FallbackTheme.Element
        local SubTextColor = SelectedTheme.SubText or FallbackTheme.SubText
        local AccentColor = SelectedTheme.Accent or FallbackTheme.Accent
        local SuccessColor = SelectedTheme.Success or FallbackTheme.Success
        local DangerColor = SelectedTheme.Danger or FallbackTheme.Danger

        local UserScale = (Config.Scale or 1.0) * 1.1
        local SuccessCallback = Config.Callback or function() end
        local KeySaveFile = Config.KeySave or "AuraKey_Save.json"

        local KeyData = Core:LoadConfig(KeySaveFile)
        if KeyData and KeyData.SavedKey == CorrectKey then
            pcall(SuccessCallback)
            return
        end

        local KeyGui = UI.Create("ScreenGui", CachedParent, { Name = "Aura_KeySystem_UI", ResetOnSpawn = false })
        local MainFrame = UI.Create("Frame", KeyGui, {
            Size = UDim2.new(0, 380, 0, 220), Position = UDim2.new(0.5, -190, 0.5, -130),
            BackgroundTransparency = 1, BackgroundColor3 = BackgroundColor
        })
        UI.Corner(MainFrame, 10)
        UI.Stroke(MainFrame, BorderColor)
        local UIScale = UI.Create("UIScale", MainFrame, { Scale = 0 })

        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = UserScale}):Play()

        local TopBar = UI.Create("Frame", MainFrame, { Size = UDim2.new(1, -16, 0, 36), Position = UDim2.new(0, 8, 0, 8), BackgroundColor3 = CardColor })
        UI.Corner(TopBar, 6)
        Core.MakeDraggable(MainFrame, TopBar)

        UI.Create("TextLabel", TopBar, {
            Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1,
            Text = TitleText, TextColor3 = TextColor, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
        })

        local KeyBox = UI.Create("TextBox", MainFrame, {
            Size = UDim2.new(1, -24, 0, 38), Position = UDim2.new(0, 12, 0, 58), BackgroundColor3 = ElementColor,
            PlaceholderText = "Enter key here...", PlaceholderColor3 = SubTextColor, Text = "", TextColor3 = TextColor, TextSize = 12, Font = Enum.Font.Gotham
        })
        UI.Corner(KeyBox, 6)

        local SubmitBtn = UI.Create("TextButton", MainFrame, {
            Size = UDim2.new(1, -24, 0, 36), Position = UDim2.new(0, 12, 0, 106), BackgroundColor3 = AccentColor,
            Text = "SUBMIT KEY", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBold
        })
        UI.Corner(SubmitBtn, 6)

        local GetKeyBtn = UI.Create("TextButton", MainFrame, {
            Size = UDim2.new(1, -24, 0, 32), Position = UDim2.new(0, 12, 0, 150), BackgroundColor3 = ElementColor,
            Text = "GET KEY", TextColor3 = SubTextColor, TextSize = 11, Font = Enum.Font.GothamMedium
        })
        UI.Corner(GetKeyBtn, 6)

        SubmitBtn.MouseButton1Click:Connect(function()
            if KeyBox.Text == CorrectKey then
                SubmitBtn.Text = "SUCCESS!"
                SubmitBtn.BackgroundColor3 = SuccessColor
                Core:SaveConfig(KeySaveFile, {SavedKey = CorrectKey})
                TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
                local CloseAnim = TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
                CloseAnim:Play()
                CloseAnim.Completed:Connect(function() KeyGui:Destroy(); pcall(SuccessCallback) end)
            else
                SubmitBtn.Text = "INVALID KEY!"
                SubmitBtn.BackgroundColor3 = DangerColor
                task.wait(1)
                SubmitBtn.Text = "SUBMIT KEY"
                SubmitBtn.BackgroundColor3 = AccentColor
            end
        end)

        GetKeyBtn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(LinkToGet) end
            GetKeyBtn.Text = "COPIED LINK TO CLIPBOARD!"
            task.wait(2)
            GetKeyBtn.Text = "GET KEY"
        end)
    end

    return KeySystem
end

return KeySystem
