Vehicleshop.giveVehicle = function(source, data, props, job)
    local source = source


    if source == nil then
        return
    end

    if Config.framework == "esx" or Config.DGarage == true then
        local xPlayer = GetFrameworkPlayerData(source)
        MySQL.Async.execute(
            'INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, price, category, categoryname, km, age, fuel, name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            { xPlayer.identifier,
                props.plate,
                json.encode(props), data.type, job, data.price, data.category, data.categorylabel, 0, os.time(), 100,
                data.label },
            function(id)
            end)
    else
        local player = QBCore.Functions.GetPlayer(source)
        MySQL.Async.execute(
            'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, fakeplate, garage, fuel, engine, body, state, depotprice, drivingdistance, status, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            { player.PlayerData.license,
                player.PlayerData.citizenid,
                data.name,
                GetHashKey(data.name),
                json.encode(props.mods),
                props.plate,
                props.fakeplate or "",
                "",
                100,
                1000,
                1000,
                1,
                0,
                0,
                "",
                0,
                0,
                0,
                0,
            }
        )
    end
end

RegisterServerEvent('vehicleshop:buy')
AddEventHandler('vehicleshop:buy', function(source, category, id, modding, job, method)
    dprint('vehicleshop:buy')
    local source = source
    local xPlayer = GetFrameworkPlayerData(source)


    if xPlayer == nil or source == nil then
        dprint('vehicleshop:buy | returning')
        return
    end
    local data = nil

    local plate_free = true
    local plate = getNewPlate(os.time())
    dprint(plate)
    local table = "owned_vehicles"
    if Config.framework == "qb" and Config.DGarage == false then
        table = "player_vehicles"
    end

    if modding.plate ~= nil then
        MySQL.Async.fetchAll(
            "SELECT * FROM " .. table .. " WHERE plate = @plate LIMIT 1",
            {
                ['@plate'] = modding.plate,
            },
            function(results)
                if #results > 0 then
                    plate_free = false
                else
                    plate = modding.plate
                end
            end
        )
    else
        MySQL.Async.fetchAll(
            "SELECT * FROM " .. table .. "  WHERE plate = @plate LIMIT 1",
            {
                ['@plate'] = plate,
            },
            function(results)
                if #results > 0 then
                    plate_free = false
                end
            end
        )
    end
    Wait(Config.MySQLWaitingTime)

    if plate_free == true then
        for i, v in pairs(VehicleConfig) do
            if v.name == category then
                if v.vehicles[id] ~= nil then
                    data = v.vehicles[id]
                    data.category = v.name
                    data.categorylabel = v.label
                else
                    Log.error("buyfree | vehicle not found")
                    return
                end
            end
        end
        local price = data.price

        if modding ~= nil then
            if modding.primary ~= nil then
                price = price + Vehicleshop.getModdingPrice("primary-color")
            end
            if modding.secondary ~= nil then
                price = price + Vehicleshop.getModdingPrice("secondary-color")
            end
            if modding.plate ~= nil then
                price = price + Vehicleshop.getModdingPrice("plate")
            end
        end

        dprint(plate)
        local money = xPlayer.money
        if method == "card" then
            money = xPlayer.bankmoney
        end

        if money >= price then
            dprint("buyfree | removed money")
            if method == "card" then
                RemoveBankMoney(source, price)
            else
                RemoveMoney(source, price)
            end
            Notify(source, _U("purchased", data.label, price, Config.Currency), 5000, "success")

            TriggerClientEvent("vehicleshop:buy:success", source, data, plate, job)

            if Config.DVehiclelock == true then
                TriggerEvent("d-vehiclelock:registernewcar", source, plate, data.label)
            end
        else
            local missingmoney = price - money
            Notify(source, _U("missingmoney", missingmoney, Config.Currency), 5000, "error")
        end
    else
        Log.warn("buyfree | plate_free is false")
        Notify(source, _U("plateisalreadyused", modding.plate), 5000, "success")
    end
end)

function getNewPlate(randomseed)
    math.randomseed(randomseed)

    local charset = {}

    for i = 65, 90 do table.insert(charset, string.char(i)) end
    for i = 97, 122 do table.insert(charset, string.char(i)) end

    local rndstr = ""

    local letters = 8

    if Config.Plate.prefix ~= nil then
        dprint("Config.Plate isnt nil")
        rndstr = Config.Plate.prefix
        letters = letters - #Config.Plate.prefix
    else
        dprint("Config.Plate is nil")
    end
    dprint(letters)
    for i = 1, letters do
        rndstr = rndstr .. charset[math.random(1, #charset)]
    end

    -- print(rdnstr)

    return rndstr
end

-- If you want plates like ABC 123

-- local NumberCharset = {}
-- local Charset = {}
-- for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
-- for i = 65,  90 do table.insert(Charset, string.char(i)) end

-- function getNewPlate(source, randomseed)
--     local generatedPlate
--     math.randomseed(GetGameTimer())
--     generatedPlate = string.upper(GetRandomLetter(3) .. '' .. GetRandomNumber(3))

--     dprint("GeneratedPlate: ".. generatedPlate .."")
--     return generatedPlate
-- end

-- function GetRandomLetter(length)
--     Citizen.Wait(0)
--     math.randomseed(GetGameTimer())
--     if length > 0 then
--         return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
--     else
--         return ''
--     end
-- end

-- function GetRandomNumber(length)
--     Citizen.Wait(0)
--     math.randomseed(GetGameTimer())
--     if length > 0 then
--         return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
--     else
--         return ''
--     end
-- end
