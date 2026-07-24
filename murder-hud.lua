local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "# Murder Nice",
   LoadingTitle = "Murder Mystery 2",
   LoadingSubtitle = "by FyKe",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
})

local player = Players.LocalPlayer

local MainTab = Window:CreateTab("🏠 Main", 4483362458)

-- Variáveis
local ESP_All = false
local ESP_Roles = false
local Color_All = Color3.fromHex("#00bf63")
local Color_Murder = Color3.fromHex("#c90e0e")
local Color_Sheriff = Color3.fromHex("#5696e3")

local highlights = {}

local function ClearHighlights()
	for _, hl in ipairs(highlights) do pcall(function() hl:Destroy() end) end
	highlights = {}
end

local function CreateHighlight(char, color)
	if not char or char:FindFirstChild("MM2ESP") then return end
	local hl = Instance.new("Highlight")
	hl.Name = "MM2ESP"
	hl.Adornee = char
	hl.FillColor = color
	hl.OutlineColor = color
	hl.FillTransparency = 0.65
	hl.OutlineTransparency = 0.25
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char
	table.insert(highlights, hl)
end

local function GetRole(plr)
	if not plr then return "Innocent" end
	
	-- 1. Leaderstats
	local ls = plr:FindFirstChild("leaderstats")
	if ls then
		for _, v in pairs(ls:GetChildren()) do
			if v:IsA("StringValue") then
				local val = tostring(v.Value):lower()
				if val:find("murder") or val:find("murd") then return "Murderer" end
				if val:find("sheriff") or val:find("xerife") or val:find("police") then return "Sheriff" end
			end
		end
	end
	
	-- 2. Backpack (Inventário)
	local backpack = plr:FindFirstChild("Backpack")
	if backpack then
		for _, tool in ipairs(backpack:GetChildren()) do
			if tool:IsA("Tool") then
				local name = tool.Name:lower()
				if name:find("knife") or name:find("murd") or name:find("assassin") then
					return "Murderer"
				end
				if name:find("gun") or name:find("pistol") or name:find("sheriff") then
					return "Sheriff"
				end
			end
		end
	end
	
	-- 3. Character (mão)
	local char = plr.Character
	if char then
		for _, tool in ipairs(char:GetChildren()) do
			if tool:IsA("Tool") then
				local name = tool.Name:lower()
				if name:find("knife") or name:find("murd") then return "Murderer" end
				if name:find("gun") or name:find("pistol") then return "Sheriff" end
			end
		end
	end
	
	return "Innocent"
end

local function UpdateESP()
	ClearHighlights()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == player or not plr.Character then continue end
		local role = GetRole(plr)
		
		if ESP_All then
			CreateHighlight(plr.Character, Color_All)
		end
		
		if ESP_Roles then
			if role == "Murderer" then
				CreateHighlight(plr.Character, Color_Murder)
			elseif role == "Sheriff" then
				CreateHighlight(plr.Character, Color_Sheriff)
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	if ESP_All or ESP_Roles then
		UpdateESP()
	else
		ClearHighlights()
	end
end)

-- UI
MainTab:CreateSection("ESP")

MainTab:CreateToggle({
   Name = "Visualizar Todos os Jogadores",
   CurrentValue = false,
   Callback = function(Value)
      ESP_All = Value
   end,
})

MainTab:CreateColorPicker({
   Name = "Cor dos Jogadores",
   Color = Color_All,
   Callback = function(Value)
      Color_All = Value
   end,
})

MainTab:CreateToggle({
   Name = "Visualizar Murder & Xerife",
   CurrentValue = false,
   Callback = function(Value)
      ESP_Roles = Value
   end,
})

Rayfield:Notify({
   Title = "Murder Nice",
   Content = "Detecção reforçada ativada!",
   Duration = 5,
})
