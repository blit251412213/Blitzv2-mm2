-- ╔══════════════════════════════════════════════════════════╗
-- ║  BLITZ V2  •  MM2 APEX  •  FINAL BUILD                 ║
-- ║  Executor : Synapse X / KRNL / Fluxus / Delta           ║
-- ║  INSERT (PC) or on-screen button (Mobile) : toggle GUI  ║
-- ╚══════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Camera           = workspace.CurrentCamera
local LP               = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════
-- CONFIG
-- ════════════════════════════════════════════════════════════
local Cfg = {
    ESP = {
        Enabled=false, Box=true, Tracer=true,
        NameTag=true, RoleTag=true, HealthBar=true,
        Distance=true, MaxDist=500, Thickness=1.5,
    },
    Aim = {
        Enabled=false, FOV=130, ShowFOV=true,
        Bone="Head", Prediction=true, PredictStr=12,
        RoleFilter=true, VisCheck=false,
        HitChance=100, LockOnKey=false,
    },
    AutoShoot  = { Enabled=false, Delay=0.35 },
    Movement   = {
        SpeedEnabled=false, Speed=32,
        JumpEnabled=false,  JumpPower=100,
        InfJump=false, NoClip=false,
        Fly=false, FlySpeed=40,
    },
    Coins      = { Enabled=false, Range=200 },
    GunESP     = { Enabled=false },
    GunTP      = { Enabled=false, Cooldown=1.5 },
    Alert      = { Enabled=false, Range=20 },
    KnifeTrack = { Enabled=false },
    AntiAFK    = { Enabled=false },
    Crosshair  = { Enabled=false, Size=10 },
    RoleAnnounce={ Enabled=true },
    MurderTP   = { Enabled=false, Cooldown=2 },
}

-- ════════════════════════════════════════════════════════════
-- SCREEN GUI ROOT
-- ════════════════════════════════════════════════════════════
local SG = Instance.new("ScreenGui")
SG.Name="BlitzApex"; SG.ResetOnSpawn=false
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset=true
pcall(function() SG.Parent=game:GetService("CoreGui") end)
if not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end

-- ════════════════════════════════════════════════════════════
-- LOADING SCREEN
-- ════════════════════════════════════════════════════════════
local LoadFrame=Instance.new("Frame")
LoadFrame.Size=UDim2.new(1,0,1,0)
LoadFrame.BackgroundColor3=Color3.fromRGB(8,8,12)
LoadFrame.BorderSizePixel=0; LoadFrame.ZIndex=100; LoadFrame.Parent=SG

local function MakeGrid()
    for row=0,20 do
        local l=Instance.new("Frame"); l.Size=UDim2.new(1,0,0,1)
        l.Position=UDim2.new(0,0,0,row*40)
        l.BackgroundColor3=Color3.fromRGB(20,20,30)
        l.BorderSizePixel=0; l.ZIndex=100; l.Parent=LoadFrame
    end
    for col=0,50 do
        local l=Instance.new("Frame"); l.Size=UDim2.new(0,1,1,0)
        l.Position=UDim2.new(0,col*40,0,0)
        l.BackgroundColor3=Color3.fromRGB(20,20,30)
        l.BorderSizePixel=0; l.ZIndex=100; l.Parent=LoadFrame
    end
end
MakeGrid()

local Logo=Instance.new("TextLabel")
Logo.Size=UDim2.new(0,400,0,60); Logo.Position=UDim2.new(0.5,-200,0.5,-110)
Logo.BackgroundTransparency=1; Logo.Text="BLITZ V2"
Logo.TextColor3=Color3.fromRGB(255,255,255); Logo.TextSize=54
Logo.Font=Enum.Font.GothamBlack; Logo.ZIndex=101; Logo.Parent=LoadFrame

local Sub=Instance.new("TextLabel")
Sub.Size=UDim2.new(0,400,0,24); Sub.Position=UDim2.new(0.5,-200,0.5,-46)
Sub.BackgroundTransparency=1; Sub.Text="MM2 APEX EDITION"
Sub.TextColor3=Color3.fromRGB(200,30,30); Sub.TextSize=16
Sub.Font=Enum.Font.GothamBold; Sub.ZIndex=101; Sub.Parent=LoadFrame

local LogoLine=Instance.new("Frame")
LogoLine.Size=UDim2.new(0,260,0,3); LogoLine.Position=UDim2.new(0.5,-130,0.5,-18)
LogoLine.BackgroundColor3=Color3.fromRGB(200,30,30); LogoLine.BorderSizePixel=0
LogoLine.ZIndex=101; LogoLine.Parent=LoadFrame
Instance.new("UICorner",LogoLine).CornerRadius=UDim.new(1,0)

local BarBG=Instance.new("Frame")
BarBG.Size=UDim2.new(0,320,0,6); BarBG.Position=UDim2.new(0.5,-160,0.5,42)
BarBG.BackgroundColor3=Color3.fromRGB(25,25,35); BarBG.BorderSizePixel=0
BarBG.ZIndex=101; BarBG.Parent=LoadFrame
Instance.new("UICorner",BarBG).CornerRadius=UDim.new(1,0)

local BarFill=Instance.new("Frame")
BarFill.Size=UDim2.new(0,0,1,0)
BarFill.BackgroundColor3=Color3.fromRGB(200,30,30)
BarFill.BorderSizePixel=0; BarFill.ZIndex=102; BarFill.Parent=BarBG
Instance.new("UICorner",BarFill).CornerRadius=UDim.new(1,0)

local LoadStatus=Instance.new("TextLabel")
LoadStatus.Size=UDim2.new(0,320,0,20); LoadStatus.Position=UDim2.new(0.5,-160,0.5,55)
LoadStatus.BackgroundTransparency=1; LoadStatus.Text="Initializing..."
LoadStatus.TextColor3=Color3.fromRGB(100,100,120); LoadStatus.TextSize=12
LoadStatus.Font=Enum.Font.Gotham; LoadStatus.ZIndex=101; LoadStatus.Parent=LoadFrame

local VerLbl=Instance.new("TextLabel")
VerLbl.Size=UDim2.new(0,200,0,16); VerLbl.Position=UDim2.new(1,-210,1,-24)
VerLbl.BackgroundTransparency=1; VerLbl.Text="v2.0 APEX  •  MM2"
VerLbl.TextColor3=Color3.fromRGB(50,50,65); VerLbl.TextSize=11
VerLbl.Font=Enum.Font.Gotham; VerLbl.TextXAlignment=Enum.TextXAlignment.Right
VerLbl.ZIndex=101; VerLbl.Parent=LoadFrame

local loadSteps={
    {t=0.12,txt="Loading modules..."},
    {t=0.28,txt="Hooking remotes..."},
    {t=0.48,txt="Building ESP pool..."},
    {t=0.65,txt="Compiling silent aim..."},
    {t=0.82,txt="Warming up auto shoot..."},
    {t=1.00,txt="Ready."},
}

-- ════════════════════════════════════════════════════════════
-- VERSION PICKER
-- ════════════════════════════════════════════════════════════
local PickerFrame=Instance.new("Frame")
PickerFrame.Size=UDim2.new(1,0,1,0)
PickerFrame.BackgroundColor3=Color3.fromRGB(8,8,12)
PickerFrame.BorderSizePixel=0; PickerFrame.ZIndex=99
PickerFrame.Visible=false; PickerFrame.Parent=SG

local PickTitle=Instance.new("TextLabel")
PickTitle.Size=UDim2.new(0,440,0,50); PickTitle.Position=UDim2.new(0.5,-220,0.5,-160)
PickTitle.BackgroundTransparency=1; PickTitle.Text="SELECT PLATFORM"
PickTitle.TextColor3=Color3.fromRGB(255,255,255); PickTitle.TextSize=30
PickTitle.Font=Enum.Font.GothamBlack; PickTitle.ZIndex=100; PickTitle.Parent=PickerFrame

local PickSub=Instance.new("TextLabel")
PickSub.Size=UDim2.new(0,400,0,22); PickSub.Position=UDim2.new(0.5,-200,0.5,-108)
PickSub.BackgroundTransparency=1; PickSub.Text="Choose how you play Murder Mystery 2"
PickSub.TextColor3=Color3.fromRGB(100,100,120); PickSub.TextSize=14
PickSub.Font=Enum.Font.Gotham; PickSub.ZIndex=100; PickSub.Parent=PickerFrame

local function MakePickBtn(label,sub,icon,xOff,cb)
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0,175,0,195); btn.Position=UDim2.new(0.5,xOff,0.5,-82)
    btn.BackgroundColor3=Color3.fromRGB(16,16,22); btn.BorderSizePixel=0
    btn.Text=""; btn.ZIndex=100; btn.Parent=PickerFrame
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
    local acc=Instance.new("Frame"); acc.Size=UDim2.new(1,0,0,3)
    acc.BackgroundColor3=Color3.fromRGB(200,30,30); acc.BorderSizePixel=0
    acc.ZIndex=101; acc.Parent=btn
    Instance.new("UICorner",acc).CornerRadius=UDim.new(0,10)
    local ico=Instance.new("TextLabel"); ico.Size=UDim2.new(1,0,0,72)
    ico.Position=UDim2.new(0,0,0,18); ico.BackgroundTransparency=1
    ico.Text=icon; ico.TextSize=54; ico.ZIndex=101; ico.Parent=btn
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,0,28)
    lbl.Position=UDim2.new(0,0,0,96); lbl.BackgroundTransparency=1
    lbl.Text=label; lbl.TextColor3=Color3.fromRGB(255,255,255); lbl.TextSize=18
    lbl.Font=Enum.Font.GothamBold; lbl.ZIndex=101; lbl.Parent=btn
    local slbl=Instance.new("TextLabel"); slbl.Size=UDim2.new(1,-16,0,44)
    slbl.Position=UDim2.new(0,8,0,126); slbl.BackgroundTransparency=1
    slbl.Text=sub; slbl.TextColor3=Color3.fromRGB(100,100,120); slbl.TextSize=11
    slbl.Font=Enum.Font.Gotham; slbl.TextWrapped=true; slbl.ZIndex=101; slbl.Parent=btn
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.15),
            {BackgroundColor3=Color3.fromRGB(22,22,32)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.15),
            {BackgroundColor3=Color3.fromRGB(16,16,22)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.1),
            {BackgroundColor3=Color3.fromRGB(200,30,30)}):Play()
        task.wait(0.15); cb()
    end)
end

-- ════════════════════════════════════════════════════════════
-- ROLE DETECTION
-- ════════════════════════════════════════════════════════════
local RoleColor={
    Murderer=Color3.fromRGB(220,35,35),
    Sheriff =Color3.fromRGB(60,130,255),
    Innocent=Color3.fromRGB(55,210,75),
    Unknown =Color3.fromRGB(160,160,160),
}

local function GetRole(p)
    local char=p.Character; if not char then return "Unknown" end
    local function scan(parent)
        if not parent then return nil end
        for _,v in ipairs(parent:GetChildren()) do
            if v:IsA("Tool") then
                local n=v.Name:lower()
                if n:find("knife") or n:find("murder") then return "Murderer" end
                if n:find("gun")   or n:find("sheriff") or n:find("revolver") then return "Sheriff" end
            end
        end
    end
    local r=scan(char) or scan(p:FindFirstChildOfClass("Backpack"))
    if r then return r end
    local function chkVal(o)
        if not o then return nil end
        local v=o:FindFirstChild("Role") or o:FindFirstChild("role")
        if v then
            local s=tostring(v.Value):lower()
            if s:find("murder")  then return "Murderer" end
            if s:find("sheriff") then return "Sheriff"  end
            if s:find("innocent")then return "Innocent" end
        end
    end
    return chkVal(p) or chkVal(p:FindFirstChild("Data")) or "Innocent"
end

local function MyRole() return GetRole(LP) end

-- ════════════════════════════════════════════════════════════
-- ESP POOL
-- ════════════════════════════════════════════════════════════
local Pool={}
local function GetESP(p)
    if Pool[p] then return Pool[p] end
    local function D(t,props)
        local o=Drawing.new(t); for k,v in pairs(props) do o[k]=v end; return o
    end
    Pool[p]={
        Box   =D("Square",{Visible=false,Filled=false,Thickness=1.5}),
        Tracer=D("Line",  {Visible=false,Thickness=1}),
        Name  =D("Text",  {Visible=false,Size=13,Font=2,Center=true,Outline=true}),
        Role  =D("Text",  {Visible=false,Size=11,Font=2,Center=true,Outline=true}),
        Dist  =D("Text",  {Visible=false,Size=10,Font=2,Center=true,Outline=true,
                           Color=Color3.fromRGB(200,200,200)}),
        HBar  =D("Square",{Visible=false,Filled=true}),
        HBG   =D("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(20,20,20)}),
    }
    return Pool[p]
end
local function KillESP(p)
    if Pool[p] then for _,d in pairs(Pool[p]) do d:Remove() end Pool[p]=nil end
end
Players.PlayerRemoving:Connect(KillESP)

-- ════════════════════════════════════════════════════════════
-- DRAWINGS — FOV + CROSSHAIR + KNIFE
-- ════════════════════════════════════════════════════════════
local FOVCircle=Drawing.new("Circle")
FOVCircle.Visible=false; FOVCircle.Radius=Cfg.Aim.FOV
FOVCircle.Color=Color3.fromRGB(255,255,255)
FOVCircle.Thickness=1; FOVCircle.Filled=false; FOVCircle.NumSides=64

local CHLines={}
for i=1,4 do
    local l=Drawing.new("Line"); l.Visible=false
    l.Color=Color3.fromRGB(255,50,50); l.Thickness=2
    table.insert(CHLines,l)
end
local CHDot=Drawing.new("Circle"); CHDot.Visible=false
CHDot.Radius=2; CHDot.Color=Color3.fromRGB(255,50,50)
CHDot.Filled=true; CHDot.NumSides=12

local KnifeArrow=Drawing.new("Triangle")
KnifeArrow.Visible=false; KnifeArrow.Color=Color3.fromRGB(220,35,35)
KnifeArrow.Filled=true; KnifeArrow.Thickness=1

local KnifeLabel=Drawing.new("Text")
KnifeLabel.Visible=false; KnifeLabel.Size=11; KnifeLabel.Font=2
KnifeLabel.Center=true; KnifeLabel.Outline=true
KnifeLabel.Color=Color3.fromRGB(220,35,35); KnifeLabel.Text="KNIFE"

-- ════════════════════════════════════════════════════════════
-- VELOCITY CACHE
-- ════════════════════════════════════════════════════════════
local VelCache={}
RunService.Heartbeat:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP or not p.Character then continue end
        local hrp=p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local prev=VelCache[p] and VelCache[p].pos
            local now=hrp.Position
            VelCache[p]={pos=now,vel=prev and (now-prev)/0.016 or Vector3.zero}
        end
    end
end)

-- ════════════════════════════════════════════════════════════
-- TARGET FINDER
-- ════════════════════════════════════════════════════════════
local RayParams=RaycastParams.new()
RayParams.FilterType=Enum.RaycastFilterType.Exclude

local function IsVisible(origin,target)
    if not Cfg.Aim.VisCheck then return true end
    local char=LP.Character
    RayParams.FilterDescendantsInstances=char and {char} or {}
    return not workspace:Raycast(origin,target-origin,RayParams)
end

local function GetPredicted(p)
    local bone=p.Character:FindFirstChild(Cfg.Aim.Bone)
             or p.Character:FindFirstChild("HumanoidRootPart")
    if not bone then return nil,nil end
    local pos=bone.Position
    if Cfg.Aim.Prediction and VelCache[p] then
        pos=pos+VelCache[p].vel*(Cfg.Aim.PredictStr/100)
    end
    return bone,pos
end

local function BestTarget()
    local mp=UserInputService:GetMouseLocation()
    local myRole=MyRole()
    local best,bestDist=nil,Cfg.Aim.FOV
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP or not p.Character then continue end
        local hum=p.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then continue end
        local role=GetRole(p)
        if Cfg.Aim.RoleFilter
        and (myRole=="Sheriff" or myRole=="Innocent")
        and role~="Murderer" then continue end
        local bone,pos=GetPredicted(p)
        if not bone then continue end
        local sp,onScreen=Camera:WorldToViewportPoint(pos)
        if not onScreen then continue end
        local d=(Vector2.new(sp.X,sp.Y)-mp).Magnitude
        if d<bestDist and IsVisible(Camera.CFrame.Position,pos) then
            bestDist=d; best={player=p,bone=bone,pos=pos}
        end
    end
    return best
end

-- ════════════════════════════════════════════════════════════
-- COMBAT REMOTE DISCOVERY (supplementary — aim works without it)
-- ════════════════════════════════════════════════════════════
local COMBAT_REMOTES={}
local SHOOT_REMOTE=nil

task.spawn(function()
    task.wait(4)
    local function scan(folder)
        if not folder then return end
        for _,v in ipairs(folder:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local n=v.Name:lower()
                if n:find("knife") or n:find("throw") or n:find("shoot")
                or n:find("gun")   or n:find("fire")  or n:find("kill") then
                    COMBAT_REMOTES[v.Name]=v
                    if not SHOOT_REMOTE and (n:find("shoot") or n:find("fire") or n:find("gun")) then
                        SHOOT_REMOTE=v
                    end
                end
            end
        end
    end
    scan(workspace); scan(ReplicatedStorage)
    local c=LP.Character; if c then scan(c) end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(2)
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n=v.Name:lower()
            if n:find("shoot") or n:find("fire") or n:find("gun") or n:find("knife") then
                COMBAT_REMOTES[v.Name]=v
                if not SHOOT_REMOTE then SHOOT_REMOTE=v end
            end
        end
    end
end)

-- ════════════════════════════════════════════════════════════
-- SILENT AIM — PARENT CHAIN DETECTION (works immediately)
-- ════════════════════════════════════════════════════════════
local function IsWeaponRemote(obj)
    local cur=obj.Parent; local depth=0
    while cur and cur~=game and depth<6 do
        if cur:IsA("Tool") then return true end
        cur=cur.Parent; depth=depth+1
    end
    return COMBAT_REMOTES[obj.Name] ~= nil
end

local oldNC
oldNC=hookmetamethod(game,"__namecall",function(self,...)
    local method=getnamecallmethod()
    if Cfg.Aim.Enabled and (method=="FireServer" or method=="InvokeServer") then
        if IsWeaponRemote(self) then
            if Cfg.Aim.HitChance<100 and math.random(1,100)>Cfg.Aim.HitChance then
                return oldNC(self,...)
            end
            if Cfg.Aim.LockOnKey
            and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                return oldNC(self,...)
            end
            local t=BestTarget()
            if t then
                local args={...}
                local replaced=false
                for i,v in ipairs(args) do
                    if typeof(v)=="Vector3" then
                        args[i]=t.pos; replaced=true
                    elseif typeof(v)=="CFrame" then
                        args[i]=CFrame.new(t.pos); replaced=true
                    elseif typeof(v)=="Instance" then
                        if v:IsA("BasePart") then args[i]=t.bone; replaced=true
                        elseif v:IsA("Player") then args[i]=t.player; replaced=true end
                    end
                end
                if not replaced then
                    table.insert(args,t.pos)
                    table.insert(args,t.bone)
                end
                return oldNC(self,table.unpack(args))
            end
        end
    end
    return oldNC(self,...)
end)

-- ════════════════════════════════════════════════════════════
-- AUTO SHOOT
-- ════════════════════════════════════════════════════════════
local lastShot=0

local function GetEquippedGun()
    local char=LP.Character; if not char then return nil end
    for _,v in ipairs(char:GetChildren()) do
        if v:IsA("Tool") then
            local n=v.Name:lower()
            if n:find("gun") or n:find("sheriff") or n:find("revolver") then return v end
        end
    end
end

local function GetShootRemote(gun)
    if SHOOT_REMOTE then return SHOOT_REMOTE end
    if gun then
        for _,v in ipairs(gun:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local n=v.Name:lower()
                if n:find("shoot") or n:find("fire") then SHOOT_REMOTE=v; return v end
            end
        end
    end
    for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n=v.Name:lower()
            if n:find("shoot") or n:find("fire") or n:find("gun") then
                SHOOT_REMOTE=v; return v
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not Cfg.AutoShoot.Enabled then return end
    if tick()-lastShot<Cfg.AutoShoot.Delay then return end
    local gun=GetEquippedGun(); if not gun then return end
    local murderer=nil
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP or not p.Character then continue end
        local hum=p.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 and GetRole(p)=="Murderer" then murderer=p; break end
    end
    if not murderer then return end
    local head=murderer.Character:FindFirstChild("Head")
            or murderer.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local vel=VelCache[murderer] and VelCache[murderer].vel or Vector3.zero
    local predicted=head.Position+vel*(Cfg.Aim.PredictStr/100)
    local remote=GetShootRemote(gun)
    if remote then
        if remote:IsA("RemoteEvent") then remote:FireServer(predicted,head)
        else remote:InvokeServer(predicted,head) end
        lastShot=tick()
    end
end)

-- ════════════════════════════════════════════════════════════
-- MOVEMENT
-- ════════════════════════════════════════════════════════════
UserInputService.JumpRequest:Connect(function()
    if not Cfg.Movement.InfJump then return end
    local char=LP.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

RunService.Stepped:Connect(function()
    if not Cfg.Movement.NoClip then return end
    local char=LP.Character; if not char then return end
    for _,p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=false end
    end
end)

RunService.Heartbeat:Connect(function()
    local char=LP.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.WalkSpeed=Cfg.Movement.SpeedEnabled and Cfg.Movement.Speed or 16
    hum.JumpPower=Cfg.Movement.JumpEnabled  and Cfg.Movement.JumpPower or 50
end)

local flyConn,flyBP,flyAG
local function StartFly()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=true end
    flyBP=Instance.new("BodyPosition"); flyBP.MaxForce=Vector3.new(1e5,1e5,1e5)
    flyBP.Position=hrp.Position; flyBP.P=1e4; flyBP.Parent=hrp
    flyAG=Instance.new("BodyAngularVelocity"); flyAG.MaxTorque=Vector3.new(1e5,1e5,1e5)
    flyAG.AngularVelocity=Vector3.zero; flyAG.Parent=hrp
    flyConn=RunService.RenderStepped:Connect(function()
        if not Cfg.Movement.Fly then
            flyBP:Destroy(); flyAG:Destroy()
            if hum then hum.PlatformStand=false end
            flyConn:Disconnect(); return
        end
        local spd=Cfg.Movement.FlySpeed; local cf=Camera.CFrame; local vel=Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel=vel+cf.LookVector*spd end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel=vel-cf.LookVector*spd end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel=vel-cf.RightVector*spd end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel=vel+cf.RightVector*spd end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel=vel+Vector3.new(0,spd,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel=vel-Vector3.new(0,spd,0) end
        flyBP.Position=flyBP.Position+vel*0.016
    end)
end

-- ════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ════════════════════════════════════════════════════════════
local afkConn
local function ToggleAntiAFK(state)
    if afkConn then afkConn:Disconnect(); afkConn=nil end
    if not state then return end
    local t=0
    afkConn=RunService.Heartbeat:Connect(function(dt)
        t=t+dt
        if t>=55 then
            t=0
            pcall(function()
                local vu=game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- ════════════════════════════════════════════════════════════
-- COIN FARM
-- ════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    if not Cfg.Coins.Enabled then return end
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name=="Coin"
        and (obj.Position-hrp.Position).Magnitude<=Cfg.Coins.Range then
            firetouchinterest(hrp,obj,0); task.wait()
            firetouchinterest(hrp,obj,1)
        end
    end
end)

-- ════════════════════════════════════════════════════════════
-- GUN ESP
-- ════════════════════════════════════════════════════════════
local GunBoxes={}
local function RefreshGunESP()
    for _,h in pairs(GunBoxes) do h:Destroy() end; GunBoxes={}
    if not Cfg.GunESP.Enabled then return end
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower()
            if n:find("gun") or n:find("sheriff") or n:find("revolver") then
                local owned=false
                for _,p in ipairs(Players:GetPlayers()) do
                    local bag=p:FindFirstChildOfClass("Backpack")
                    if (p.Character and obj:IsDescendantOf(p.Character))
                    or (bag and obj:IsDescendantOf(bag)) then owned=true;break end
                end
                if not owned then
                    local h=Instance.new("SelectionBox")
                    h.Adornee=obj:FindFirstChildWhichIsA("BasePart") or obj
                    h.Color3=Color3.fromRGB(60,130,255)
                    h.LineThickness=0.05; h.SurfaceTransparency=0.65
                    h.Parent=workspace; table.insert(GunBoxes,h)
                end
            end
        end
    end
end
task.spawn(function() while task.wait(1.5) do RefreshGunESP() end end)

-- ════════════════════════════════════════════════════════════
-- GUN TELEPORT — FIXED (saves pos → TPs → grabs → returns)
-- ════════════════════════════════════════════════════════════
local lastGunTP=0
local savedGunPos=nil

local function PlayerHasGun()
    local char=LP.Character
    local bag=LP:FindFirstChildOfClass("Backpack")
    local function check(parent)
        if not parent then return false end
        for _,v in ipairs(parent:GetChildren()) do
            if v:IsA("Tool") then
                local n=v.Name:lower()
                if n:find("gun") or n:find("sheriff") or n:find("revolver") then return true end
            end
        end
        return false
    end
    return check(char) or check(bag)
end

local function FindDroppedGun()
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest,cd=nil,math.huge
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower()
            if n:find("gun") or n:find("sheriff") or n:find("revolver") then
                local owned=false
                for _,p in ipairs(Players:GetPlayers()) do
                    local bag=p:FindFirstChildOfClass("Backpack")
                    if (p.Character and obj:IsDescendantOf(p.Character))
                    or (bag and obj:IsDescendantOf(bag)) then owned=true;break end
                end
                if not owned then
                    local handle=obj:FindFirstChild("Handle")
                               or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        local d=(handle.Position-hrp.Position).Magnitude
                        if d<cd then cd=d;closest=handle end
                    end
                end
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    if not Cfg.GunTP.Enabled then return end
    if tick()-lastGunTP<Cfg.GunTP.Cooldown then return end
    if PlayerHasGun() then return end
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local handle=FindDroppedGun(); if not handle then return end

    savedGunPos=hrp.CFrame
    lastGunTP=tick()
    hrp.CFrame=CFrame.new(handle.Position+Vector3.new(0,2.5,0))

    task.wait(0.05)
    pcall(function() firetouchinterest(hrp,handle,0) end)
    pcall(function()
        local bp=handle.Parent:FindFirstChildWhichIsA("BasePart")
        if bp and bp~=handle then firetouchinterest(hrp,bp,0) end
    end)

    task.spawn(function()
        local attempts=0
        while attempts<25 do
            task.wait(0.1); attempts=attempts+1
            pcall(function() firetouchinterest(hrp,handle,0) end)
            if PlayerHasGun() then break end
        end
        local c=LP.Character
        local h=c and c:FindFirstChild("HumanoidRootPart")
        if h and savedGunPos then
            h.CFrame=savedGunPos; savedGunPos=nil
        end
    end)
end)

-- ════════════════════════════════════════════════════════════
-- MURDER TELEPORT
-- ════════════════════════════════════════════════════════════
local lastMTP=0
RunService.Heartbeat:Connect(function()
    if not Cfg.MurderTP.Enabled then return end
    if tick()-lastMTP<Cfg.MurderTP.Cooldown then return end
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP or not p.Character then continue end
        local hum=p.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 and GetRole(p)=="Murderer" then
            local mhrp=p.Character:FindFirstChild("HumanoidRootPart")
            if mhrp then
                hrp.CFrame=CFrame.new(mhrp.Position+Vector3.new(3,2,0))
                lastMTP=tick(); break
            end
        end
    end
end)

-- ════════════════════════════════════════════════════════════
-- KNIFE TRACKER
-- ════════════════════════════════════════════════════════════
local function FindKnife()
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n=obj.Name:lower()
            if n:find("knife") or n:find("blade") then return obj end
        end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if not p.Character then continue end
        for _,v in ipairs(p.Character:GetChildren()) do
            if v:IsA("Tool") and v.Name:lower():find("knife") then
                local h=v:FindFirstChild("Handle"); if h then return h end
            end
        end
    end
end

-- ════════════════════════════════════════════════════════════
-- MURDER ALERT BANNER
-- ════════════════════════════════════════════════════════════
local AlertBanner=Instance.new("TextLabel")
AlertBanner.Size=UDim2.new(0,255,0,38); AlertBanner.Position=UDim2.new(0.5,-127,0,55)
AlertBanner.BackgroundColor3=Color3.fromRGB(190,20,20); AlertBanner.BorderSizePixel=0
AlertBanner.Text="⚠  MURDERER NEARBY  ⚠"
AlertBanner.TextColor3=Color3.fromRGB(255,255,255); AlertBanner.TextSize=14
AlertBanner.Font=Enum.Font.GothamBold; AlertBanner.Visible=false; AlertBanner.Parent=SG
Instance.new("UICorner",AlertBanner).CornerRadius=UDim.new(0,7)

RunService.Heartbeat:Connect(function()
    if not Cfg.Alert.Enabled then AlertBanner.Visible=false; return end
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then AlertBanner.Visible=false; return end
    local danger=false
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP or not p.Character then continue end
        if GetRole(p)~="Murderer" then continue end
        local mhrp=p.Character:FindFirstChild("HumanoidRootPart")
        if mhrp and (mhrp.Position-hrp.Position).Magnitude<=Cfg.Alert.Range then
            danger=true; break
        end
    end
    AlertBanner.Visible=danger
end)

-- ════════════════════════════════════════════════════════════
-- ROLE ANNOUNCER
-- ════════════════════════════════════════════════════════════
local RolePanel=Instance.new("Frame")
RolePanel.Size=UDim2.new(0,300,0,80); RolePanel.Position=UDim2.new(0.5,-150,0.15,0)
RolePanel.BackgroundColor3=Color3.fromRGB(12,12,18); RolePanel.BorderSizePixel=0
RolePanel.BackgroundTransparency=1; RolePanel.Visible=false; RolePanel.Parent=SG
Instance.new("UICorner",RolePanel).CornerRadius=UDim.new(0,10)

local RATop=Instance.new("TextLabel"); RATop.Size=UDim2.new(1,0,0,30)
RATop.Position=UDim2.new(0,0,0,10); RATop.BackgroundTransparency=1
RATop.Text="YOU ARE"; RATop.TextColor3=Color3.fromRGB(160,160,180)
RATop.TextSize=13; RATop.Font=Enum.Font.GothamBold; RATop.Parent=RolePanel

local RARole=Instance.new("TextLabel"); RARole.Size=UDim2.new(1,0,0,36)
RARole.Position=UDim2.new(0,0,0,34); RARole.BackgroundTransparency=1
RARole.Text="INNOCENT"; RARole.TextColor3=Color3.fromRGB(55,210,75)
RARole.TextSize=28; RARole.Font=Enum.Font.GothamBlack; RARole.Parent=RolePanel

local function AnnounceRole()
    if not Cfg.RoleAnnounce.Enabled then return end
    task.wait(4)
    local role=MyRole(); local col=RoleColor[role] or RoleColor.Unknown
    RARole.Text=role:upper(); RARole.TextColor3=col
    RolePanel.BackgroundTransparency=0; RolePanel.Visible=true
    task.wait(3.5)
    TweenService:Create(RolePanel,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
    task.wait(0.5); RolePanel.Visible=false
end
LP.CharacterAdded:Connect(function() task.spawn(AnnounceRole) end)

-- ════════════════════════════════════════════════════════════
-- RENDER LOOP
-- ════════════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    local vp=Camera.ViewportSize

    -- FOV circle
    FOVCircle.Position=UserInputService:GetMouseLocation()
    FOVCircle.Radius=Cfg.Aim.FOV
    FOVCircle.Visible=Cfg.Aim.Enabled and Cfg.Aim.ShowFOV

    -- Crosshair
    local cx,cy=vp.X/2,vp.Y/2; local sz=Cfg.Crosshair.Size
    local cc=Color3.fromRGB(255,50,50)
    if Cfg.Crosshair.Enabled then
        CHLines[1].From=Vector2.new(cx-sz,cy); CHLines[1].To=Vector2.new(cx-4,cy)
        CHLines[2].From=Vector2.new(cx+4,cy);  CHLines[2].To=Vector2.new(cx+sz,cy)
        CHLines[3].From=Vector2.new(cx,cy-sz); CHLines[3].To=Vector2.new(cx,cy-4)
        CHLines[4].From=Vector2.new(cx,cy+4);  CHLines[4].To=Vector2.new(cx,cy+sz)
        for _,l in ipairs(CHLines) do l.Color=cc; l.Visible=true end
        CHDot.Position=Vector2.new(cx,cy); CHDot.Color=cc; CHDot.Visible=true
    else
        for _,l in ipairs(CHLines) do l.Visible=false end; CHDot.Visible=false
    end

    -- Knife tracker
    local knife=Cfg.KnifeTrack.Enabled and FindKnife()
    if knife then
        local sp,onScreen=Camera:WorldToViewportPoint(knife.Position)
        if onScreen then
            local kx,ky=sp.X,sp.Y
            KnifeArrow.PointA=Vector2.new(kx,ky-14)
            KnifeArrow.PointB=Vector2.new(kx-8,ky+6)
            KnifeArrow.PointC=Vector2.new(kx+8,ky+6)
            KnifeArrow.Visible=true
            KnifeLabel.Position=Vector2.new(kx,ky+10); KnifeLabel.Visible=true
        else
            local dir=(knife.Position-Camera.CFrame.Position)
            local sp2=Camera:WorldToViewportPoint(Camera.CFrame.Position+dir.Unit*5)
            local ex=math.clamp(sp2.X,20,vp.X-20)
            local ey=math.clamp(sp2.Y,20,vp.Y-20)
            KnifeArrow.PointA=Vector2.new(ex,ey-10)
            KnifeArrow.PointB=Vector2.new(ex-6,ey+5)
            KnifeArrow.PointC=Vector2.new(ex+6,ey+5)
            KnifeArrow.Visible=true
            KnifeLabel.Position=Vector2.new(ex,ey+8); KnifeLabel.Visible=true
        end
    else
        KnifeArrow.Visible=false; KnifeLabel.Visible=false
    end

    -- ESP
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP then continue end
        local obj=GetESP(p)
        local char=p.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local function hide() for _,d in pairs(obj) do d.Visible=false end end
        if not hrp or not hum or hum.Health<=0 then hide(); continue end
        local dist=(hrp.Position-Camera.CFrame.Position).Magnitude
        if dist>Cfg.ESP.MaxDist then hide(); continue end
        local sp,onScreen=Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then hide(); continue end
        local role=GetRole(p); local col=RoleColor[role]
        local topY=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3.2,0)).Y
        local botY=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3.0,0)).Y
        local h=math.abs(topY-botY); local w=h*0.58
        local sx,sy=sp.X,sp.Y; local E=Cfg.ESP.Enabled
        obj.Box.Visible=E and Cfg.ESP.Box
        obj.Box.Size=Vector2.new(w,h)
        obj.Box.Position=Vector2.new(sx-w/2,sy-h/2)
        obj.Box.Color=col; obj.Box.Thickness=Cfg.ESP.Thickness
        obj.Tracer.Visible=E and Cfg.ESP.Tracer
        obj.Tracer.From=Vector2.new(vp.X/2,vp.Y)
        obj.Tracer.To=Vector2.new(sx,sy+h/2); obj.Tracer.Color=col
        obj.Name.Visible=E and Cfg.ESP.NameTag
        obj.Name.Text=p.Name; obj.Name.Color=Color3.fromRGB(255,255,255)
        obj.Name.Position=Vector2.new(sx,sy-h/2-27)
        obj.Role.Visible=E and Cfg.ESP.RoleTag
        obj.Role.Text="["..role.."]"; obj.Role.Color=col
        obj.Role.Position=Vector2.new(sx,sy-h/2-15)
        obj.Dist.Visible=E and Cfg.ESP.Distance
        obj.Dist.Text=math.floor(dist).."m"
        obj.Dist.Position=Vector2.new(sx,sy+h/2+3)
        local hpPct=hum.Health/hum.MaxHealth
        local barH=h*hpPct; local barX=sx-w/2-6
        local hpCol=Color3.fromRGB(math.floor(255*(1-hpPct)),math.floor(255*hpPct),30)
        obj.HBG.Visible=E and Cfg.ESP.HealthBar
        obj.HBG.Size=Vector2.new(3,h); obj.HBG.Position=Vector2.new(barX,sy-h/2)
        obj.HBar.Visible=E and Cfg.ESP.HealthBar
        obj.HBar.Size=Vector2.new(3,barH)
        obj.HBar.Position=Vector2.new(barX,sy+h/2-barH); obj.HBar.Color=hpCol
    end
end)

-- ════════════════════════════════════════════════════════════
-- GUI BUILDER
-- ════════════════════════════════════════════════════════════
local function BuildGUI(platform)
    local mob=(platform=="Mobile")
    local winW=mob and 320 or 295
    local winH=mob and 420 or 375
    local tabH=mob and 36  or 28
    local bTxt=mob and 15  or 13
    local sTxt=mob and 12  or 10
    local rowH=mob and 42  or 32
    local slH =mob and 58  or 50

    local Win=Instance.new("Frame"); Win.Name="Win"
    Win.Size=UDim2.new(0,winW,0,winH)
    Win.Position=UDim2.new(0.5,-winW/2,0.5,-winH/2)
    Win.BackgroundColor3=Color3.fromRGB(11,11,16)
    Win.BorderSizePixel=0; Win.Active=true; Win.Draggable=true; Win.Parent=SG
    Instance.new("UICorner",Win).CornerRadius=UDim.new(0,8)

    local Acc=Instance.new("Frame"); Acc.Size=UDim2.new(1,0,0,3)
    Acc.BackgroundColor3=Color3.fromRGB(200,30,30); Acc.BorderSizePixel=0; Acc.Parent=Win
    Instance.new("UICorner",Acc).CornerRadius=UDim.new(0,8)

    local TL=Instance.new("TextLabel"); TL.Size=UDim2.new(1,-10,0,30)
    TL.Position=UDim2.new(0,10,0,6); TL.BackgroundTransparency=1
    TL.Text="BLITZ V2  •  "..(mob and "MM2 MOBILE" or "MM2 PC")
    TL.TextColor3=Color3.fromRGB(255,255,255); TL.TextSize=13
    TL.Font=Enum.Font.GothamBold; TL.TextXAlignment=Enum.TextXAlignment.Left; TL.Parent=Win

    local TB=Instance.new("Frame"); TB.Size=UDim2.new(1,0,0,tabH)
    TB.Position=UDim2.new(0,0,0,38)
    TB.BackgroundColor3=Color3.fromRGB(17,17,23); TB.BorderSizePixel=0; TB.Parent=Win
    local TBL=Instance.new("UIListLayout"); TBL.FillDirection=Enum.FillDirection.Horizontal
    TBL.SortOrder=Enum.SortOrder.LayoutOrder; TBL.Parent=TB

    local DL=Instance.new("Frame"); DL.Size=UDim2.new(1,0,0,1)
    DL.Position=UDim2.new(0,0,0,38+tabH)
    DL.BackgroundColor3=Color3.fromRGB(28,28,38); DL.BorderSizePixel=0; DL.Parent=Win

    local Ct=Instance.new("ScrollingFrame")
    Ct.Size=UDim2.new(1,0,1,-(42+tabH)); Ct.Position=UDim2.new(0,0,0,42+tabH)
    Ct.BackgroundTransparency=1; Ct.BorderSizePixel=0
    Ct.ScrollBarThickness=3; Ct.ScrollBarImageColor3=Color3.fromRGB(200,30,30)
    Ct.CanvasSize=UDim2.new(0,0,0,0); Ct.AutomaticCanvasSize=Enum.AutomaticSize.Y
    Ct.Active=true; Ct.Parent=Win
    local CL=Instance.new("UIListLayout"); CL.Padding=UDim.new(0,0)
    CL.SortOrder=Enum.SortOrder.LayoutOrder; CL.Parent=Ct

    local Pages={}; local Btns={}
    local Tabs={"ESP","AIM","MOVE","UTIL","EXTRA"}

    local function MakePage(name)
        local pg=Instance.new("Frame"); pg.Name=name.."Pg"
        pg.Size=UDim2.new(1,0,0,10); pg.AutomaticSize=Enum.AutomaticSize.Y
        pg.BackgroundTransparency=1; pg.BorderSizePixel=0
        pg.Visible=false; pg.LayoutOrder=#Pages+1; pg.Parent=Ct
        local pl=Instance.new("UIListLayout"); pl.Padding=UDim.new(0,2)
        pl.SortOrder=Enum.SortOrder.LayoutOrder; pl.Parent=pg
        local pp=Instance.new("UIPadding"); pp.PaddingLeft=UDim.new(0,12)
        pp.PaddingRight=UDim.new(0,12); pp.PaddingTop=UDim.new(0,8)
        pp.PaddingBottom=UDim.new(0,10); pp.Parent=pg
        Pages[name]=pg; return pg
    end

    local function Switch(name)
        for n,pg in pairs(Pages) do pg.Visible=(n==name) end
        for n,b in pairs(Btns) do
            if n==name then
                b.BackgroundColor3=Color3.fromRGB(200,30,30)
                b.TextColor3=Color3.fromRGB(255,255,255)
            else
                b.BackgroundColor3=Color3.fromRGB(17,17,23)
                b.TextColor3=Color3.fromRGB(100,100,115)
            end
        end
        Ct.CanvasPosition=Vector2.zero
    end

    for i,name in ipairs(Tabs) do
        MakePage(name)
        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(1/#Tabs,0,1,0); btn.LayoutOrder=i
        btn.BackgroundColor3=Color3.fromRGB(17,17,23); btn.BorderSizePixel=0
        btn.Text=name; btn.TextSize=mob and 13 or 11; btn.Font=Enum.Font.GothamBold
        btn.TextColor3=Color3.fromRGB(100,100,115); btn.Parent=TB
        Btns[name]=btn
        btn.MouseButton1Click:Connect(function() Switch(name) end)
    end

    -- helpers
    local function Sec(pg,text)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,-24,0,mob and 26 or 22)
        f.BackgroundTransparency=1; f.Parent=pg
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,1,0)
        l.BackgroundTransparency=1; l.Text=text
        l.TextColor3=Color3.fromRGB(200,30,30); l.TextSize=sTxt
        l.Font=Enum.Font.GothamBold; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    end

    local function Tog(pg,label,tbl,key,cb)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,-24,0,rowH)
        row.BackgroundTransparency=1; row.Parent=pg
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.72,0,1,0)
        lbl.BackgroundTransparency=1; lbl.Text=label
        lbl.TextColor3=Color3.fromRGB(195,195,210); lbl.TextSize=bTxt
        lbl.Font=Enum.Font.Gotham; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=row
        local tw=mob and 50 or 44; local th=mob and 26 or 22; local kw=mob and 20 or 16
        local track=Instance.new("Frame"); track.Size=UDim2.new(0,tw,0,th)
        track.Position=UDim2.new(1,-tw,0.5,-th/2)
        track.BackgroundColor3=Color3.fromRGB(30,30,42); track.BorderSizePixel=0
        track.Active=true; track.Parent=row
        Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
        local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,kw,0,kw)
        knob.Position=UDim2.new(0,3,0.5,-kw/2)
        knob.BackgroundColor3=Color3.fromRGB(100,100,118); knob.BorderSizePixel=0
        knob.Active=true; knob.Parent=track
        Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
        local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0)
        btn.BackgroundTransparency=1; btn.Text=""; btn.Parent=track
        local function R(s)
            if s then
                track.BackgroundColor3=Color3.fromRGB(200,30,30)
                knob.Position=UDim2.new(1,-(kw+3),0.5,-kw/2)
                knob.BackgroundColor3=Color3.fromRGB(255,255,255)
            else
                track.BackgroundColor3=Color3.fromRGB(30,30,42)
                knob.Position=UDim2.new(0,3,0.5,-kw/2)
                knob.BackgroundColor3=Color3.fromRGB(100,100,118)
            end
        end
        R(tbl[key])
        btn.MouseButton1Click:Connect(function()
            tbl[key]=not tbl[key]; R(tbl[key])
            if cb then cb(tbl[key]) end
        end)
    end

    local function Sld(pg,label,tbl,key,mn,mx,fmt,cb)
        local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,-24,0,slH)
        wrap.BackgroundTransparency=1; wrap.Active=true; wrap.Parent=pg
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.65,0,0,mob and 24 or 20)
        lbl.BackgroundTransparency=1; lbl.Text=label
        lbl.TextColor3=Color3.fromRGB(195,195,210); lbl.TextSize=bTxt
        lbl.Font=Enum.Font.Gotham; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=wrap
        local fmtS=fmt or "%d"
        local vL=Instance.new("TextLabel"); vL.Size=UDim2.new(0.35,0,0,mob and 24 or 20)
        vL.Position=UDim2.new(0.65,0,0,0); vL.BackgroundTransparency=1
        vL.Text=string.format(fmtS,tbl[key])
        vL.TextColor3=Color3.fromRGB(200,30,30); vL.TextSize=bTxt-1
        vL.Font=Enum.Font.GothamBold; vL.TextXAlignment=Enum.TextXAlignment.Right; vL.Parent=wrap
        local tY=mob and 32 or 28; local tH=mob and 8 or 5; local kS=mob and 18 or 13
        local track=Instance.new("Frame"); track.Size=UDim2.new(1,0,0,tH)
        track.Position=UDim2.new(0,0,0,tY)
        track.BackgroundColor3=Color3.fromRGB(30,30,42); track.BorderSizePixel=0
        track.Active=true; track.Parent=wrap  -- KEY: blocks drag on window
        Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
        local p0=(tbl[key]-mn)/(mx-mn)
        local fill=Instance.new("Frame"); fill.Size=UDim2.new(p0,0,1,0)
        fill.BackgroundColor3=Color3.fromRGB(200,30,30); fill.BorderSizePixel=0; fill.Parent=track
        Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
        local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,kS,0,kS)
        knob.Position=UDim2.new(p0,-kS/2,0.5,-kS/2)
        knob.BackgroundColor3=Color3.fromRGB(255,255,255); knob.BorderSizePixel=0
        knob.Active=true; knob.Parent=track  -- KEY: blocks drag on window
        Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
        local drag=false
        local function Upd(x)
            local a=track.AbsolutePosition.X; local s=track.AbsoluteSize.X
            local p=math.clamp((x-a)/s,0,1)
            local v=math.floor(mn+p*(mx-mn))
            tbl[key]=v; vL.Text=string.format(fmtS,v)
            fill.Size=UDim2.new(p,0,1,0); knob.Position=UDim2.new(p,-kS/2,0.5,-kS/2)
            if key=="FOV" then FOVCircle.Radius=v end
            if cb then cb(v) end
        end
        knob.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch then drag=true end
        end)
        track.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch then drag=true; Upd(i.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch then drag=false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and (i.UserInputType==Enum.UserInputType.MouseMovement
            or i.UserInputType==Enum.UserInputType.Touch) then Upd(i.Position.X) end
        end)
    end

    local function DD(pg,label,options,tbl,key)
        local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,-24,0,mob and 68 or 56)
        wrap.BackgroundTransparency=1; wrap.Active=true; wrap.Parent=pg
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,0,mob and 24 or 20)
        lbl.BackgroundTransparency=1; lbl.Text=label
        lbl.TextColor3=Color3.fromRGB(195,195,210); lbl.TextSize=bTxt
        lbl.Font=Enum.Font.Gotham; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=wrap
        local bh=mob and 36 or 28
        local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,bh)
        btn.Position=UDim2.new(0,0,0,mob and 26 or 22)
        btn.BackgroundColor3=Color3.fromRGB(22,22,30); btn.BorderSizePixel=0
        btn.Text=tbl[key].."  ▾"; btn.TextColor3=Color3.fromRGB(200,30,30)
        btn.TextSize=bTxt-1; btn.Font=Enum.Font.GothamBold; btn.Active=true; btn.Parent=wrap
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
        local oh=mob and 34 or 26
        local dF=Instance.new("Frame"); dF.Visible=false
        dF.Size=UDim2.new(1,0,0,#options*oh)
        dF.Position=UDim2.new(0,0,0,mob and 64 or 52)
        dF.BackgroundColor3=Color3.fromRGB(22,22,30); dF.BorderSizePixel=0
        dF.ZIndex=20; dF.Active=true; dF.Parent=wrap
        Instance.new("UICorner",dF).CornerRadius=UDim.new(0,5)
        for i,opt in ipairs(options) do
            local ob=Instance.new("TextButton"); ob.Size=UDim2.new(1,0,0,oh)
            ob.Position=UDim2.new(0,0,0,(i-1)*oh); ob.BackgroundTransparency=1
            ob.Text=opt; ob.TextSize=bTxt-1; ob.Font=Enum.Font.Gotham; ob.ZIndex=21
            ob.TextColor3=Color3.fromRGB(180,180,195); ob.Parent=dF
            ob.MouseButton1Click:Connect(function()
                tbl[key]=opt; btn.Text=opt.."  ▾"; dF.Visible=false
            end)
        end
        local open=false
        btn.MouseButton1Click:Connect(function() open=not open; dF.Visible=open end)
    end

    -- ── POPULATE ────────────────────────────────────────────
    local P=Pages

    Sec(P.ESP,"[ VISUALS ]")
    Tog(P.ESP,"ESP Master",     Cfg.ESP,"Enabled")
    Tog(P.ESP,"Box",            Cfg.ESP,"Box")
    Tog(P.ESP,"Tracer",         Cfg.ESP,"Tracer")
    Tog(P.ESP,"Name Tag",       Cfg.ESP,"NameTag")
    Tog(P.ESP,"Role Tag",       Cfg.ESP,"RoleTag")
    Tog(P.ESP,"Health Bar",     Cfg.ESP,"HealthBar")
    Tog(P.ESP,"Distance",       Cfg.ESP,"Distance")
    Sec(P.ESP,"[ RANGE ]")
    Sld(P.ESP,"Max Distance",   Cfg.ESP,"MaxDist",  50,1000,"%d m")
    Sld(P.ESP,"Box Thickness",  Cfg.ESP,"Thickness", 1,5,   "%.1f")

    Sec(P.AIM,"[ SILENT AIM ]")
    Tog(P.AIM,"Silent Aim",     Cfg.Aim,"Enabled")
    Tog(P.AIM,"Role Filter",    Cfg.Aim,"RoleFilter")
    Tog(P.AIM,"Prediction",     Cfg.Aim,"Prediction")
    Tog(P.AIM,"Vis Check",      Cfg.Aim,"VisCheck")
    if not mob then Tog(P.AIM,"RMB Lock-On",Cfg.Aim,"LockOnKey") end
    Tog(P.AIM,"FOV Circle",     Cfg.Aim,"ShowFOV")
    Sec(P.AIM,"[ AUTO SHOOT ]")
    Tog(P.AIM,"Auto Shoot",     Cfg.AutoShoot,"Enabled")
    Sld(P.AIM,"Shot Delay",     Cfg.AutoShoot,"Delay",0,2,"%.2f s")
    Sec(P.AIM,"[ TUNING ]")
    Sld(P.AIM,"FOV Radius",     Cfg.Aim,"FOV",      30,400,"%d px")
    Sld(P.AIM,"Hit Chance",     Cfg.Aim,"HitChance", 1,100,"%d%%")
    Sld(P.AIM,"Predict Str",    Cfg.Aim,"PredictStr",0,40, "%d")
    Sec(P.AIM,"[ BONE ]")
    DD(P.AIM,"Target Bone",{"Head","HumanoidRootPart","Torso"},Cfg.Aim,"Bone")

    Sec(P.MOVE,"[ SPEED ]")
    Tog(P.MOVE,"Speed Boost",   Cfg.Movement,"SpeedEnabled")
    Sld(P.MOVE,"Walk Speed",    Cfg.Movement,"Speed",   16,100,"%d")
    Sec(P.MOVE,"[ JUMP ]")
    Tog(P.MOVE,"Jump Boost",    Cfg.Movement,"JumpEnabled")
    Sld(P.MOVE,"Jump Power",    Cfg.Movement,"JumpPower",50,500,"%d")
    Tog(P.MOVE,"Infinite Jump", Cfg.Movement,"InfJump")
    Sec(P.MOVE,"[ MOBILITY ]")
    Tog(P.MOVE,"NoClip",        Cfg.Movement,"NoClip")
    Tog(P.MOVE,"Fly  [W/A/S/D+Space/Ctrl]",Cfg.Movement,"Fly",function(s)
        if s then StartFly() end
    end)
    Sld(P.MOVE,"Fly Speed",     Cfg.Movement,"FlySpeed",10,200,"%d")

    Sec(P.UTIL,"[ COINS ]")
    Tog(P.UTIL,"Coin Farm",     Cfg.Coins,"Enabled")
    Sld(P.UTIL,"Coin Range",    Cfg.Coins,"Range",10,500,"%d m")
    Sec(P.UTIL,"[ GUN ]")
    Tog(P.UTIL,"Gun ESP",       Cfg.GunESP,"Enabled",function(s)
        if not s then for _,h in pairs(GunBoxes) do h:Destroy() end GunBoxes={} end
    end)
    Tog(P.UTIL,"Auto TP to Gun",Cfg.GunTP,"Enabled")
    Sec(P.UTIL,"[ ALERTS ]")
    Tog(P.UTIL,"Murder Alert",  Cfg.Alert,"Enabled")
    Sld(P.UTIL,"Alert Range",   Cfg.Alert,"Range",5,100,"%d m")
    Sec(P.UTIL,"[ TELEPORT ]")
    Tog(P.UTIL,"TP to Murderer",Cfg.MurderTP,"Enabled")

    Sec(P.EXTRA,"[ VISUAL ]")
    Tog(P.EXTRA,"Crosshair",    Cfg.Crosshair,"Enabled")
    Sld(P.EXTRA,"CH Size",      Cfg.Crosshair,"Size",4,30,"%d")
    Tog(P.EXTRA,"Knife Tracker",Cfg.KnifeTrack,"Enabled")
    Sec(P.EXTRA,"[ QUALITY OF LIFE ]")
    Tog(P.EXTRA,"Role Announce",Cfg.RoleAnnounce,"Enabled")
    Tog(P.EXTRA,"Anti-AFK",     Cfg.AntiAFK,"Enabled",function(s) ToggleAntiAFK(s) end)

    -- toggle button
    if mob then
        local MT=Instance.new("TextButton")
        MT.Size=UDim2.new(0,54,0,54); MT.Position=UDim2.new(1,-62,0.5,-27)
        MT.BackgroundColor3=Color3.fromRGB(200,30,30); MT.BorderSizePixel=0
        MT.Text="☰"; MT.TextColor3=Color3.fromRGB(255,255,255)
        MT.TextSize=28; MT.Font=Enum.Font.GothamBold; MT.ZIndex=50; MT.Parent=SG
        Instance.new("UICorner",MT).CornerRadius=UDim.new(1,0)
        MT.MouseButton1Click:Connect(function() Win.Visible=not Win.Visible end)
    else
        local hint=Instance.new("TextLabel"); hint.Size=UDim2.new(1,0,0,14)
        hint.Position=UDim2.new(0,0,1,-16); hint.BackgroundTransparency=1
        hint.Text="INSERT  —  toggle panel"
        hint.TextColor3=Color3.fromRGB(40,40,52); hint.TextSize=10
        hint.Font=Enum.Font.Gotham; hint.Parent=Win
        UserInputService.InputBegan:Connect(function(i,gpe)
            if gpe then return end
            if i.KeyCode==Enum.KeyCode.Insert then Win.Visible=not Win.Visible end
        end)
    end

    Switch("ESP")
    Win.BackgroundTransparency=1
    TweenService:Create(Win,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()
end

-- ════════════════════════════════════════════════════════════
-- LAUNCH SEQUENCE
-- ════════════════════════════════════════════════════════════
task.spawn(function()
    local dur=3.2; local start=tick(); local stepIdx=1
    while true do
        local pct=math.clamp((tick()-start)/dur,0,1)
        TweenService:Create(BarFill,TweenInfo.new(0.08),
            {Size=UDim2.new(pct,0,1,0)}):Play()
        if loadSteps[stepIdx] and pct>=loadSteps[stepIdx].t then
            LoadStatus.Text=loadSteps[stepIdx].txt; stepIdx=stepIdx+1
        end
        if pct>=1 then break end
        task.wait(0.03)
    end
    task.wait(0.4)

    -- fade out loading screen
    TweenService:Create(LoadFrame,TweenInfo.new(0.5),
        {BackgroundTransparency=1}):Play()
    for _,v in ipairs(LoadFrame:GetDescendants()) do
        if v:IsA("GuiObject") then
            pcall(function()
                TweenService:Create(v,TweenInfo.new(0.4),
                    {BackgroundTransparency=1,TextTransparency=1}):Play()
            end)
        end
    end
    task.wait(0.5); LoadFrame.Visible=false

    -- show picker
    PickerFrame.Visible=true; PickerFrame.BackgroundTransparency=1
    TweenService:Create(PickerFrame,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()

    local picked=false
    local function Pick(plat)
        if picked then return end; picked=true
        TweenService:Create(PickerFrame,TweenInfo.new(0.35),
            {BackgroundTransparency=1}):Play()
        for _,v in ipairs(PickerFrame:GetDescendants()) do
            if v:IsA("GuiObject") then
                pcall(function()
                    TweenService:Create(v,TweenInfo.new(0.3),
                        {BackgroundTransparency=1,TextTransparency=1}):Play()
                end)
            end
        end
        task.wait(0.4); PickerFrame.Visible=false
        BuildGUI(plat)
    end

    MakePickBtn("PC",
        "Keyboard & Mouse\nFull feature set\nINSERT to toggle",
        "🖥",-190,function() Pick("PC") end)

    MakePickBtn("Mobile",
        "Touch screen\nLarger UI & buttons\nOn-screen toggle",
        "📱",20,function() Pick("Mobile") end)
end)

print("[Blitz V2 Apex Final] loading...")