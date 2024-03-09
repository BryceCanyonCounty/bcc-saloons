local VORPcore = {} -- core object

TriggerEvent("getCore", function(core)
    VORPcore = core
end)
local BccUtils = {}
TriggerEvent('bcc:getUtils', function(bccutils)
    BccUtils = bccutils
end)

local placing, prompt, PlacingObj = false, false, nil

local stills = {}
ActiveProps = {}

MenuOpen = nil
Destroying = nil

BccUtils = exports['bcc-utils'].initiate()

RegisterNetEvent("vorp:SelectedCharacter", function()
TriggerServerEvent('bcc-brewing:GetPropsFromWorld')
end)

RegisterNetEvent("bcc-brewing:SendPropsFromWorld", function(sentstills)
    stills = sentstills
    for k, v in pairs(stills) do
        v.spawned = false
        v.obj = nil
        if v.isbrewing == 1 then
            Wait(Config.Moonshines[v.currentbrew][v.stage].stilltime * 60000)
            TriggerServerEvent('bcc-brewing:ChangeStage', v.id, v.stage, 0, v.currentbrew)
        end
    end
end)

CreateThread(function()
    -- Add a spawned flag for each still
    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        Wait(5)
        for k, v in pairs(stills) do
            if GetDistanceBetweenCoords(pcoords.x, pcoords.y, pcoords.z, v.x, v.y, v.z, true) < Config.SpawnDistance then
                if not v.spawned then
                    v.obj = CreateObject(v.propname, v.x, v.y, v.z, false, true, false)
                    SetEntityHeading(v.obj, v.h)
                    PlaceObjectOnGroundProperly(v.obj)
                    v.spawned = true
                    if TempObj then
                        DeleteEntity(TempObj)
                    end
                end
            else
                if v.spawned and v.isbrewing == 0 then
                    DeleteEntity(v.obj)
                    v.spawned = false
                    if TempObj then
                        DeleteEntity(TempObj)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('bcc-brewing:GetIdFromDistance')
AddEventHandler('bcc-brewing:GetIdFromDistance', function(object, id, x2, y2, z2)
    local pcoords = GetEntityCoords(PlayerPedId())
    local distance = GetDistanceBetweenCoords(pcoords, x2, y2, z2, true)
    if distance <= 2 then
        TriggerServerEvent("bcc-brewing:GetObjectId", object, id, x2, y2)
    end
end)

RegisterNetEvent('bcc-brewing:GetPropData')
AddEventHandler('bcc-brewing:GetPropData', function(propdata)
    ActiveProps = propdata
end)


-- Open menu thread
CreateThread(function()
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup()
    local firstprompt = PromptGroup:RegisterPrompt(_U('BrewPrompt'), Config.Keys.r, 1, 1, true, 'hold',
        { timedeventhash = "MEDIUM_TIMED_EVENT" })                                                                                                   --Register your first prompt
    local secondprompt = PromptGroup:RegisterPrompt(_U('DestroyPrompt'), Config.Keys.g, 1, 1, true, 'hold',
        { timedeventhash = "MEDIUM_TIMED_EVENT" })                                                                                                   --Register your first prompt
    while true do
        Wait(5)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        local isNearStill = DoesObjectOfTypeExistAtCoords(x, y, z, Config.InteractDistance,
            GetHashKey(Config.Props.still), true)
        local isNearBarrel = DoesObjectOfTypeExistAtCoords(x, y, z, Config.InteractDistance,
            GetHashKey(Config.Props.barrel), true)
        if isNearStill and not placing then
            PromptGroup:ShowGroup('Brewing')
            firstprompt:TogglePrompt(true)
            secondprompt:TogglePrompt(true)
            if firstprompt:HasCompleted() then
                TriggerServerEvent("bcc-brewing:GetCoords", x, y, z)
                Wait(750)
                for k, v in pairs(ActiveProps) do
                    if not MenuOpen and v.isbrewing == 0 then
                        MenuOpen = true
                        OpenStillMenu(v.id, v.stage, v.currentbrew)
                    end
                    if v.isbrewing == 1 then
                        VORPcore.NotifyRightTip(_U('CurrentlyBrewing'), 4000)
                    end
                end
                if MenuOpen then
                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_PLAYER_DYNAMIC_KNEEL'), 0, true, false,
                        false, false)
                end
            end
            if secondprompt:HasCompleted() then
                if not Destroying then
                    Destroying = true
                    TriggerServerEvent("bcc-brewing:GetCoords", x, y, z)
                    Wait(750)
                    for k, v in pairs(ActiveProps) do
                        TriggerServerEvent("bcc-brewing:RemoveFromDb", v.id, v.propname, v.x, v.y, v.z)
                    end
                end
            end
        end

        if isNearBarrel and not placing then
            PromptGroup:ShowGroup('Brewing')

            if firstprompt:HasCompleted() then
                TriggerServerEvent("bcc-brewing:GetCoords", x, y, z)
                Wait(750)
                for k, v in pairs(ActiveProps) do
                    if not MenuOpen and v.isbrewing == 0 then
                        MenuOpen = true
                        OpenMashMenu(v.id, v.stage, v.currentbrew)
                    end
                    if v.isbrewing == 1 then
                        VORPcore.NotifyRightTip(_U('CurrentlyBrewing'), 4000)
                    end
                end
                if MenuOpen then
                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_PLAYER_DYNAMIC_KNEEL'), 0, true, false,
                        false, false)
                end
            end
            if secondprompt:HasCompleted() then
                if not Destroying then
                    TriggerServerEvent("bcc-brewing:GetCoords", x, y, z)
                    Wait(750)
                    for k, v in pairs(stills) do
                        v.destroying = true
                        Destroying = v.destroying
                    end
                    for k, v in pairs(ActiveProps) do
                        TriggerServerEvent("bcc-brewing:RemoveFromDb", v.id, v.propname, v.x, v.y, v.z)
                    end
                end
            end
        end

        if not isNearStill and not isNearBarrel then
            firstprompt:TogglePrompt(false)
            secondprompt:TogglePrompt(false)
        end
    end
end)

-- destroying the barrel / destillery prop and give it back to the player
RegisterNetEvent('bcc-brewing:DestroyProp')
AddEventHandler('bcc-brewing:DestroyProp', function(object, x, y, z)
    local prop = GetClosestObjectOfType(x, y, z, 1.0, GetHashKey(object), false, false, false)
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_SLEDGEHAMMER'), 0, true, false, false, false)
    Citizen.Wait(Config.DestroyTime * 1000)
    DeleteObject(prop)
    ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent('bcc-brewing:sync')
AddEventHandler('bcc-brewing:sync', function()
    TriggerServerEvent('bcc-brewing:GetPropsFromWorld')
end)


RegisterNetEvent('bcc-brewing:DeleteProp')
AddEventHandler('bcc-brewing:DeleteProp', function(object, x, y, z)
    local prop = GetClosestObjectOfType(x, y, z, 5.0, GetHashKey(object), false, false, false)
    Citizen.Wait(Config.DestroyTime * 1000)
    DeleteObject(prop)
    for k, v in pairs(stills) do
        stills[k] = nil
        DeleteObject(v.obj)
        v.destroying = false
        Destroying = v.destroying
    end
    if TempObj then
        DeleteEntity(TempObj)
    end
    TriggerServerEvent('bcc-brewing:GetPropsFromWorld')
end)

-- brewing the moonshine
RegisterNetEvent('bcc-brewing:StartBrewingMoonshine')
AddEventHandler('bcc-brewing:StartBrewingMoonshine', function(stage, isbrewing, currentbrew)
    if isbrewing then
        local playerPed = PlayerPedId()
        RequestAnimDict("script_re@moonshine_camp@player_put_in_herbs")
        while (not HasAnimDictLoaded("script_re@moonshine_camp@player_put_in_herbs")) do
            Wait(100)
        end
        TaskPlayAnim(playerPed, "script_re@moonshine_camp@player_put_in_herbs", "put_in_still", 8.0, -8.0, -1, 31, 0,
            true, 0, false, 0, false)
        Wait(4000)
        ClearPedSecondaryTask(playerPed)

        TriggerServerEvent('bcc-brewing:SyncSmokeServer', Config.Moonshines[currentbrew][stage].stilltime * 60000)
        for k, v in pairs(ActiveProps) do
            TriggerServerEvent('bcc-brewing:ChangeStage', v.id, v.stage, 1, currentbrew)
            Wait(Config.Moonshines[currentbrew][stage].stilltime * 60000)
            TriggerServerEvent('bcc-brewing:StopBrewing', v.id)
        end
    end
end)

-- brewing the mash
RegisterNetEvent('bcc-brewing:StartBrewingMash')
AddEventHandler('bcc-brewing:StartBrewingMash', function(stage, isbrewing, currentbrew)
    if isbrewing then
        local playerPed = PlayerPedId()
        RequestAnimDict("script_re@moonshine_camp@player_put_in_herbs")
        while (not HasAnimDictLoaded("script_re@moonshine_camp@player_put_in_herbs")) do
            Wait(100)
        end
        TaskPlayAnim(playerPed, "script_re@moonshine_camp@player_put_in_herbs", "put_in_still", 8.0, -8.0, -1, 31, 0,
            true, 0, false, 0, false)
        Wait(4000)
        ClearPedSecondaryTask(playerPed)

        if stage == nil then
            for k, v in pairs(ActiveProps) do
                TriggerServerEvent('bcc-brewing:ChangeStage', v.id, 2, 1, currentbrew)
                Wait(Config.MashesandAlcohol[currentbrew].fermenttime * 60000)
                TriggerServerEvent('bcc-brewing:ChangeStage', v.id, 1, 0, 'None')
            end
        end
    end
end)

RegisterNetEvent('bcc-brewing:SyncSmokeClient')
AddEventHandler('bcc-brewing:SyncSmokeClient', function(waittime)
    for k, v in pairs(ActiveProps) do
        RequestNamedPtfxAsset(GetHashKey('scr_distance_smoke'))
        while not HasNamedPtfxAssetLoaded(GetHashKey('scr_distance_smoke')) do
            Wait(10)
        end
        UseParticleFxAsset("scr_distance_smoke")
        local smoke = StartParticleFxLoopedAtCoord("scr_campfire_distance_smoke_lod", v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.5,
            false, false, false, true)
        Wait(waittime)
        StopParticleFxLooped(smoke, true)
    end
end)

RegisterNetEvent('bcc-brewing:placeProp')
AddEventHandler('bcc-brewing:placeProp', function(propName)
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup()
    local firstprompt = PromptGroup:RegisterPrompt(_U('BuildPrompt'), Config.Keys.e, 1, 1, true, 'hold',
        { timedeventhash = "MEDIUM_TIMED_EVENT" })                                                                                                   --Register your first prompt
    local secondprompt = PromptGroup:RegisterPrompt(_U('DestroyPrompt'), Config.Keys.g, 1, 1, true, 'hold',
        { timedeventhash = "MEDIUM_TIMED_EVENT" })                                                                                                   --Register your first prompt
    local pos = GetEntityCoords(PlayerPedId(), true)
    local pHead = GetEntityHeading(PlayerPedId())
    local object = GetHashKey(propName)
    if not HasModelLoaded(object) then
        RequestModel(object)
    end
    while not HasModelLoaded(object) do
        Wait(5)
    end
    placing = true
    PlacingObj = CreateObject(object, pos.x, pos.y, pos.z, false, true, false)
    SetEntityHeading(PlacingObj, pHead)
    SetEntityAlpha(PlacingObj, 51)
    AttachEntityToEntity(PlacingObj, PlayerPedId(), 0, 0.0, 1.0, -0.7, 0.0, 0.0, 0.0, true, false, false, false, false,
        true)
    while placing do
        Wait(10)
        if prompt == false then
            PromptGroup:ShowGroup('Brewing')
            firstprompt:TogglePrompt(true)
            secondprompt:TogglePrompt(true)
        end
        if firstprompt:HasCompleted() then
            firstprompt:TogglePrompt(false)
            secondprompt:TogglePrompt(false)
            prompt = false
            local PropPos = GetEntityCoords(PlacingObj, true)
            local PropHeading = GetEntityHeading(PlacingObj)
            DeleteObject(PlacingObj)
            TriggerEvent("vorp:TipBottom", _U('PlacingProp'), 4000)
            TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_SLEDGEHAMMER'), -1, true, false, false, false)
            Citizen.Wait(Config.TimeToConstruct * 1000)
            ClearPedTasksImmediately(PlayerPedId())
            if propName == Config.Props.still then
                TriggerServerEvent('bcc-brewing:SaveToDB', Config.Props.still, PropPos.x, PropPos.y, PropPos.z,
                    PropHeading)
                TriggerEvent("vorp:TipBottom", _U('StillPlaced'), 4000)
                --this little logic is from vorp moonshiner, turning it transparent and placing it
                TempObj = CreateObject(object, PropPos.x, PropPos.y, PropPos.z, false, true, false)
                SetEntityHeading(TempObj, PropHeading)
                PlaceObjectOnGroundProperly(TempObj)
                placing = false
            end
            if propName == Config.Props.barrel then
                TriggerServerEvent('bcc-brewing:SaveToDB', Config.Props.barrel, PropPos.x, PropPos.y, PropPos.z,
                    PropHeading)
                TriggerServerEvent('bcc-brewing:GetPropsFromWorld')
                TriggerEvent("vorp:TipBottom", _U('BarrelPlaced'), 4000)
                --this little logic is from vorp moonshiner, turning it transparent and placing it
                TempObj = CreateObject(object, PropPos.x, PropPos.y, PropPos.z, true, true, false)
                SetEntityHeading(TempObj, PropHeading)
                PlaceObjectOnGroundProperly(TempObj)
                placing = false
            end
            break
        end
        if secondprompt:HasCompleted() then
            firstprompt:TogglePrompt(false)
            secondprompt:TogglePrompt(false)
            DeleteObject(PlacingObj)
            prompt = false
            break
        end
    end
end)


function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    SetTextFontForCurrentCommand(15)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    DisplayText(str, x, y)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    prompt = false
    DeleteEntity(PlacingObj)
end)
