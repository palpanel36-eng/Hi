-- LocalScript trong Tool TeleportGun
local tool = script.Parent
local player = game.Players.LocalPlayer
local mouse = nil
local portals = {}

-- Hàm tạo cổng tại vị trí chuột
local function createPortal(position, color)
	local portal = Instance.new("Part")
	portal.Size = Vector3.new(4, 6, 1)
	portal.Anchored = true
	portal.CanCollide = false
	portal.BrickColor = BrickColor.new(color)
	portal.Material = Enum.Material.Neon
	portal.CFrame = CFrame.new(position) + Vector3.new(0, 3, 0)
	portal.Name = "Portal"
	portal.Parent = workspace
	return portal
end

-- Hàm kết nối dịch chuyển giữa 2 cổng
local function connectPortals(p1, p2)
	local cooldown = {}

	local function teleport(hit, dest)
		local char = hit.Parent
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local plr = game.Players:GetPlayerFromCharacter(char)
		if not plr then return end

		if cooldown[plr] and tick() - cooldown[plr] < 2 then return end

		hrp.CFrame = dest.CFrame + Vector3.new(0, 3, 0)
		cooldown[plr] = tick()
	end

	p1.Touched:Connect(function(hit) teleport(hit, p2) end)
	p2.Touched:Connect(function(hit) teleport(hit, p1) end)
end

tool.Equipped:Connect(function()
	mouse = player:GetMouse()

	mouse.Button1Down:Connect(function()
		if #portals >= 2 then return end

		local pos = mouse.Hit.Position
		local color = #portals == 0 and "Bright red" or "Bright blue"
		local portal = createPortal(pos, color)
		table.insert(portals, portal)

		if #portals == 2 then
			connectPortals(portals[1], portals[2])
		end
	end)
end)