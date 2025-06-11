-- Cheem Hub - Grow a Garden Script
-- Không key, có UI, tự động trồng - tưới - thu hoạch - bán

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Cheem Hub - Grow A Garden", HidePremium = false, SaveConfig = false, IntroText = "Cheem Hub Loading..."})

local player = game.Players.LocalPlayer
local root = player.Character:WaitForChild("HumanoidRootPart")
local rs = game:GetService("ReplicatedStorage")
local plantRemote = rs:WaitForChild("PlantSeed")
local waterRemote = rs:WaitForChild("WaterPlant")
local harvestRemote = rs:WaitForChild("HarvestPlant")
local sellRemote = rs:WaitForChild("SellFruit")

getgenv().AutoFarm = false

function autofarm()
    while getgenv().AutoFarm do
        -- Tìm ô đất
        for _,plot in pairs(workspace.Plots:GetChildren()) do
            if plot.Owner.Value == player then
                -- Plant
                plantRemote:FireServer(plot)
                wait(0.5)
                -- Water
                waterRemote:FireServer(plot)
                wait(0.5)
                -- Harvest
                harvestRemote:FireServer(plot)
                wait(0.5)
                -- Sell
                sellRemote:FireServer()
                wait(0.5)
            end
        end
        wait(1)
    end
end

function AntiAFK()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

function ESP_Cay()
    for _,v in pairs(workspace.Plants:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Fruit") then
            local esp = Instance.new("BillboardGui", v)
            esp.Size = UDim2.new(0,100,0,20)
            esp.Adornee = v
            esp.AlwaysOnTop = true
            local txt = Instance.new("TextLabel", esp)
            txt.Size = UDim2.new(1,0,1,0)
            txt.Text = "🌱 "..v.Fruit.Value
            txt.TextColor3 = Color3.new(0,1,0)
            txt.BackgroundTransparency = 1
        end
    end
end

function TromCay()
    for _,plot in pairs(workspace.Plots:GetChildren()) do
        if plot.Owner.Value ~= player then
            harvestRemote:FireServer(plot)
            wait(0.3)
        end
    end
end

-- Tabs & Toggles
local tab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})

tab:AddToggle({
    Name = "🌾 Auto Farm (trồng/tưới/thu/bán)",
    Default = false,
    Callback = function(v)
        getgenv().AutoFarm = v
        if v then autofarm() end
    end
})

tab:AddButton({
    Name = "🧲 ESP Cây Hiếm",
    Callback = function()
        ESP_Cay()
        OrionLib:MakeNotification({Name="Đã Bật ESP", Content="Hiện vị trí cây có trái", Time=4})
    end
})

tab:AddButton({
    Name = "🕵️‍♂️ Trộm Cây Người Khác",
    Callback = function()
        TromCay()
        OrionLib:MakeNotification({Name="Đã Trộm", Content="Đã cố gắng trộm cây xung quanh", Time=3})
    end
})

tab:AddButton({
    Name = "🛡️ Anti-AFK",
    Callback = function()
        AntiAFK()
        OrionLib:MakeNotification({Name="Anti-AFK Bật", Content="Sẽ không bị kick khi treo", Time=3})
    end
})

-- UI Settings
local tab2 = Window:MakeTab({Name = "UI & Info", Icon = "rbxassetid://6031075938", PremiumOnly = false})

tab2:AddButton({
    Name = "❌ Thoát UI",
    Callback = function()
        OrionLib:Destroy()
    end
})