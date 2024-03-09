local VORPcore = {}

TriggerEvent("getCore", function(core)
  VORPcore = core
end)

local VORPInv = {}

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

local HasIngredients, Destroying = nil, false


crypt = exports['bcc-crypt'].install()


VORPInv.RegisterUsableItem(Config.Props.barrel, function(data)
  TriggerClientEvent('bcc-brewing:placeProp', data.source, data.item.item)
  VORPInv.CloseInv(data.source)
end)

VORPInv.RegisterUsableItem(Config.Props.still, function(data)
  TriggerClientEvent('bcc-brewing:placeProp', data.source, data.item.item)
  VORPInv.CloseInv(data.source)
end)

RegisterServerEvent('bcc-brewing:GetPropsFromWorld', function()
  local _source = source
  Wait(1000)
  local brew = nil
  exports.oxmysql:execute("SELECT * FROM brewing", {}, function(result)
    if result[1] then
      brew = result
    else
      brew = false
    end
  end)
  while brew == nil do
    Wait(200)
  end
  if brew then
    TriggerClientEvent('bcc-brewing:SendPropsFromWorld', -1, brew)
  end
end)

RegisterNetEvent('bcc-brewing:SaveToDB', function(name, x, y, z, h)
  local _source = source
  UUID = crypt.uuid4()
  local param = {
    ['id'] = UUID,
    ['propname'] = name,
    ['x'] = x,
    ['y'] = y,
    ['z'] = z,
    ['h'] = h,
    ['isbrewing'] = 0,
    ['stage'] = 1,
    ['currentbrew'] = 'None',
  }
  local db = MySQL.query.await(
    "INSERT INTO brewing (`id`,`propname`,`x`,`y`,`z`,`h`,isbrewing,stage,currentbrew ) VALUES (@id,@propname,@x,@y,@z,@h,@isbrewing,@stage,@currentbrew) RETURNING *;",
    param)
  VORPInv.subItem(_source, name, 1)
  TriggerClientEvent('bcc-brewing:sync', -1)
end)

RegisterServerEvent('bcc-brewing:GetCoords')
AddEventHandler("bcc-brewing:GetCoords", function()
  local _source = source
  local stills = {}

  exports.oxmysql:execute('SELECT * FROM brewing', {}, function(result)
    if (#result ~= 0) then
      stills = result
    end
    for i, v in pairs(stills) do
      TriggerClientEvent("bcc-brewing:GetIdFromDistance", _source, v.propname, v.id, v.x, v.y, v.z)
    end
  end)
end)

RegisterServerEvent('bcc-brewing:GetObjectId')
AddEventHandler("bcc-brewing:GetObjectId", function(object, id, x, y)
  local _source = source
  local stills = {}
  local result = MySQL.query.await("SELECT * FROM brewing WHERE id = @id", {
    ['id'] = id
  })
  if #result > 0 then
    stills = result
    for i, v in pairs(stills) do
      TriggerClientEvent('bcc-brewing:GetPropData', _source, stills)
    end
  end
end)

RegisterServerEvent('bcc-brewing:CheckIngredients', function(id, stage, currentbrew)
  local _source = source
  print(stage, currentbrew)
  if stage ~= nil then
    for k, v in pairs(Config.Moonshines[currentbrew][stage].ingredients) do
      local itemCount = VORPInv.getItemCount(_source, k)
      if itemCount >= v then
        HasIngredients = true
      else
        HasIngredients = false
        break
      end
    end
    if HasIngredients then
      for k, v in pairs(Config.Moonshines[currentbrew][stage].ingredients) do
        VORPInv.subItem(_source, k, v)
      end
      TriggerClientEvent('bcc-brewing:StartBrewingMoonshine', _source, stage, true, currentbrew)
      VORPcore.NotifyRightTip(_source, _U('TookIngredients'), 4000)
      if stage == Config.Moonshines[currentbrew].LastStage then
        Wait(Config.Moonshines[currentbrew][stage].stilltime * 60000)
        local canCarry = VORPInv.canCarryItem(_source, currentbrew, Config.Moonshines[currentbrew].AmountToBrew)
        VORPcore.NotifyRightTip(_source, _U('BrewCompleted'), 4000)
        return
      end
    else
      VORPcore.NotifyRightTip(_source, _U('NoIngredients'), 4000)
      if Config.ShowIngredients.Tip then
        VORPcore.NotifyRightTip(_source, Config.MashesandAlcohol[currentbrew].Tip, 4000)
      end
    end
  elseif stage == nil then
    for k, v in pairs(Config.MashesandAlcohol[currentbrew].ingredients) do
      local itemCount = VORPInv.getItemCount(_source, k)
      if itemCount >= v then
        HasIngredients = true
      else
        HasIngredients = false
        break
      end
    end
    if HasIngredients then
      for k, v in pairs(Config.MashesandAlcohol[currentbrew].ingredients) do
        VORPInv.subItem(_source, k, v)
      end
      TriggerClientEvent('bcc-brewing:StartBrewingMash', _source, nil, true, currentbrew)
      VORPcore.NotifyRightTip(_source, _U('TookIngredients'), 4000)
      Wait(Config.MashesandAlcohol[currentbrew].fermenttime * 60000)
      local canCarry = VORPInv.canCarryItem(_source, currentbrew, Config.MashesandAlcohol[currentbrew].AmountToBrew)
      VORPcore.NotifyRightTip(_source, _U('BrewCompleted'), 4000)
      if canCarry then
        local space = VORPInv.canCarryItems(_source, Config.MashesandAlcohol[currentbrew].AmountToBrew)
        if space then
          VORPInv.addItem(_source, currentbrew, Config.MashesandAlcohol[currentbrew].AmountToBrew)
        end
      end
      return
    else
      VORPcore.NotifyRightTip(_source, _U('NoIngredients'), 4000)
      if Config.ShowIngredients.Tip then
        VORPcore.NotifyRightTip(_source, Config.MashesandAlcohol[currentbrew].Tip, 4000)
      end
    end
  end
end)

RegisterServerEvent('bcc-brewing:FinishBrewing')
AddEventHandler("bcc-brewing:FinishBrewing", function(id, brew,table)
  local _source = source
  local canCarry = VORPInv.canCarryItem(_source, brew, table[brew].AmountToBrew)
  if canCarry then
    local space = VORPInv.canCarryItems(_source, table[brew].AmountToBrew)
    if space then
      VORPInv.addItem(_source, brew, table[brew].AmountToBrew)
      TriggerEvent('bcc-brewing:ChangeStage', id, 0, 0, 'None')
      VORPcore.NotifyRightTip(_source, _U('FinishBrewing'), 4000)
    else
      VORPcore.NotifyRightTip(_source, _U('FullInventory'), 4000)
    end
  else
    VORPcore.NotifyRightTip(_source, _U('FullItem'), 4000)
  end
end)

RegisterServerEvent('bcc-brewing:SyncSmokeServer')
AddEventHandler("bcc-brewing:SyncSmokeServer", function(waittime)
  TriggerClientEvent('bcc-brewing:SyncSmokeClient', -1, waittime)
end)

RegisterServerEvent('bcc-brewing:ChangeStage', function(id, stage, isbrewing, currentbrew)
  print('this got triggered')
  local param = {
    ['id'] = id,
    ['stage'] = stage + 1,
    ['isbrewing'] = isbrewing,
    ['currentbrew'] = currentbrew
  }
  local db = MySQL.query.await(
    "UPDATE brewing SET `stage`= @stage, currentbrew = @currentbrew, isbrewing = @isbrewing WHERE id =@id",
    param)
end)


RegisterServerEvent('bcc-brewing:RemoveFromDb')
AddEventHandler("bcc-brewing:RemoveFromDb", function(id, object, x, y, z)
  local _source = source
  local Character = VORPcore.getUser(_source).getUsedCharacter
  local job = Character.job
  exports.oxmysql:execute("DELETE FROM brewing WHERE id = ?", {
    id
  })
  TriggerClientEvent('bcc-brewing:DeleteProp', -1, object, x, y, z)

  TriggerClientEvent('bcc-brewing:DestroyProp', _source, object, x, y, z)
  Citizen.Wait(Config.DestroyTime * 1000)
  if Config.GivePropsBack then
    if CheckTable(Config.Jobs, job) then
      Citizen.Wait(Config.DestroyTime * 1000)
      VORPcore.NotifyRightTip(_source, _U('StillDestroyed'), 4000)
    else
      if object == Config.Props.still then
        VORPInv.addItem(_source, Config.Props.still, 1)
      else
        VORPInv.addItem(_source, Config.Props.barrel, 1)
      end
      Citizen.Wait(Config.DestroyTime * 1000)
      VORPcore.NotifyRightTip(_source, _U('StillPickedUp'), 4000)
    end
  end
end)

RegisterServerEvent('bcc-brewing:StopBrewing', function(id)
  local param = {
    ['id'] = id,
  }
  local db = MySQL.query.await(
    "UPDATE brewing SET `isbrewing`= 0 WHERE id =@id",
    param)
end)
--[[AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  exports.oxmysql:execute("UPDATE brewing SET isbrewing = 0")
end)]]

-- Job checking table
function CheckTable(table, element)
  for k, v in pairs(table) do
    if v == element then
      return true
    end
  end
  return false
end
