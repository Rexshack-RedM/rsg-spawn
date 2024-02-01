local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('rsg-spawn:client:setupSpawnUI', function(cData, new)
    if new == false then
        TriggerEvent('rsg-spawn:client:existingplayer')
    else
        TriggerEvent('rsg-spawn:client:newplayer')
    end
end)

RegisterNetEvent('rsg-spawn:client:existingplayer', function()
    local ped = PlayerPedId()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local isJailed = PlayerData.metadata["injail"]
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local citizenid = PlayerData.citizenid

    Citizen.InvokeNative(0x1E5B70E53DB661E5, 1122662550, 347053089, 0, firstname..' '..lastname, 'Citizen ID: '..citizenid, 'Loading Please Wait...')
    Wait(10000)

    DoScreenFadeOut(1000)
    SetEntityCoords(ped, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
    SetEntityHeading(ped, PlayerData.position.w)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    ExecuteCommand('loadskin')
    
    if isJailed > 0 then
        Wait(2000)
        TriggerEvent('rsg-prison:client:prisonclothes')
    end

    TriggerEvent('rsg-houses:client:BlipsOnSpawn')

    if Config.AutoDualWield then
        Wait(2000)
        TriggerEvent('rsg-weapons:client:AutoDualWield')
    end

    ShutdownLoadingScreen()
    DoScreenFadeIn(1000)
    TriggerServerEvent('RSGCore:Server:OnPlayerLoaded')
    TriggerEvent('RSGCore:Client:OnPlayerLoaded')
end)

RegisterNetEvent('rsg-spawn:client:newplayer', function()
    local ped = PlayerPedId()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local citizenid = PlayerData.citizenid
    
    Citizen.InvokeNative(0x1E5B70E53DB661E5, 1122662550, 347053089, 0, firstname..' '..lastname, 'Citizen ID: '..citizenid, 'Loading Please Wait...')
    Wait(10000)
    
    DoScreenFadeOut(1000)
    SetEntityCoordsNoOffset(ped, Config.SpawnLocation.coords, true, true, true)
    SetEntityHeading(ped, Config.SpawnLocation.coords.w)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    ShutdownLoadingScreen()
    DoScreenFadeIn(1000)
    TriggerServerEvent('RSGCore:Server:OnPlayerLoaded')
    TriggerEvent('RSGCore:Client:OnPlayerLoaded')
    TriggerServerEvent("rsg-clothes:LoadClothes", 2)
end)
