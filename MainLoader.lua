if not _G["Wonder840184729"] then 
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Wonder Hub Key System.")
    end
    return 
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Magic Evolution +",
    SubTitle = "WONDER",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "White",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
    Training = Window:AddTab({ Title = "Training", Icon = "target" }),
    AutoClick = Window:AddTab({ Title = "Auto Click", Icon = "mouse-pointer" }),
    Eggs = Window:AddTab({ Title = "Eggs", Icon = "package" })
}

local isClaimingPriority = false

local safeFloatEnabled = false
local SafeFloatToggle = Tabs.Combat:AddToggle("SafeFloatToggle", {
    Title = "Safe Float (Dungeon)",
    Default = false
})

SafeFloatToggle:OnChanged(function()
    safeFloatEnabled = SafeFloatToggle.Value
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")

    if hrp then
        if safeFloatEnabled then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 15, 0)
            hrp.Anchored = true
        else
            hrp.Anchored = false
        end
    end
end)

local dungeonKillAuraEnabled = false
local DungeonKillAuraToggle = Tabs.Combat:AddToggle("DungeonKillAuraToggle", {
    Title = "Dungeon Kill Aura",
    Default = false
})

DungeonKillAuraToggle:OnChanged(function()
    dungeonKillAuraEnabled = DungeonKillAuraToggle.Value
    if dungeonKillAuraEnabled then
        task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local DealMobDamage = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DealMobDamage")
            
            while dungeonKillAuraEnabled do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local magicPower = math.max(1, (math.floor(tonumber(player:GetAttribute("MagicPower")) or 1)))
                    local dungeonMobs = workspace:FindFirstChild("DungeonMobs")
                    
                    if dungeonMobs then
                        for _, mob in ipairs(dungeonMobs:GetChildren()) do
                            if mob:IsA("Model") then
                                local humanoid = mob:FindFirstChildOfClass("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    DealMobDamage:FireServer(mob, magicPower)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

local autoWandEnabled = false
local AutoWandToggle = Tabs.Training:AddToggle("AutoWandToggle", {
    Title = "Auto Get 5B Wand",
    Default = false
})

AutoWandToggle:OnChanged(function()
    autoWandEnabled = AutoWandToggle.Value
    local player = game:GetService("Players").LocalPlayer

    if autoWandEnabled then
        task.spawn(function()
            local hasClaimedWand = false 
            
            while autoWandEnabled do
                local winsValue = 0
                if player:FindFirstChild("leaderstats") then
                    local winsStat = player.leaderstats:FindFirstChild("Wins") or player.leaderstats:FindFirstChild("Trophies")
                    if winsStat then winsValue = tonumber(winsStat.Value) or 0 end
                end
                if winsValue == 0 then
                    winsValue = tonumber(player:GetAttribute("Wins")) or tonumber(player:GetAttribute("Trophies")) or 0
                end

                if winsValue >= 5000000000 and not hasClaimedWand then
                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    local staffButtons = workspace:FindFirstChild("StaffButtons")
                    
                    if hrp and staffButtons then
                        local staff19 = staffButtons:FindFirstChild("Staff Button19")
                        local target = staff19 and staff19:FindFirstChild("StaffModel")
                        if target then
                            isClaimingPriority = true
                            
                            local cframe = target:IsA("Model") and target:GetPivot() or target.CFrame
                            hrp.CFrame = cframe * CFrame.new(0, 1, 0) 
                            
                            task.wait(2)
                            
                            Fluent:Notify({
                                Title = "Wand Claimed!",
                                Content = "You reached 5B wins! Teleporting back to farm...",
                                Duration = 5
                            })
                            
                            isClaimingPriority = false
                            hasClaimedWand = true 
                        end
                    end
                elseif winsValue < 5000000000 then
                    hasClaimedWand = false
                end
                
                task.wait(1)
            end
        end)
    end
end)

local selectedPlatform = "TargetPractice2"

local TrainingDropdown = Tabs.Training:AddDropdown("TrainingDropdown", {
    Title = "Select Platform",
    Values = {
        "Platform 2 [1x Power | 0 Rebirths]",
        "Platform 3 [2x Power | 1 Rebirth]",
        "Platform 5 [5x Power | 3 Rebirths]",
        "Platform 6 [10x Power | 5 Rebirths]",
        "Platform 8 [50x Power | 15 Rebirths]",
        "Platform 10 [100x Power | 45 Rebirths]"
    },
    Multi = false,
    Default = 1,
})

TrainingDropdown:OnChanged(function(Value)
    if string.find(Value, "Platform 2") then selectedPlatform = "TargetPractice2"
    elseif string.find(Value, "Platform 3") then selectedPlatform = "TargetPractice3"
    elseif string.find(Value, "Platform 5") then selectedPlatform = "TargetPractice5"
    elseif string.find(Value, "Platform 6") then selectedPlatform = "TargetPractice6"
    elseif string.find(Value, "Platform 8") then selectedPlatform = "TargetPractice8"
    elseif string.find(Value, "Platform 10") then selectedPlatform = "TargetPractice10"
    end
end)

local autoTrainingEnabled = false
local AutoTrainingToggle = Tabs.Training:AddToggle("AutoTrainingToggle", {
    Title = "Auto Farm Platform",
    Default = false
})

AutoTrainingToggle:OnChanged(function()
    autoTrainingEnabled = AutoTrainingToggle.Value
    local player = game:GetService("Players").LocalPlayer

    if autoTrainingEnabled then
        task.spawn(function()
            while autoTrainingEnabled do
                if isClaimingPriority then
                    task.wait(1)
                    continue
                end

                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                local targetFolder = workspace:FindFirstChild("TargetPractices")
                
                if hrp and targetFolder and targetFolder:FindFirstChild(selectedPlatform) then
                    local targetObj = targetFolder[selectedPlatform]
                    local targetPart = targetObj:FindFirstChild("Platform") or targetObj:FindFirstChild("HitPart") or targetObj
                    local targetCFrame = targetPart:IsA("Model") and targetPart:GetPivot() or targetPart.CFrame
                    
                    hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
                    hrp.Anchored = true
                end
                task.wait(1)
            end
        end)
    else
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false end
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GainMagicPower = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GainMagicPower")
local autoClickEnabled = false

local AutoClickToggle = Tabs.AutoClick:AddToggle("AutoClickToggle", {
    Title = "Auto Click", 
    Default = false
})

AutoClickToggle:OnChanged(function()
    autoClickEnabled = AutoClickToggle.Value
    if autoClickEnabled then
        task.spawn(function()
            while autoClickEnabled do
                local lp = game:GetService("Players").LocalPlayer
                if lp:GetAttribute("ClientHatchingEgg") ~= true and (lp:GetAttribute("ActiveEggName") or "") == "" then
                    GainMagicPower:FireServer()
                end
                task.wait(0.1) 
            end
        end)
    end
end)

local autoWinEnabled = false
local AutoWinToggle = Tabs.AutoClick:AddToggle("AutoWinToggle", {
    Title = "Auto Farm Wins",
    Default = false
})

AutoWinToggle:OnChanged(function()
    autoWinEnabled = AutoWinToggle.Value
    if autoWinEnabled then
        task.spawn(function()
            while autoWinEnabled do
                if isClaimingPriority then
                    task.wait(1)
                    continue
                end

                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    local stagesFolder = workspace:FindFirstChild("Stages")
                    if stagesFolder then
                        local targetStage = stagesFolder:FindFirstChild("Stage25")
                        local target = targetStage and targetStage:FindFirstChild("WinButton")
                        if target then
                            local winCFrame = target:IsA("Model") and target:GetPivot() or target.CFrame
                            hrp.CFrame = winCFrame * CFrame.new(0, 5, 0)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

local autoRebirthEnabled = false
local AutoRebirthToggle = Tabs.AutoClick:AddToggle("AutoRebirthToggle", {
    Title = "Auto Rebirth",
    Default = false
})

AutoRebirthToggle:OnChanged(function()
    autoRebirthEnabled = AutoRebirthToggle.Value
    if autoRebirthEnabled then
        task.spawn(function()
            local RebirthRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Rebirth")
            while autoRebirthEnabled do
                pcall(function() RebirthRemote:FireServer() end)
                task.wait(1.5) 
            end
        end)
    end
end)

Tabs.Eggs:AddParagraph({
    Title = "Notice",
    Content = "This will only work if you are near the egg."
})

local selectedEgg = "Basic Egg"
local EggDropdown = Tabs.Eggs:AddDropdown("EggDropdown", {
    Title = "Select Egg",
    Values = {"Basic Egg", "Fire Egg", "Arcane Egg", "Astral Egg", "Demonic Egg"},
    Multi = false,
    Default = 1,
})

EggDropdown:OnChanged(function(Value) selectedEgg = Value end)

local autoHatchEnabled = false
local AutoHatchToggle = Tabs.Eggs:AddToggle("AutoHatchToggle", {
    Title = "Auto Hatch",
    Default = false
})

AutoHatchToggle:OnChanged(function()
    autoHatchEnabled = AutoHatchToggle.Value
    if autoHatchEnabled then
        task.spawn(function()
            local OpenEgg = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("OpenEgg")
            while autoHatchEnabled do
                pcall(function() OpenEgg:InvokeServer(selectedEgg) end)
                task.wait(0.2) 
            end
        end)
    end
end)

local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("MobileButtonUI") then CoreGui.MobileButtonUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileButtonUI"
ScreenGui.Parent = CoreGui

local MobileButton = Instance.new("TextButton")
MobileButton.Name = "Toggle"
MobileButton.Parent = ScreenGui
MobileButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MobileButton.Position = UDim2.new(0.5, -25, 0.1, 0)
MobileButton.Size = UDim2.new(0, 50, 0, 50)
MobileButton.Font = Enum.Font.GothamBold
MobileButton.Text = "W"
MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileButton.TextSize = 20
MobileButton.Active = true
MobileButton.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MobileButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(150, 150, 150)
UIStroke.Thickness = 1.5
UIStroke.Parent = MobileButton

local FluentUI
task.spawn(function()
    while not FluentUI do
        task.wait(0.5)
        for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, desc in pairs(gui:GetDescendants()) do
                    if desc:IsA("TextLabel") and string.find(desc.Text, "WONDER") then
                        FluentUI = gui
                        break
                    end
                end
            end
            if FluentUI then break end
        end
    end
end)

MobileButton.MouseButton1Click:Connect(function()
    if FluentUI then
        for _, child in pairs(FluentUI:GetChildren()) do
            if child:IsA("Frame") or child:IsA("CanvasGroup") then
                child.Visible = not child.Visible
            end
        end
    end
end)

Fluent:Notify({
    Title = "Script Loaded",
    Content = "Mobile UI loaded! Systems ready.",
    Duration = 5
})
