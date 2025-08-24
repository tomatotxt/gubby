-- Max Speed Money Generator API by tomato.txt

local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local LocalPlayer = Players.LocalPlayer
local PlayerData = ReplicatedStorage.PlayerData
local LocalPlayerData = PlayerData[LocalPlayer.Name]
local MoneyValue = LocalPlayerData.Inventory.Currencies.Money

local MoneyPerCall = 1170.122
local RemoteEvents = ReplicatedStorage.Networking.Server.RemoteEvents
local ChangeSetting = cloneref(RemoteEvents.ChangeSetting)
local VoidDamage = cloneref(RemoteEvents.DamageEvents.VoidDamage)
local Point = vector.create(0, 0, 0)

local function CallVoidDamage()
	VoidDamage:FireServer(Point)
end

local function AddMoney(Amount)
	for i = 1, Amount / MoneyPerCall do
		task.spawn(CallVoidDamage)
	end
end

local function DistanceToAmount(Amount)
	local Result = Amount - MoneyValue.Value
	if Result <= 0 then
		return 0
	end
	return Result
end

local function SetMoney(TargetAmount)
	AddMoney(DistanceToAmount(TargetAmount))
	task.spawn(CallVoidDamage)
end

-- Prevent Lag or Crash
ChangeSetting:FireServer("ShowMoneyGUIs", false)

local API = {}
API.AddMoney = AddMoney
API.SetMoney = SetMoney
return API
