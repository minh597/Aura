local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local CachedParent = (gethui and gethui()) or (CoreGui:FindFirstChild("RobloxGui") and CoreGui) or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui")) or CoreGui

if CachedParent:FindFirstChild("Aura_Pro_UI") then
    CachedParent.Aura_Pro_UI:Destroy()
end

if CachedParent:FindFirstChild("Aura_KeySystem_UI") then
    CachedParent.Aura_KeySystem_UI:Destroy()
end

if CachedParent:FindFirstChild("Aura_Minified_Icon") then
    CachedParent.Aura_Minified_Icon:Destroy()
end

local AuraPro = {
    ConfigName = nil,
    KeyConfigName = "AuraKey_Save.json"
}

AuraPro.Themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/Themes.lua"))()

local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/Core.lua"))()
Core.CachedParent = CachedParent

local Elements = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/Elements.lua"))().Init(Core, AuraPro)
local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/KeySystem.lua"))().Init(Core, AuraPro)
local Window = loadstring(game:HttpGet("https://raw.githubusercontent.com/minh597/Aura/refs/heads/main/Window.lua"))().Init(Core, AuraPro, Elements)

function AuraPro:CreateKeySystem(Config)
    return KeySystem:Create(Config)
end

function AuraPro:CreateWindow(Config)
    return Window:CreateWindow(Config)
end

return AuraPro
