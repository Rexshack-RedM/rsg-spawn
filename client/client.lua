local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

RegisterNetEvent('rsg-spawn:client:setupSpawnUI', function(cData, new)
    if new == false then
        TriggerEvent('rsg-spawn:client:existingplayer')
        exports.weathersync:setSyncEnabled(true)
    else
        TriggerEvent('rsg-spawn:client:newplayer')
    end
end)

RegisterNetEvent('rsg-spawn:client:existingplayer', function()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local isJailed = PlayerData.metadata["injail"]
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local citizenid = PlayerData.citizenid
    local randomIndex = math.random(1, #Config.RandomTips)
    local randomTip = Config.RandomTips[randomIndex]
    Citizen.InvokeNative(0x1E5B70E53DB661E5, 1122662550, 347053089, 0, firstname..' '..lastname, locale('cl_lang_1')..citizenid, locale('cl_lang_2')..' '..randomTip)
    Wait(10000)

    DoScreenFadeOut(1000)
    exports['rsg-appearance']:ApplySkin()

    -- set player health
    local currentHealth = PlayerData.metadata["health"]
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, currentHealth)
    SetEntityCoords(playerPed, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
    SetEntityHeading(playerPed, PlayerData.position.w)
    FreezeEntityPosition(playerPed, false)
    SetEntityVisible(playerPed, true)
    
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
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local citizenid = PlayerData.citizenid
    local randomIndex = math.random(1, #Config.RandomTips)
    local randomTip = Config.RandomTips[randomIndex]
    Citizen.InvokeNative(0x1E5B70E53DB661E5, 1122662550, 347053089, 0, firstname..' '..lastname, locale('cl_lang_1')..citizenid, locale('cl_lang_2')..' '..randomTip)
    Wait(10000)
    DoScreenFadeOut(1000)

    exports['rsg-appearance']:ApplySkin()
    
    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, Config.SpawnLocation.coords, true, true, true)
    SetEntityHeading(ped, Config.SpawnLocation.coords.w)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    if Config.AutoDualWield then
        Wait(2000)
        TriggerEvent('rsg-weapons:client:AutoDualWield')
    end
    ShutdownLoadingScreen()
    ExecuteCommand('revive')
    DoScreenFadeIn(1000)
    TriggerServerEvent('RSGCore:Server:OnPlayerLoaded')
    TriggerEvent('RSGCore:Client:OnPlayerLoaded')
end)
