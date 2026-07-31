local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local Core = {
    ActiveConnections = {}
}

function Core:TrackConnection(Conn)
    table.insert(self.ActiveConnections, Conn)
    return Conn
end

function Core:SaveConfig(FileName, Data)
    if FileName and writefile then
        pcall(function() writefile(FileName, HttpService:JSONEncode(Data)) end)
    end
end

function Core:LoadConfig(FileName)
    if FileName and readfile and isfile and isfile(FileName) then
        local Success, Decoded = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if Success then return Decoded end
    end
    return {}
end

function Core:SetFlag(SavedData, Flag, Value, ConfigName)
    if ConfigName then
        SavedData[Flag] = Value
        self:SaveConfig(ConfigName, SavedData)
    end
end

-- UI Helper khởi tạo nhanh
local UI = {}

function UI.Create(Class, Parent, Properties)
    local Obj = Instance.new(Class)
    for Key, Value in pairs(Properties or {}) do
        Obj[Key] = Value
    end
    if Parent then Obj.Parent = Parent end
    return Obj
end

function UI.Corner(Obj, Radius)
    return UI.Create("UICorner", Obj, { CornerRadius = UDim.new(0, Radius or 6) })
end

function UI.Stroke(Obj, Color, Thickness)
    return UI.Create("UIStroke", Obj, { Color = Color, Thickness = Thickness or 1 })
end

Core.UI = UI

-- Global Drag Handler
local GlobalDragging = false
local GlobalDragInput, GlobalDragStart, GlobalStartPos, GlobalTargetFrame

Core:TrackConnection(UserInputService.InputBegan:Connect(function(Input)
    if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and GlobalTargetFrame then
        GlobalDragging = true
        GlobalDragStart = Input.Position
        GlobalStartPos = GlobalTargetFrame.Position
    end
end))

Core:TrackConnection(UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        GlobalDragging = false
    end
end))

Core:TrackConnection(UserInputService.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        GlobalDragInput = Input
    end
    if GlobalDragging and GlobalTargetFrame and GlobalDragInput == Input then
        local Delta = Input.Position - GlobalDragStart
        GlobalTargetFrame.Position = UDim2.new(GlobalStartPos.X.Scale, GlobalStartPos.X.Offset + Delta.X, GlobalStartPos.Y.Scale, GlobalStartPos.Y.Offset + Delta.Y)
    end
end))

function Core.MakeDraggable(Frame, Handle)
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

return Core
