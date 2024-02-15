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

    -- set player health / stamina / regeneration
    local currentHealth = PlayerData.metadata["health"]
    local maxStamina = Citizen.InvokeNative(0xCB42AFE2B613EE55, PlayerPedId(), Citizen.ResultAsFloat())
    local currentStamina = Citizen.InvokeNative(0x775A1CA7893AA8B5, PlayerPedId(), Citizen.ResultAsFloat()) / maxStamina * 100
    SetEntityHealth(PlayerPedId(), currentHealth )
    Citizen.InvokeNative(0xC3D4B754C0E86B9E, PlayerPedId(), currentStamina)
    if Config.HealthRegeneration then
        Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), Config.RegenerationRate)
    else
        Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), 0.0)
    end

    ExecuteCommand('loadskin')

    SetEntityCoords(ped, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
    SetEntityHeading(ped, PlayerData.position.w)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    
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

    -- set player health / stamina / regeneration
    local currentHealth = PlayerData.metadata["health"]
    local maxStamina = Citizen.InvokeNative(0xCB42AFE2B613EE55, PlayerPedId(), Citizen.ResultAsFloat())
    local currentStamina = Citizen.InvokeNative(0x775A1CA7893AA8B5, PlayerPedId(), Citizen.ResultAsFloat()) / maxStamina * 100
    SetEntityHealth(PlayerPedId(), currentHealth )
    Citizen.InvokeNative(0xC3D4B754C0E86B9E, PlayerPedId(), currentStamina)
    if Config.HealthRegeneration then
        Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), Config.RegenerationRate)
    else
        Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), 0.0)
    end

    ExecuteCommand('loadskin')

    SetEntityCoordsNoOffset(ped, Config.SpawnLocation.coords, true, true, true)
    SetEntityHeading(ped, Config.SpawnLocation.coords.w)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    ShutdownLoadingScreen()
    DoScreenFadeIn(1000)
    TriggerServerEvent('RSGCore:Server:OnPlayerLoaded')
    TriggerEvent('RSGCore:Client:OnPlayerLoaded')
end)
