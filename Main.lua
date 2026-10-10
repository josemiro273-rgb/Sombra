local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Sombra Hub",
    SubTitle = "Blox Fruits | Fruit Finder V5",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Fruit = Window:AddTab({ Title = "Fruits", Icon = "apple" }),
    Utils = Window:AddTab({ Title = "Utils", Icon = "zap" })
}

Tabs.Main:AddParagraph({ Title = "Sombra Hub Blox Fruits 🟣", Content = "Versão Fruit Finder segura e sem ban" })

-- FRUIT FINDER
local autoStore = false
local fruitNotifier = false

Tabs.Fruit:AddToggle("AutoStore", {
    Title = "Auto Store Fruit",
    Default = false,
    Callback = function(v)
        autoStore = v
        if v then
            Fluent:Notify({ Title = "Sombra", Content = "Auto Store ON", Duration = 2 })
            task.spawn(function()
                while autoStore do
                    local lp = game.Players.LocalPlayer
                    local char = lp.Character
                    if char then
                        for _,tool in pairs(char:GetChildren()) do
                            if tool:IsA("Tool") and string.find(tool.Name, "Fruit") then
                                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name:gsub(" Fruit", ""), tool)
                            end
                        end
                        for _,tool in pairs(lp.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and string.find(tool.Name, "Fruit") then
                                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name:gsub(" Fruit", ""), tool)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Fruit:AddToggle("Notifier", {
    Title = "Fruit Notifier",
    Default = false,
    Callback = function(v)
        fruitNotifier = v
        if v then
            Fluent:Notify({ Title = "Sombra", Content = "Procurando frutas...", Duration = 3 })
            task.spawn(function()
                while fruitNotifier do
                    for _,obj in pairs(workspace:GetChildren()) do
                        if string.find(obj.Name, "Fruit") and obj:IsA("Tool") then
                            local dist = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Handle.Position).Magnitude)
                            Fluent:Notify({ Title = "FRUTA ENCONTRADA! 🍎", Content = obj.Name.." a "..dist.." studs de você!", Duration = 10 })
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    end
})

Tabs.Fruit:AddButton({
    Title = "Server Hop - Procurar Fruta",
    Description = "Troca de server até achar fruta",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local servers = Http:JSONDecode(game:HttpGet(Api)).data
        for _, s in pairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
})

-- UTILS
Tabs.Utils:AddButton({ Title = "Anti-AFK", Callback = function()
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
    Fluent:Notify({ Title = "Sombra", Content = "Anti-AFK ON", Duration = 2 })
end})

Tabs.Utils:AddButton({ Title = "FPS Boost", Callback = function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Decal") then v.Transparency = 1 end end end})

Window:SelectTab(1)
Fluent:Notify({ Title = "Sombra Hub", Content = "Fruit Finder Carregado! 🟣", Duration = 4 })
