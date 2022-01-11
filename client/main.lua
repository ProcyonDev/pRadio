ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.esx, function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

inTableRadio = function(table, item)
	for k,v in pairs(table) do
		if v.jobname == item then return k end
	end
	return false
end

inTableJoinPrivateRadio = function(table, item)
	for k,v in pairs(table) do
		if v.radio == item then return k end
	end
	return false
end

joinPrivateRadio = function(table, item, radio, radio2)
	for k,v in pairs(table) do
		if v.jobname == item then
            exports[Config.voice]:SetMumbleProperty("radioEnabled", true);
            exports[Config.voice]:SetRadioChannel(radio);
            exports[Config.voice]:addPlayerToRadio(radio);
            exports[Config.voice]:SetMumbleProperty("micClicks", true);
            Config.Radio.frequency = ESX.PlayerData.job.label.." ~s~(~b~Radio #"..radio2.."~s~)"
        return k end
	end
	return false
end

refuseConnectPrivateRadio = function(table, item)
	for k,v in pairs(table) do
		if v == item then
        return k end
	end
	return false
end

enableRadio = function()
    Config.Radio.radioActivate = true
    exports[Config.voice]:SetMumbleProperty("radioEnabled", true);
end

disableRadio = function()
    Config.Radio.radioActivate = false
    exports[Config.voice]:SetMumbleProperty("radioEnabled", false);
    exports[Config.voice]:SetRadioChannel(0);
    exports[Config.voice]:addPlayerToRadio(0)
    exports[Config.voice]:SetMumbleProperty("micClicks", false);
    Config.Radio.frequency = "Aucune"
end

enableCustomFrequency = function(channel)
    exports[Config.voice]:SetMumbleProperty("radioEnabled", true);
    exports[Config.voice]:SetRadioChannel(channel);
    exports[Config.voice]:addPlayerToRadio(channel);
    exports[Config.voice]:SetMumbleProperty("micClicks", true);
    Config.Radio.frequency = channel
end

changeRadioVolume = function(volume)
    exports[Config.voice]:setRadioVolume(volume);
    Config.Radio.volume = volume
end
