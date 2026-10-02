-- ─────────────────────────────────────────────────────────────
-- Synapse Hub | Dead Ball Edition (Fixed & Optimized Execution)
-- ─────────────────────────────────────────────────────────────

local Success, SynapseUI = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Success or not SynapseUI then
    warn("Synapse Hub: Failed to load UI Library!")
    return
end

local Window = SynapseUI:CreateWindow({
   Name = "Synapse Hub - Dead Ball",
   LoadingTitle = "Synapse Hub Interface Suite",
   LoadingSubtitle = "By Synapse Hub",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SynapseHub",
      FileName = "DeadBallConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "jZ2MUtSch2",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Synapse Hub | Key System",
      Subtitle = "Free Permanent Key Access",
      Note = "Free Key: Synapse-Hub-Free (Join Discord: https://discord.gg/jZ2MUtSch2)",
      FileName = "SynapsePermanentKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Synapse-Hub-Free", "Matrix-Hub-Free"}
   }
})

-- Tabs Setup
local HomeTab = Window:CreateTab("Home", "home")
local AutoTab = Window:CreateTab("Auto Play", "zap")
local ESPTab = Window:CreateTab("ESP & Visuals", "eye")
local PlayerTab = Window:CreateTab("Player", "user")
local DiscordTab = Window:CreateTab("Join Discord", "message-square")
local SettingsTab = Window:CreateTab("Settings", "settings")

-- ─────────────────────────────────────────────────────────────
-- 1. Home Tab (Info Features)
-- ─────────────────────────────────────────────────────────────
local LocalPlayer = game.Players.LocalPlayer
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

HomeTab:CreateParagraph({Title = "Username", Content = LocalPlayer.Name})
HomeTab:CreateParagraph({Title = "Account Tier", Content = "Free User (Permanent Access)"})
HomeTab:CreateParagraph({Title = "Game Status", Content = "Synapse Hub Bypass Active"})
HomeTab:CreateParagraph({Title = "Server Job ID", Content = tostring(game.JobId)})
HomeTab:CreateParagraph({Title = "Executor", Content = identifyexecutor and identifyexecutor() or "Unknown"})
HomeTab:CreateParagraph({Title = "Place ID", Content = tostring(game.PlaceId)})

local PingParagraph = HomeTab:CreateParagraph({Title = "Current Ping", Content = "Calculating..."})
local FPSParagraph = HomeTab:CreateParagraph({Title = "Current FPS", Content = "Calculating..."})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            PingParagraph:Set({Title = "Current Ping", Content = ping .. " ms"})
            
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            FPSParagraph:Set({Title = "Current FPS", Content = fps .. " FPS"})
        end)
    end
end)

-- ─────────────────────────────────────────────────────────────
-- 2. Auto Play Tab (Unlimited Fast Swings & Smart Proximity)
-- ─────────────────────────────────────────────────────────────
local AutoDetectEnabled = false
local AutoShootEnabled = false
local HitRangeDistance = 15
local AlreadyHit = false

AutoTab:CreateToggle({
   Name = "Auto Detect Incoming Ball",
   CurrentValue = false,
   Flag = "AutoDetectBall",
   Callback = function(Value)
      AutoDetectEnabled = Value
   end,
})

AutoTab:CreateToggle({
   Name = "Unlimited Fast Swings (Auto Defense)",
   CurrentValue = false,
   Flag = "AutoShoot",
   Callback = function(Value)
      AutoShootEnabled = Value
      AlreadyHit = false
   end,
})

AutoTab:CreateSlider({
   Name = "Hit Distance Range (Studs)",
   Range = {5, 30},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 15,
   Flag = "HitRange",
   Callback = function(Value)
      HitRangeDistance = Value
   end,
})

task.spawn(function()
    while task.wait(0.01) do
        pcall(function()
            if (AutoDetectEnabled or AutoShootEnabled) and LocalPlayer.Character then
                local char = LocalPlayer.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    local ballFound = false
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("football") or obj.Name:lower():find("volleyball") or obj.Name:lower():find("sphere")) then
                            local dist = (hrp.Position - obj.Position).Magnitude
                            
                            if dist <= HitRangeDistance then
                                ballFound = true
                                if AutoShootEnabled and not AlreadyHit then
                                    AlreadyHit = true
                                    
                                    task.spawn(function()
                                        for i = 1, 5 do
                                            local tool = char:FindFirstChildOfClass("Tool")
                                            if tool then
                                                tool:Activate()
                                            end
                                            local vim = game:GetService("VirtualInputManager")
                                            if vim then
                                                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                                task.wait(0.02)
                                                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                            end
                                            task.wait(0.05)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                    
                    if not ballFound then
                        AlreadyHit = false
                    end
                end
            end
        end)
    end
end)

-- ─────────────────────────────────────────────────────────────
-- 3. ESP & Visuals Tab
-- ─────────────────────────────────────────────────────────────
local PlayerESPOn = false
local SkillESPOn = false

ESPTab:CreateToggle({
   Name = "Player ESP (Name & Distance)",
   CurrentValue = false,
   Flag = "PlayerESP",
   Callback = function(Value)
      PlayerESPOn = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Player Skill ESP",
   CurrentValue = false,
   Flag = "PlayerSkillESP",
   Callback = function(Value)
      SkillESPOn = Value
   end,
})

task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local head = char:FindFirstChild("Head") or char:FindFirstChildPrimaryPart()
                    if PlayerESPOn and head then
                        if not head:FindFirstChild("Synapse_ESP") then
                            local bg = Instance.new("BillboardGui")
                            bg.Name = "Synapse_ESP"
                            bg.Size = UDim2.new(0, 120, 0, 60)
                            bg.AlwaysOnTop = true
                            bg.StudsOffset = Vector3.new(0, 3, 0)
                            
                            local txt = Instance.new("TextLabel", bg)
                            txt.Name = "ESPText"
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.TextColor3 = Color3.fromRGB(0, 255, 100)
                            txt.TextScaled = true
                            txt.Font = Enum.Font.SourceSansBold
                            bg.Parent = head
                        end
                        
                        local bg = head:FindFirstChild("Synapse_ESP")
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if bg and hrp and myHrp then
                            local dist = math.floor((myHrp.Position - hrp.Position).Magnitude)
                            local skillStatus = SkillESPOn and "\n[Skill Ready]" or ""
                            bg.ESPText.Text = player.Name .. "\n[" .. dist .. " studs]" .. skillStatus
                        end
                    else
                        if head and head:FindFirstChild("Synapse_ESP") then
                            head.Synapse_ESP:Destroy()
                        end
                    end
                end
            end
        end)
    end
end)

-- ─────────────────────────────────────────────────────────────
-- 4. Player Tab
-- ─────────────────────────────────────────────────────────────
local WalkSpeedEnabled = false
local CustomWalkSpeed = 16

PlayerTab:CreateSlider({
   Name = "WalkSpeed Booster",
   Range = {16, 250},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      CustomWalkSpeed = Value
      WalkSpeedEnabled = (Value > 16)
   end,
})

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if WalkSpeedEnabled then
                local char = LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.WalkSpeed ~= CustomWalkSpeed then
                    humanoid.WalkSpeed = CustomWalkSpeed
                end
            end
        end)
    end
end)

PlayerTab:CreateToggle({
   Name = "Anti-AFK Kick Bypass",
   CurrentValue = true,
   Flag = "AntiAFK",
   Callback = function(Value)
      if Value then
          local vu = game:GetService("VirtualUser")
          LocalPlayer.Idled:Connect(function()
              vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
              task.wait(1)
              vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
          end)
      end
   end,
})

-- ─────────────────────────────────────────────────────────────
-- 5. Join Discord Tab
-- ─────────────────────────────────────────────────────────────
DiscordTab:CreateParagraph({Title = "Official Server", Content = "Click the button below to copy link: https://discord.gg/jZ2MUtSch2"})

DiscordTab:CreateButton({
   Name = "Join / Copy Discord Invite Link",
   Callback = function()
      if setclipboard then
          setclipboard("https://discord.gg/jZ2MUtSch2")
      end
      SynapseUI:Notify({
         Title = "Discord Link Copied!",
         Content = "Link copied successfully! Paste it in your browser.",
         Duration = 5,
         Image = 4483362458,
      })
   end,
})

-- ─────────────────────────────────────────────────────────────
-- 6. Settings Tab
-- ─────────────────────────────────────────────────────────────
SettingsTab:CreateButton({
   Name = "Unload Hub",
   Callback = function()
      SynapseUI:Destroy()
   end,
})

SynapseUI:LoadConfiguration()

-- ─────────────────────────────────────────────────────────────
-- 7. Clean UI Text Replacer
-- ─────────────────────────────────────────────────────────────
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local coreGui = gethui and gethui() or game:GetService("CoreGui")
            if coreGui then
                for _, gui in ipairs(coreGui:GetDescendants()) do
                    if (gui:IsA("TextLabel") or gui:IsA("TextButton")) and gui.Text then
                        if (gui.Text:find("Rayfield") or gui.Text:find("Matrix Hub")) and not gui.Text:find("Synapse Hub") then
                            gui.Text = gui.Text:gsub("Rayfield", "Synapse Hub"):gsub("Matrix Hub", "Synapse Hub")
                        elseif gui.Text:find("Configurations") then
                            gui.Text = "Synapse Hub"
                        end
                    end
                end
            end
        end)
    end
end)
