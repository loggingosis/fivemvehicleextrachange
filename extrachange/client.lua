local function notify(msg)
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        multiline = false,
        args = {'Extras', msg}
    })
end

local function isValidExtra(vehicle, extraId)
    -- DoesExtraExist returns true if that extra exists on this vehicle model
    return DoesExtraExist(vehicle, extraId)
end

RegisterCommand('e', function(_, args)
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        notify('You must be in a vehicle.')
        return
    end

    local vehicle = GetVehiclePedIsIn(ped, false)

    -- Optional: only allow driver to control extras
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        notify('You must be the driver.')
        return
    end

    local extraId = tonumber(args[1])

    if not extraId then
        notify('Usage: /e <extra number>')
        return
    end

    if extraId < 1 or extraId > 14 then
        notify('Extra number must be between 1 and 14.')
        return
    end

    if not isValidExtra(vehicle, extraId) then
        notify(('Extra %d does not exist on this vehicle.'):format(extraId))
        return
    end

    -- In GTA natives:
    -- IsVehicleExtraTurnedOn(vehicle, extraId) == true means enabled
    -- SetVehicleExtra(vehicle, extraId, disable) where:
    --    0 = enable
    --    1 = disable
    local isOn = IsVehicleExtraTurnedOn(vehicle, extraId)

    if isOn then
        SetVehicleExtra(vehicle, extraId, 1)
        notify(('Extra %d disabled.'):format(extraId))
    else
        SetVehicleExtra(vehicle, extraId, 0)
        notify(('Extra %d enabled.'):format(extraId))
    end
end, false)
