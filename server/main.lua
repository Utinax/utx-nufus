ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('utx_nufus:kimlikver')
AddEventHandler('utx_nufus:kimlikver', function(item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	if xPlayer.getInventoryItem('kimlik').count > 0 then
		xPlayer.showNotification('Kimliğinizi zaten temin etmişsiniz!')
	elseif money > 0 then
		xPlayer.removeMoney(Config.Ucret)
		Citizen.Wait(250)
		xPlayer.addInventoryItem(item, count)
		xPlayer.showNotification('Kimliğiniz şahsınıza tahsis edildi!')
	else
		xPlayer.showNotification('Üzerinizde yeterli para yok!')
	end
end)

RegisterServerEvent('utx_nufus:isim')
AddEventHandler('utx_nufus:isim', function(firstname)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 10000) then
		xPlayer.removeMoney(10000)
		
        MySQL.Async.execute('UPDATE users SET firstname = @firstname WHERE identifier = @identifier', {
            ['@firstname'] = firstname,
            ['@identifier'] = xPlayer.identifier
        })
        xPlayer.showNotification("Yeni isminiz: ".. firstname)
        if xPlayer.getInventoryItem('kimlik').count > 0 then
			xPlayer.removeInventoryItem('kimlik', 1)
			xPlayer.showNotification("İsim değişikliğinden dolayı yeni bir kimlik almanız gerekecek, eskisi kaldırıldı.")
		end
	else
		xPlayer.showNotification("Yeterli paranız yok.")
	end
end)

RegisterServerEvent('utx_nufus:soyisim')
AddEventHandler('utx_nufus:soyisim', function(lastname)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 20000) then
		xPlayer.removeMoney(20000)
		
		MySQL.Async.execute('UPDATE users SET lastname = @lastname WHERE identifier = @identifier', {
			['@lastname'] = lastname,
			['@identifier'] = xPlayer.identifier
		})
		xPlayer.showNotification("Yeni soyisminiz: ".. lastname)
		if xPlayer.getInventoryItem('kimlik').count > 0 then
			xPlayer.removeInventoryItem('kimlik', 1)
			xPlayer.showNotification("Soyisim değişikliğinden dolayı yeni bir kimlik almanız gerekecek, eskisi kaldırıldı.")
		end
	else
		xPlayer.showNotification("Yeterli paranız yok.")
	end
end)

ESX.RegisterUsableItem('kimlik', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('utx_nufus:kimlikmenu', source);
end)
