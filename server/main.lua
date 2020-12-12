ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('utx-nufus:kimlikver')
AddEventHandler('utx-nufus:kimlikver', function(item, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = xPlayer.getMoney()
	if xPlayer.getInventoryItem('kimlik').count > 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Kimliğiniz zaten temin etmişsiniz!'} )
	elseif money > 0 then
		xPlayer.removeMoney(Config.Ucret)
		Citizen.Wait(250)
		xPlayer.addInventoryItem(item, count)
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Kimliğiniz şahsınıza tahsis edildi!'} )
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Üzerinizde yeterli para yok!'} )
	end
end)

RegisterServerEvent('utx-nufus:isim')
AddEventHandler('utx-nufus:isim', function(firstname)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= Config.IsimUcret) then
		xPlayer.removeMoney(Config.IsimUcret)
		
        MySQL.Async.execute('UPDATE users SET firstname = @firstname WHERE identifier = @identifier', {
            ['@firstname'] = firstname,
            ['@identifier'] = xPlayer.identifier
        })
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Yeni isminiz: '.. firstname} )
        if xPlayer.getInventoryItem('kimlik').count > 0 then
			xPlayer.removeInventoryItem('kimlik', 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'İsim değişikliğinden dolayı yeni bir kimlik almanız gerekecek, eskisi kaldırıldı.'} )
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Yeterli paranız yok.'} )
	end
end)

RegisterServerEvent('utx-nufus:soyisim')
AddEventHandler('utx-nufus:soyisim', function(lastname)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= Config.SoyisimUcret) then
		xPlayer.removeMoney(Config.SoyisimUcret)
		
		MySQL.Async.execute('UPDATE users SET lastname = @lastname WHERE identifier = @identifier', {
			['@lastname'] = lastname,
			['@identifier'] = xPlayer.identifier
		})
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Yeni soyisminiz: '.. lastname} )
		if xPlayer.getInventoryItem('kimlik').count > 0 then
			xPlayer.removeInventoryItem('kimlik', 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'YSoyisim değişikliğinden dolayı yeni bir kimlik almanız gerekecek, eskisi kaldırıldı.'} )
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Yeterli paranız yok.'} )
	end
end)

ESX.RegisterUsableItem('kimlik', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('utx-nufus:kimlikmenu', source);
end)
