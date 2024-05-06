
local a = require(game:GetService("ReplicatedStorage").Library.Client.CustomEggsCmds)

local found100x = nil

local JobIDs = {};

local function FetchJobIDs()
    repeat task.wait()
        local API = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100".. (ServerPages and "&cursor=".. ServerPages or "")));
        for i, v in next, API["data"] do
            if v["id"] ~= game.JobId and v["playing"] ~= v["maxPlayers"] then
                table.insert(JobIDs, v["id"]);
            end;
        end;
        ServerPages = API.nextPageCursor;
    until #JobIDs >= 1; 
end;

function find_nearest_room()
    local nearest, nearest_distance = nil, math.huge
    for _,v in workspace.__THINGS.__INSTANCE_CONTAINER.Active.Backrooms.GeneratedBackrooms:GetChildren() do
        if not v:IsA("Model") or v.Name == "Walls" then continue end
        local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.WorldPivot.Position).Magnitude
        if dist > nearest_distance then continue end
            nearest = v
            nearest_distance = dist
        end
    return nearest
end

for i,v in a:All() do
    if v._id == "Backrooms Night Terror Egg 100x" then
        found100x = v
    end
end

if found100x then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(found100x._position)
    task.wait(1)

    print("FOUND x100 EGG")
    local Room = find_nearest_room()
    local Buy_Room = true
    while task.wait() do
        if Room.LockedDoors.Door.Lock.Transparency == 1 then break end
        local args = {
        [1] = "Backrooms",
        [2] = "AbstractRoom_FireServer",
        [3] = Room:GetAttribute("RoomUID"),
        [4] = "UnlockDoors"
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(unpack(args))
    end
else
    print("No x100 Egg")
    FetchJobIDs()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, JobIDs[math.random(1, #JobIDs)])
end