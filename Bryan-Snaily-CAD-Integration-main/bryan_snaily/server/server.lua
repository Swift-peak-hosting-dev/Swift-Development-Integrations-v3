---Inserts a new citizen into the database
---@param firstname string
---@param lastname string
---@param birthdate string format: YYYY/MM/DD
---@param gender? "Male"|"Female"|0|1|"m"|"f"
---@param ethnicity? string
---@param height? number
---@param weight? number
---@param hairColor? string
---@param eyeColor? string
---@param address? string
InsertNewCitizen = function(firstname, lastname, birthdate, gender, ethnicity, height, weight, hairColor, eyeColor,
                            address)
    local formatedTable = FormatCitizenInsertData({
        firstname = firstname,
        lastname = lastname,
        birthdate = birthdate,
        gender = gender,
        ethnicity = ethnicity,
        height = height,
        weight = weight,
        hairColor = hairColor,
        eyeColor = eyeColor,
        address = address
    })

    if not formatedTable then
        error('[Error] Incorrect Citizen Data')
        return
    end

    PerformHttpRequest(string.format('%sadmin/import/citizens', URLNormalize(Config.API.URL)),
        function(errorCode, resultData, resultHeaders, errorData)
            if (errorCode ~= 200) then
                if errorCode == 404 then
                    error('[Error] This API seems to be outdated, please update the script to the newest release', 1)
                else
                    local firstIndex = string.find(errorData, '{')
                    error("[Error] API Error: " ..
                        errorCode .. " " .. json.decode(string.sub(errorData, firstIndex or 0)).message)
                end
            end
        end,
        'POST',
        json.encode({
            formatedTable
        }), {
            [Config.API.TOKEN_HEADER_NAME] = Config.API.TOKEN,
            ['Content-Type'] = 'application/json',
        }
    )
end

exports('InsertNewCitizen', InsertNewCitizen)

---Inserts a new weapon into the database
---@param weaponHash string Example: 'WEAPON_PISTOL'
---@param firstname string
---@param lastname string
InsertNewWeapon = function(weaponHash, firstname, lastname)
    local formatedTable = FormatWeaponData({
        weaponHash = weaponHash,
        firstname = firstname,
        lastname = lastname
    })

    if not formatedTable then
        error('[Error] Incorrect Weapon Data')
        return
    end

    PerformHttpRequest(string.format('%sadmin/import/weapons', URLNormalize(Config.API.URL)),
        function(errorCode, resultData, resultHeaders, errorData)
            if (errorCode ~= 200) then
                if errorCode == 404 then
                    error('[Error] This API seems to be outdated, please update the script to the newest release', 1)
                else
                    local firstIndex = string.find(errorData, '{')
                    error("[Error] API Error: " ..
                        errorCode .. " " .. json.decode(string.sub(errorData, firstIndex or 0)).message)
                end
            end
        end,
        'POST',
        json.encode({
            formatedTable
        }),
        {
            [Config.API.TOKEN_HEADER_NAME] = Config.API.TOKEN,
            ['Content-Type'] = 'application/json',
        }
    )
end

exports('InsertNewWeapon', InsertNewWeapon)

---Inserts a new vehicle into the database
---@param plate string
---@param vehicleHash string has to be predefined in the database, if not it will fail! Example: 'blista'
---@param firstname string
---@param lastname string
---@param color? string
InsertNewVehicle = function(plate, vehicleHash, firstname, lastname, color)
    local formatedTable = FormatVehicleData({
        plate = plate,
        vehicleHash = vehicleHash,
        firstname = firstname,
        lastname = lastname,
        color = color
    })

    if not formatedTable then
        error('[Error] Incorrect Vehicle Data')
        return
    end

    PerformHttpRequest(string.format('%sadmin/import/vehicles', URLNormalize(Config.API.URL)),
        function(errorCode, resultData, resultHeaders, errorData)
            if (errorCode ~= 200) then
                if errorCode == 404 then
                    error('[Error] This API seems to be outdated, please update the script to the newest release', 1)
                else
                    local firstIndex = string.find(errorData, '{')
                    error("[Error] API Error: " ..
                        errorCode .. " " .. json.decode(string.sub(errorData, firstIndex or 0)).message)
                end
            end
        end,
        'POST',
        json.encode({
            formatedTable
        }),
        {
            [Config.API.TOKEN_HEADER_NAME] = Config.API.TOKEN,
            ['Content-Type'] = 'application/json',
        }
    )
end

exports('InsertNewVehicle', InsertNewVehicle)

---Set the license of a citizen
---@param license string
---@param value string
---@param firstname string
---@param lastname string
SetLicenseToCitizen = function(license, value, firstname, lastname)
    local citizenId = GetCitizenId(firstname, lastname)
    local licenseId = GetValueId('license', value)

    if not citizenId then
        error('[Error] Could not find character')
        return
    end

    if not licenseId then
        error('[Error] Could not find license type')
        return
    end

    PerformHttpRequest(string.format('%ssearch/actions/licenses/%s', URLNormalize(Config.API.URL), citizenId),
        function(errorCode, resultData, resultHeaders, errorData)
            if (errorCode ~= 200) then
                if errorCode == 404 then
                    error('[Error] This API seems to be outdated, please update the script to the newest release', 1)
                else
                    local firstIndex = string.find(errorData, '{')
                    error("[Error] API Error: " ..
                        errorCode .. " " .. json.decode(string.sub(errorData, firstIndex or 0)).message)
                end
            end
        end,
        'PUT',
        json.encode({
            [license] = licenseId
        }),
        {
            [Config.API.TOKEN_HEADER_NAME] = Config.API.TOKEN,
            ['Content-Type'] = 'application/json',
        }
    )
end

exports('SetLicenseToCitizen', SetLicenseToCitizen)

---Get whether or not a citizen is registered
---@param firstname string
---@param lastname string
---@return boolean
IsCitizenRegistered = function(firstname, lastname)
    return GetCitizenId(firstname, lastname) ~= false
end

exports('IsCitizenRegistered', IsCitizenRegistered)

---@class CitizenData
---@field firstname string
---@field lastname string
---@field birthdate string
---@field gender? "Male"|"Female"|0|1|"m"|"f"
---@field ethnicity? string
---@field height? number
---@field weight? number
---@field hairColor? string
---@field eyeColor? string
---@field address? string

---@class FormattedCitizenData
---@field name string
---@field surname string
---@field dateOfBirth string
---@field genderId number
---@field ethnicityId number
---@field height number
---@field weight number
---@field hairColor string
---@field eyeColor string
---@field address string

---Format citizen insert data
---@param data CitizenData
---@return boolean|FormattedCitizenData
FormatCitizenInsertData = function(data)
    if not data.firstname or not data.lastname or not data.birthdate then
        return false
    end

    if data.gender and type(data.gender) == 'number' then
        data.gender = data.gender == 0 and 'Male' or 'Female'
    elseif data.gender and type(data.gender) == 'string' and string.len(data.gender) == 1 then
        data.gender = data.gender == 'm' and 'Male' or 'Female'
    end

    return {
        ['name'] = data.firstname,
        ['surname'] = data.lastname,
        ['dateOfBirth'] = string.format('%sT00:00:00.000Z', data.birthdate),
        ['gender'] = data.gender and GetValueId('gender', data.gender) or GetValueId('gender'),
        ['ethnicity'] = data.ethnicity and GetValueId('ethnicity', data.ethnicity) or GetValueId('ethnicity'),
        ['height'] = data.height and tostring(data.height) or nil,
        ['weight'] = data.weight and tostring(data.weight) or nil,
        ['hairColor'] = data.hairColor or nil,
        ['eyeColor'] = data.eyeColor or nil,
        ['address'] = data.address or nil
    }
end

---@class WeaponData
---@field weaponHash string
---@field firstname string
---@field lastname string

---@class FormattedWeaponData
---@field modelId number
---@field registrationStatusId number
---@field ownerId number

---Format weapon data
---@param data WeaponData
---@return boolean|FormattedWeaponData
FormatWeaponData = function(data)
    if not data.weaponHash or not data.firstname or not data.lastname then
        return false
    end

    return {
        ['modelId'] = GetValueId('weapon', data.weaponHash, 'hash'),
        ['registrationStatusId'] = GetValueId('license', Config.Defaults.registrationStatus),
        ['ownerId'] = GetCitizenId(data.firstname, data.lastname),
    }
end

---@class VehicleData
---@field plate string
---@field firstname string
---@field lastname string
---@field vehicleHash string
---@field color? string

---@class FormattedVehicleData
---@field plate string
---@field ownerId number
---@field modelId number
---@field registrationStatusId number
---@field color string

---Formats vehicle data
---@param data VehicleData
---@return FormattedVehicleData|false
FormatVehicleData = function(data)
    if not data.plate or not data.firstname or not data.lastname or not data.vehicleHash then
        return false
    end

    return {
        ['plate'] = data.plate,
        ['ownerId'] = GetCitizenId(data.firstname, data.lastname),
        ['modelId'] = GetValueId('vehicle', data.vehicleHash, 'hash'),
        ['registrationStatusId'] = GetValueId('license', Config.Defaults.registrationStatus),
        ['color'] = data.color or nil
    }
end

---Gets the id of a value from the values-controller
---@param table string
---@param value? string|number
---@param columnToCheck? string
---@return number|nil|false
GetValueId = function(table, value, columnToCheck)
    local awaitingResponse = true
    local valueId

    PerformHttpRequest(string.format('%sadmin/values/%s', URLNormalize(Config.API.URL), table),
        function(errorCode, resultData, resultHeaders, errorData)
            if (errorCode ~= 200) then
                if errorCode == 404 then
                    error('[Error] This API seems to be outdated, please update the script to the newest release', 1)
                else
                    local firstIndex = string.find(errorData, '{')
                    error("[Error] API Error: " ..
                        errorCode .. " " .. json.decode(string.sub(errorData, firstIndex or 0)).message)
                end
                awaitingResponse = false
                return
            end
            local resultDataJson = json.decode(resultData)

            for k, v in ipairs(resultDataJson[1].values) do
                if not value or (columnToCheck and v[columnToCheck] == value or v.value == value) then
                    valueId = v.id
                    break
                end
            end

            if valueId == nil then
                valueId = false
            end
            awaitingResponse = false
        end, 'GET', json.encode({}), {
            [Config.API.TOKEN_HEADER_NAME] = Config.API.TOKEN,
            ['Content-Type'] = 'application/json',
        })

    while awaitingResponse do Wait(10) end

    return valueId
end

---This gets the citizen id of a character based on their first and last name
---@param firstname string
---@param lastname string
---@return number|false|nil
GetCitizenId = function(firstname, lastname)
    local citizenId
    local awaitingResponse = true

    if not firstname or firstname == '' then
        error('[Error] Firstname is required', 2)
    elseif not lastname or lastname == '' then
        error('[Error] Lastname is required', 2)
    end

    PerformHttpRequest(
        string.format('%sadmin/manage/citizens?query=%s+%s', URLNormalize(Config.API.URL), firstname, lastname),
        function(errorCode, resultData, resultHeaders, errorData)
            if (errorCode ~= 200) then
                if errorCode == 404 then
                    error('[Error] This API seems to be outdated, please update the script to the newest release', 1)
                else
                    local firstIndex = string.find(errorData, '{')
                    error("[Error] API Error: " ..
                        errorCode .. " " .. json.decode(string.sub(errorData, firstIndex or 0)).message)
                end
                awaitingResponse = false
                return
            end

            local resultDataJson = json.decode(resultData)

            if resultDataJson and resultDataJson.totalCount > 0 then
                citizenId = resultDataJson.citizens[1].id
            else
                citizenId = false
            end
            awaitingResponse = false
        end, 'GET', json.encode({}), {
            [Config.API.TOKEN_HEADER_NAME] = Config.API.TOKEN,
            ['Content-Type'] = 'application/json',
        })

    while awaitingResponse do Wait(10) end

    return citizenId
end
