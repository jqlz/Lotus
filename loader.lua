repeat task.wait() until game.IsLoaded
repeat task.wait() until game.GameId ~= 0

if riot and riot.Loaded then
    riot.Utilities.UI:Push({
        Title = "Riot Hub",
        Description = "Script already running!",
        Duration = 5
    }) return
end

if riot and (riot.Game and not riot.Loaded) then
    riot.Utilities.UI:Push({
        Title = "Riot Hub",
        Description = "Something went wrong!",
        Duration = 5
    }) return
end

local PlayerService = game:GetService("Players")
repeat task.wait() until PlayerService.LocalPlayer
local LocalPlayer = PlayerService.LocalPlayer

local Branch, NotificationTime, IsLocal = ...
local ClearTeleportQueue = clear_teleport_queue
local QueueOnTeleport = queue_on_teleport

local function GetFile(File)
    return IsLocal and readfile("riot/" .. File)
    or game:HttpGet(("%s%s"):format(Parvus.Source, File))
end

local function LoadScript(Script)
    return loadstring(GetFile(Script .. ".lua"), Script)()
end

local function GetGameInfo()
    for Id, Info in pairs(riot.Games) do
        if tostring(game.GameId) == Id then
            return Info
        end
    end

    return riot.Games.Universal
end

getgenv().riot = {
    Source = "https://raw.githubusercontent.com/jqlz/script-hub/" .. Branch .. "/",

    Games = {
       
    }
}

riot.Utilities = LoadScript("Utilities/Main")
riot.Utilities.UI = LoadScript("Utilities/UI")
riot.Utilities.Physics = LoadScript("Utilities/Physics")
riot.Utilities.Drawing = LoadScript("Utilities/Drawing")

riot.Cursor = GetFile("Utilities/ArrowCursor.png")
riot.Loadstring = GetFile("Utilities/Loadstring")
riot.Loadstring = Parvus.Loadstring:format(
    riot.Source, Branch, NotificationTime, tostring(IsLocal)
)

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.InProgress then
        ClearTeleportQueue()
        QueueOnTeleport(Parvus.Loadstring)
    end
end)

riot.Game = GetGameInfo()
LoadScript(riot.Game.Script)
riot.Loaded = true

riot.Utilities.UI:Push({
    Title = "Riot Hub",
    Description = riot.Game.Name .. " loaded!.",
    Duration = NotificationTime
})
