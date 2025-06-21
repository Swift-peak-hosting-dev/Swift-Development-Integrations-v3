###!!!!!!!!PLEASE NOTE THAT THIS SCRIPT HAS KNOWN ISSUES THAT ARE UNFORTUNATELY TAKING A LONGER TIME THAN WE THOUGHT TO FIX. PLEASE NOTE WE DO NOT RECOMMEND IT FOR LIVE SERVERS AT THIS TIME.!!!!!!!!!!###



``##THIS HAS BEEN unarchived TEMP ``



# V3 0.1

# Bryan Snaily CAD Integration for QB Core or ESX 

This script contains functions for FiveM scripts to seamlessly integrate with Snaily CAD. These functions can be invoked from other scripts using the appropriate exports.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
👏 All credits go to BryanLTU on Discord for creating this script for our community, and to me for additional contributions.

Special thanks to Kristian770 on github for enhancing the script with error handling. Your contribution is highly appreciated! ❤️

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

If you haven't already, check out SnailyCAD at [https://snailycad.org/](https://snailycad.org/). Big thanks to Casper & The Team for developing this fantastic open-source CAD.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**<span style="color:red">Note: We can only provide support for QB Core or ESX default scripts and open-source configurations. If you have a PID script that is not open source, please contact the script owner, as we are unable to assist you with it.</span>**
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Join our Discord for support or open an issue on GitHub: [https://discord.gg/mwegFPKs6C](https://discord.gg/mwegFPKs6C)

------------------------------------------------------------------------------------------------------

This is the main documentation for the Bryan Snaily CAD Integration.

For information on other scripts we support, please refer to the [Other Scripts We Support](other%20scripts%20we%20support.md) documentation 

--------------------------------------------------------------------------------------------------------------
#[Known issues](https://github.com/EWANZO101/Bryan-Snailycad-Integration-/blob/main/issues.errors.md)#
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

This is the main documentation for the Bryan Snaily CAD Integration.

## For information on other scripts we support, please refer to the [Other Scripts We Support](other%20scripts%20we%20support.md) documentation. ###


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# ⚠️ Copyright Notice ⚠️

## Disclaimer

Please note that this script is provided for community use and can be modified to suit individual needs. However, under no circumstances is it allowed to be uploaded elsewhere or sold to anyone, as the rights to this script are owned by Swift Peak Hosting & EWANZO101 . This is intended for the community's benefit and is not meant for exploitation or unauthorized distribution.

## Copyright Information

© 2024 Swift Peak Hosting & EWANZO101 . All rights reserved.

Any unauthorized reproduction, distribution, or sale of this script is strictly prohibited and may result in legal action. Swift Peak Hosting reserves the right to take appropriate measures to protect its intellectual property.


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Reporting Unauthorized Use

If you come across instances where this script is being sold or someone is falsely claiming it as their own, please contact us immediately:
[Report Here](https://github.com/EWANZO101/Bryan-Snaily-CAD-Integration/blob/main/Copyright.md)

Thank you for respecting our terms and conditions.



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## Setup



```lua
Config.Defaults = {
    registrationStatus = 'Valid'
}
```

This table helps to set Default values in certain functions.

`registrationStatus` - License Type when registering new Vehicle or Weapon

```lua
Config.API = {
    URL = 'api_url',
    TOKEN = 'token',
    TOKEN_HEADER_NAME = 'snaily-cad-api-token',
}
```

`URL` - Link on which your CAD is hosted (example: https://api.your-domain-here/v1/ or https://api-test.your-domain-here/v1/)

`TOKEN` - You can find this Token in your CAD Settings (Admin > CAD Settings > API Token)

## Exports

### Is Citizen Registered

Checks if the Citizen exists in the CAD system

```lua
exports['bryan_snaily']:IsCitizenRegistered(firstname, lastname)
```

| Paramater   | Type   | Optional | Default | Description           |
| ----------- | ------ | :------: | ------- | --------------------- |
| `firstname` | string |    ❌    |         | Character's Firstname |
| `lastname`  | string |    ❌    |         | Character's Lastname  |

### Insert New Citizen

```lua
exports['bryan_snaily']:InsertNewCitizen(firstname, lastname, birthdate, gender, ethnicity, height, weight, hairColor, eyeColor, address)
```

| Paramater   | Type                                       | Optional | Default  | Description                    |
| ----------- | ------------------------------------------ | :------: | -------- | ------------------------------ |
| `firstname` | string                                     |    ❌    |          | Firstname                      |
| `lastname`  | string                                     |    ❌    |          | Lastname                       |
| `birthdate` | string                                     |    ❌    |          | Birthdate (format: YYYY-MM-DD) |
| `gender`    | 'Male' \| 'Female' \| 'm' \| 'f' \| 0 \| 1 |    ✅    | Male     | Gender                         |
| `ethnicity` | string                                     |    ✅    | (Random) | Ethnicity                      |
| `height`    | number                                     |    ✅    |          | Height                         |
| `weight`    | number                                     |    ✅    |          | Weight                         |
| `hairColor` | string                                     |    ✅    |          | Hair Color                     |
| `eyeColor`  | string                                     |    ✅    |          | Eye Color                      |
| `address`   | string                                     |    ✅    |          | Address                        |

### Insert New Weapon

```lua
exports['bryan_snaily']:InsertNewWeapon(weaponHash, firstname, lastname)
```

| Paramater    | Type   | Optional | Default | Description                            |
| ------------ | ------ | :------: | ------- | -------------------------------------- |
| `weaponHash` | string |    ❌    |         | Weapon Hash (example: `WEAPON_PISTOL`) |
| `firstname`  | string |    ❌    |         | Owner's Firstname                      |
| `lastname`   | string |    ❌    |         | Owner's Lastname                       |

### Insert New Vehicle

```lua
exports['bryan_snaily']:InsertNewVehicle(plate, vehicleHash, firstname, lastname, color)
```

| Paramater     | Type   | Optional | Default | Description                      |
| ------------- | ------ | :------: | ------- | -------------------------------- |
| `plate`       | string |    ❌    |         | Plate                            |
| `vehicleHash` | string |    ❌    |         | Vehicle Hash (example: `blista`) |
| `firstname`   | string |    ❌    |         | Owner's Firstname                |
| `lastname`    | string |    ❌    |         | Owner's Lastname                 |
| `color`       | string |    ✅    |         | Vehicle Color                    |

> [!IMPORTANT]
> The vehicle hash has to be predefined in the CAD otherwise it will fail.

### Set License to Citizen

```lua
exports['bryan_snaily']:SetLicenseToCitizen(license, value, firstname, lastname)
```

| Paramater   | Type   | Optional | Default | Description                                                   |
| ----------- | ------ | :------: | ------- | ------------------------------------------------------------- |
| `license`   | string |    ❌    |         | License (`weaponLicense`/`driversLicense`/`pilotLicense`/...) |
| `value`     | string |    ❌    |         | License Value (example: `Valid`/`Suspended`/...)              |
| `firstname` | string |    ❌    |         | Character's Firstname                                         |
| `lastname`  | string |    ❌    |         | Character's Lastname                                          |





This is the main documentation for the Bryan Snaily CAD Integration.

For information on other scripts we support, please refer to the [Other Scripts We Support](other%20scripts%20we%20support.md) documentation 

--------------------------------------------------------------------------------------------------------------
#[Known issues](https://github.com/EWANZO101/Bryan-Snailycad-Integration-/blob/main/issues.errors.md)#

# Known issues with the inserts and this document will be updated soon #

## Integration


### ESX

<details><summary>Insert New Citizen</summary><br>

> esx_identity/server/main.lua

```lua
ESX.RegisterServerCallback('esx_identity:registerIdentity', function(source, cb, data)
    <...>

    local formattedFirstName = formatName(data.firstname)
    local formattedLastName = formatName(data.lastname)
    local formattedDate = formatDate(data.dateofbirth)

    data.firstname = formattedFirstName
    data.lastname = formattedLastName
    data.dateofbirth = formattedDate
    local Identity = {
        firstName = formattedFirstName,
        lastName = formattedLastName,
        dateOfBirth = formattedDate,
        sex = data.sex,
        height = data.height
    }

    -- Insert This Here --
    exports['bryan_snaily']:InsertNewCitizen(formattedFirstName, formattedLastName, formattedDate, data.sex, nil, data.height)
    --

    TriggerEvent('esx_identity:completedRegistration', source, data)
    TriggerClientEvent('esx_identity:setPlayerData', source, Identity)
    cb(true)
end)
```

</details>

<details><summary>Insert New Vehicle</summary><br>

> esx_vehicleshop/server/main.lua

```lua
ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function(source, cb, model, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local modelPrice = getVehicleFromModel(model).price

	if modelPrice and xPlayer.getMoney() >= modelPrice then
		xPlayer.removeMoney(modelPrice, "Vehicle Purchase")

		MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {xPlayer.identifier, plate, json.encode({model = joaat(model), plate = plate})
		}, function(rowsChanged)
			xPlayer.showNotification(TranslateCap('vehicle_belongs', plate))

            -- Insert This Here --
            exports['bryan_snaily']:InsertNewVehicle(plate, model, xPlayer.get('firstname'), xPlayer.get('lastname'))
            --

			ESX.OneSync.SpawnVehicle(joaat(model), Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading,{plate = plate}, function(vehicle)
				Wait(100)
				local vehicle = NetworkGetEntityFromNetworkId(vehicle)
				Wait(300)
				TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
			end)
			cb(true)
		end)
	else
		cb(false)
	end
end)
```

</details>

<details><summary>Insert New Weapon</summary><br>

> esx_weaponshop/server/main.lua

```lua
ESX.RegisterServerCallback('esx_weaponshop:buyWeapon', function(source, cb, weaponName, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = GetPrice(weaponName, zone)

	if price <= 0 then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to buy Invalid weapon - %s!'):format(source, weaponName))
		cb(false)
	else
		if xPlayer.hasWeapon(weaponName) then
			xPlayer.showNotification(TranslateCap('already_owned'))
			cb(false)
		else
			if zone == 'BlackWeashop' then
				if xPlayer.getAccount('black_money').money >= price then
					xPlayer.removeAccountMoney('black_money', price, "Black Weapons Deal")
					xPlayer.addWeapon(weaponName, 42)

                    -- Insert This Here --
                    exports['bryan_snaily']:InsertNewWeapon(weaponName, xPlayer.get('firstname'), xPlayer.get('lastname'))
                    --

					cb(true)
				else
					xPlayer.showNotification(TranslateCap('not_enough_black'))
					cb(false)
				end
			else
				if xPlayer.getMoney() >= price then
					xPlayer.removeMoney(price, "Weapons Deal")
					xPlayer.addWeapon(weaponName, 42)

                    -- Insert This Here --
                    exports['bryan_snaily']:InsertNewWeapon(weaponName, xPlayer.get('firstname'), xPlayer.get('lastname'))
                    --

					cb(true)
				else
					xPlayer.showNotification(TranslateCap('not_enough'))
					cb(false)
				end
			end
		end
	end
end)
```

</details>

### QB 

<details><summary>Insert New Citizen</summary><br>

> GO TO FILE qb-multicharacter/server/main.lua

```lua
RegisterNetEvent('qb-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    if QBCore.Player.Login(src, false, newData) then
        repeat
            Wait(10)
        until hasDonePreloading[src]

        -- Insert This Here --
        exports['bryan_snaily']:InsertNewCitizen(data.firstname, data.lastname, data.birthdate, data.gender)
        --

        <...>
    end
end)
```

</details>

<details><summary>Insert New Vehicle</summary><br>

> qb-vehicleshop/server.lua

```lua
RegisterNetEvent('qb-vehicleshop:server:buyShowroomVehicle', function(vehicle)
    <...>

    if cash > tonumber(vehiclePrice) then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            'pillboxgarage',
            0
        })
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.purchased'), 'success')
        TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')

        -- Insert This Here --
        exports['bryan_snaily']:InsertNewVehicle(plate, vehicle, pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
        --
    elseif bank > tonumber(vehiclePrice) then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            'pillboxgarage',
            0
        })
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.purchased'), 'success')
        TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')

        -- Insert This Here --
        exports['bryan_snaily']:InsertNewVehicle(plate, vehicle, pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
        --
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
    end
end)
```

</details>

<details><summary>Insert New Weapon (TBD)</summary><br>
</details>



## Support Us

If you appreciate our work and would like to contribute to future updates, your support is highly valued! You can make a donation through PayPal using the following link:

[![Donate with PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=L38V3QASQT3JN)

Your generosity helps us continue improving and delivering quality content. Thank you for being a part of our community!

