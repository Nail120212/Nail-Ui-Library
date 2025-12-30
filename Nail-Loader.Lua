local NailUI = {}
NailUI.__index = NailUI

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local Theme = {
    Accent   = Color3.fromRGB(80, 180, 255),
    Bg       = Color3.fromRGB(14, 14, 20),
    Darker   = Color3.fromRGB(9, 9, 14),
    Text     = Color3.fromRGB(230, 230, 245),
    Stroke   = Color3.fromRGB(40, 40, 55),
    Corner   = UDim.new(0, 8),
    Padding  = UDim.new(0, 12)
}

function NailUI.new(name)
    local self = setmetatable({}, NailUI)
    
    self.Screen = Instance.new("ScreenGui")
    self.Screen.Name = name or "NailUI"
    self.Screen.ResetOnSpawn = false
    self.Screen.Parent = pg
    
    self.Window = Instance.new("Frame")
    self.Window.Size = UDim2.new(0, 380, 0, 480)
    self.Window.Position = UDim2.new(0.5, -190, 0.5, -240)
    self.Window.BackgroundColor3 = Theme.Bg
    self.Window.Parent = self.Screen
    
    local corner = Instance.new("UICorner", self.Window); corner.CornerRadius = Theme.Corner
    local stroke = Instance.new("UIStroke", self.Window); stroke.Color = Theme.Stroke; stroke.Thickness = 1.5
    
    local titleBar = Instance.new("Frame", self.Window)
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundColor3 = Theme.Darker
    
    local titleLbl = Instance.new("TextLabel", titleBar)
    titleLbl.Size = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = name or "Nail UI"
    titleLbl.TextColor3 = Theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local sidebar = Instance.new("ScrollingFrame", self.Window)
    sidebar.Size = UDim2.new(0, 120, 1, -36 - 90)
    sidebar.Position = UDim2.new(0, 0, 0, 36)
    sidebar.BackgroundTransparency = 1
    sidebar.ScrollBarThickness = 3
    sidebar.ScrollBarImageColor3 = Theme.Stroke
    
    local content = Instance.new("ScrollingFrame", self.Window)
    content.Size = UDim2.new(1, -130, 1, -36 - 90)
    content.Position = UDim2.new(0, 130, 0, 36)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Theme.Stroke
    
    local uiList = Instance.new("UIListLayout", content)
    uiList.Padding = UDim.new(0, 14)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.FillDirection = Enum.FillDirection.Vertical
    
    self.PlayerBox = Instance.new("Frame", self.Window)
    self.PlayerBox.Size = UDim2.new(1, 0, 0, 80)
    self.PlayerBox.Position = UDim2.new(0, 0, 1, -80)
    self.PlayerBox.BackgroundColor3 = Theme.Darker
    self.PlayerBox.Parent = self.Window
    
    local playerCorner = Instance.new("UICorner", self.PlayerBox); playerCorner.CornerRadius = Theme.Corner
    
    local avatar = Instance.new("ImageLabel", self.PlayerBox)
    avatar.Size = UDim2.new(0, 56, 0, 56)
    avatar.Position = UDim2.new(0, 12, 0.5, -28)
    avatar.BackgroundTransparency = 1
    avatar.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    
    local displayName = Instance.new("TextLabel", self.PlayerBox)
    displayName.Size = UDim2.new(1, -80, 0, 20)
    displayName.Position = UDim2.new(0, 78, 0.5, -30)
    displayName.BackgroundTransparency = 1
    displayName.Text = lp.DisplayName
    displayName.TextColor3 = Theme.Text
    displayName.Font = Enum.Font.GothamBold
    displayName.TextSize = 14
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    
    local username = Instance.new("TextLabel", self.PlayerBox)
    username.Size = UDim2.new(1, -80, 0, 18)
    username.Position = UDim2.new(0, 78, 0.5, 0)
    username.BackgroundTransparency = 1
    username.Text = "@" .. lp.Name
    username.TextColor3 = Color3.fromRGB(160, 160, 180)
    username.Font = Enum.Font.Gotham
    username.TextSize = 13
    username.TextXAlignment = Enum.TextXAlignment.Left
    
    local hideBtn = Instance.new("TextButton", self.PlayerBox)
    hideBtn.Size = UDim2.new(0, 18, 0, 18)
    hideBtn.Position = UDim2.new(1, -30, 0.5, -9)
    hideBtn.BackgroundColor3 = Theme.Stroke
    hideBtn.Text = "X"
    hideBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextSize = 12
    
    local hideLabel = Instance.new("TextLabel", self.PlayerBox)
    hideLabel.Size = UDim2.new(0, 80, 0, 18)
    hideLabel.Position = UDim2.new(1, -120, 0.5, -9)
    hideLabel.BackgroundTransparency = 1
    hideLabel.Text = "Hide"
    hideLabel.TextColor3 = Theme.Text
    hideLabel.Font = Enum.Font.Gotham
    hideLabel.TextSize = 13
    hideLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    hideBtn.MouseButton1Click:Connect(function()
        self.PlayerBox.Visible = not self.PlayerBox.Visible
    end)
    
    self.Sidebar = sidebar
    self.Content = content
    self.Tabs = {}
    self.CurrentTabContent = nil
    
    function self:Tab(name)
        local tab = {}
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -12, 0, 42)
        btn.BackgroundColor3 = Theme.Darker
        btn.Text = name
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.Parent = sidebar
        
        local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0, 6)
        
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = content
        
        local list = Instance.new("UIListLayout", tabContent)
        list.Padding = UDim.new(0, 14)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.FillDirection = Enum.FillDirection.Vertical
        
        btn.MouseButton1Click:Connect(function()
            for _, t in self.Tabs do
                TS:Create(t.Button, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Darker}):Play()
                t.Content.Visible = false
            end
            TS:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
            tabContent.Visible = true
        end)
        
        local tabData = {Button = btn, Content = tabContent, Name = name}
        table.insert(self.Tabs, tabData)
        tab.Button = btn
        tab.Content = tabContent
        
        -- Auto-select first tab
        if #self.Tabs == 1 then
            btn.BackgroundColor3 = Theme.Accent
            tabContent.Visible = true
        end
        
        return tab
    end
    
    return self
end

return NailUI
