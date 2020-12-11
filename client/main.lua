ESX = nil

local menuIsShowed, hasAlreadyEnteredMarker, isInMarker = false, false, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('utx_nufus:kimlikmenu')
AddEventHandler('utx_nufus:kimlikmenu', function()
	OpenShowGiveID()
end)

AddEventHandler('utx_nufus:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.PedHash)
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", Config.PedHash, Config.PedKonum.x, Config.PedKonum.y, Config.PedKonum.z, Config.PedKonum.h, false, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_CHAIR_UPRIGHT", Config.PedKonum.x, Config.PedKonum.y, Config.PedKonum.z + 0.5, Config.PedKonum.h, -1, false, false)
end)

local sleep = 2000

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(sleep)
		perform = false
		local coords = GetEntityCoords(PlayerPedId())
		isInMarker = false

		local distance = GetDistanceBetweenCoords(coords, Config.PedKonum.x, Config.PedKonum.y, Config.PedKonum.z, true)

		if distance < 4 then
			perform = true
			isInMarker = true
			DrawText3D(Config.PedKonum.x, Config.PedKonum.y, Config.PedKonum.z + 2, Config.TextYazi)
		end

		if IsControlJustReleased(0, 38) and isInMarker and not menuIsShowed then
			KimlikMenu()
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('utx_nufus:hasExitedMarker')
		end

		if perform then
			sleep = 7
		elseif not perform then
			sleep = 2000
		end
	end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function KimlikMenu()
	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'kimlik',
	{
		title    = 'Nüfus Müdürlüğü',
		align    = 'top-left',
		elements = {
			{label = 'Kimliğini Temin Et <span style="color:green";>[500$]', value = 'kimlik_ver'},
			{label = 'İsmini/Soyismini Değiştir', value = 'isim_degistir'}
        }
	}, function(data, menu)

		if data.current.value == 'kimlik_ver' then
			menu.close()
			exports['mythic_progbar']:Progress({
				name = "utx_nufus:kimlikver",
				duration = 3250,
				label = 'Bilgileriniz Kontrol Ediliyor...',
				useWhileDead = false,
				canCancel = false,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "missheistdockssetup1clipboard@base",
					anim = "base",
					flags = 49,
				},
				prop = {
					model = "p_amb_clipboard_01",
					bone = 18905,
					coords = { x = 0.10, y = 0.02, z = 0.08 },
					rotation = { x = -80.0, y = 0.0, z = 0.0 },
				},
				propTwo = {
					model = "prop_pencil_01",
					bone = 58866,
					coords = { x = 0.12, y = 0.0, z = 0.001 },
					rotation = { x = -150.0, y = 0.0, z = 0.0 },
				},
			}, function(cancelled)
				if not cancelled then
					TriggerServerEvent('utx_nufus:kimlikver', 'kimlik', 1)
				else
					-- Do Something If Action Was Cancelled
				end
			end)
		elseif data.current.value == 'isim_degistir' then
			menu.close()
			IsimDegistir()
		end
    
        end,
        function(data, menu)
          menu.close()
        end)

end

function IsimDegistir()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'isim_degistirme',
        {
            title    = 'Nüfus Müdürlüğü',
			align   = 'top-left',
            elements = {
                {label = 'İsmini Değiştir <span style="color:green";>[10000$]', value = 'name'},
                {label = 'Soyismini Değiştir <span style="color:green";>[20000$]', value = 'lastname'},
            }
        },
        function(data, menu)
            if data.current.value == 'name' then
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'isim_degistirme2',
                    {
                        title = ('Yeni isminiz?'),
                    },
                    function(data3, menu3)
						menu3.close()
						exports['mythic_progbar']:Progress({
							name = "isim_degistirme2",
							duration = 10000,
							label = 'Yeni Bilgiler Giriliyor...',
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								animDict = "missheistdockssetup1clipboard@base",
								anim = "base",
								flags = 49,
							},
							prop = {
								model = "p_amb_clipboard_01",
								bone = 18905,
								coords = { x = 0.10, y = 0.02, z = 0.08 },
								rotation = { x = -80.0, y = 0.0, z = 0.0 },
							},
							propTwo = {
								model = "prop_pencil_01",
								bone = 58866,
								coords = { x = 0.12, y = 0.0, z = 0.001 },
								rotation = { x = -150.0, y = 0.0, z = 0.0 },
							},
						}, function(cancelled)
							if not cancelled then
								TriggerServerEvent('utx_nufus:isim', data3.value)
							else
								-- Do Something If Action Was Cancelled
							end
						end)
            end,
            function(data3, menu3)
                menu3.close()
            end)
			
            elseif data.current.value == 'lastname' then    
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'soyisim_degistirme',
                    {
                        title = ('Yeni soyisminiz?'),
                    },
                    function(data4, menu4)
						menu4.close()
						exports['mythic_progbar']:Progress({
							name = "soyisim_degistirme",
							duration = 10000,
							label = 'Yeni Bilgiler Giriliyor...',
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								animDict = "missheistdockssetup1clipboard@base",
								anim = "base",
								flags = 49,
							},
							prop = {
								model = "p_amb_clipboard_01",
								bone = 18905,
								coords = { x = 0.10, y = 0.02, z = 0.08 },
								rotation = { x = -80.0, y = 0.0, z = 0.0 },
							},
							propTwo = {
								model = "prop_pencil_01",
								bone = 58866,
								coords = { x = 0.12, y = 0.0, z = 0.001 },
								rotation = { x = -150.0, y = 0.0, z = 0.0 },
							},
						}, function(cancelled)
							if not cancelled then
								TriggerServerEvent('utx_nufus:soyisim', data4.value)
							else
								-- Do Something If Action Was Cancelled
							end
						end)
            end,
            function(data4, menu4)
                menu4.close()
			end)
			
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function OpenShowGiveID()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'id_card_menu',
		{
			title    = ('Kimlik Menüsü'),
			align    = 'right',
			elements = {
				{label = ('Kimliğine Bak'), value = 'check'},
				{label = ('Kimliğini Göster'), value = 'show'}
		}
	},
	function(data, menu)
		if data.current.value == 'check' then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
		elseif data.current.value == 'show' then
			local player, distance = ESX.Game.GetClosestPlayer()
  
			if distance ~= -1 and distance <= 3.0 then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
			else
				exports['mythic_notify']:SendAlert('inform', 'Yakında oyuncu yok!')
			end
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

if Config.Blip then
	Citizen.CreateThreadNow(function()
		local blip = AddBlipForCoord(Config.BlipKonum.x, Config.BlipKonum.y, Config.BlipKonum.z)

		SetBlipSprite (blip, Config.BlipSimgesi)
		SetBlipDisplay(blip, Config.BlipRengi)
		SetBlipScale  (blip, Config.BlipBoyutu)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(Config.BlipIsmi)
		EndTextCommandSetBlipName(blip)
	end)
end

-- Teleport olayı
positions = {
    {Config.BinaCikis, Config.BinaGiris, Config.BinaYazi},
}

Citizen.CreateThread(function ()
    while true do
		Citizen.Wait(sleep)
		perform = false
        local player = PlayerPedId()
        local playerLoc = GetEntityCoords(player)

        for _,location in ipairs(positions) do
            teleport_text = location[3]
            loc1 = {
                x=location[1][1],
                y=location[1][2],
                z=location[1][3],
                heading=location[1][3]
            }
            loc2 = {
                x=location[2][1],
                y=location[2][2],
                z=location[2][3],
                heading=location[2][3]
			}
			
			local distance = GetDistanceBetweenCoords(playerLoc, loc1.x, loc1.y, loc1.z, true)
			if distance < 4 then
				perform = true
				DrawText3D(loc1.x, loc1.y, loc1.z, teleport_text)
			end

			local distance2 = GetDistanceBetweenCoords(playerLoc, loc2.x, loc2.y, loc2.z, true)
			if distance2 < 4 then
				perform = true
				DrawText3D(loc2.x, loc2.y, loc2.z, teleport_text)
			end

            if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then 
                
                if IsControlJustReleased(1, 38) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                    else
                        SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(player, loc2.heading)
                    end
                end

            elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then

                if IsControlJustReleased(1, 38) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                    else
                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(player, loc1.heading)
                    end
                end
            end
		end
		if perform then
			sleep = 7
		elseif not perform then
			sleep = 2000
		end
    end
end)

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end
