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

function MenuRadio()
    RMenu.Add('radio_menu', 'main_menu', RageUI.CreateMenu("RADIO", "∑ Communiquez depuis la radio."))
    RMenu:Get('radio_menu', 'main_menu'):SetRectangleBanner(255, 10, 10, 200);
    RMenu:Get('radio_menu', 'main_menu').Closed = function()
        openRadioMenu = false
    end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

RegisterCommand('radio', function()
    if openRadioMenu then
        openRadioMenu = false
    else
        openRadioMenu = true
        MenuRadio()
        RageUI.Visible(RMenu:Get('radio_menu', 'main_menu'), true)
        Citizen.CreateThread(function()
            while openRadioMenu do
                Wait(1)
                RageUI.IsVisible(RMenu:Get('radio_menu', 'main_menu'), true, true, true, function()
                    if not Config.Active then
                        RageUI.Separator("Fréquence radio actuelle : ~b~Aucune");
                        RageUI.Separator("État de la radio : ~r~Désactivée");
                    else
                        RageUI.Separator("Fréquence radio actuelle : ~b~"..Config.frequencebase);
                        RageUI.Separator("État de la radio : ~g~Activée");
                        RageUI.Separator("Volume de la radio : ~b~"..Config.volume.base.."~s~/~b~100");
                    end
                    RageUI.Checkbox("Activer la radio", "Activez ou désactivez votre radio, configurez-la par la suite.", Config.Checked, {}, function(_,a,s,c)
                        if s then
                            Config.Checked = c
                            if c then
                                enableRadio();
                            else
                                disableRadio();
                            end
                        end
                    end)
                    if Config.Active then
                        RageUI.ButtonWithStyle("Fréquence customisée", "Entrez la fréquence souhaitée de votre radio.", { RightLabel = "→" }, true, function(_,a,s)
                            if s then
                                radioChannel = KeyboardInput("Numéro de la fréquence souhaitée de 16 à 2000 (ex : 100)", "", 4);
                                if radioChannel ~= nil then
                                    if tonumber(radioChannel) then
                                        if refuseConnectPrivateRadio(Config.notAccessibleRadios, tonumber(radioChannel)) then
                                            ESX.ShowNotification("~r~Les fréquences de 1 à 15 sont des fréquences privées, commencncez par la 16 au minimum.")
                                        else
                                            enableCustomFrequency(tonumber(radioChannel));
                                        end
                                    else
                                        return ESX.ShowNotification("~r~Merci d'entrer une fréquence radio correcte.");
                                    end
                                end
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Fréquence customisée", "~r~Vous devez activer votre radio pour entrez une fréquence customisée.", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_,a,s)
                        end)
                    end
                    if inTableRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name) then
                        Config.privatefrequence = true
                    end
                    if Config.privatefrequence then
                        RageUI.Separator("↓ ~r~Fréquences privées ~s~↓")
                        if Config.Active then
                            RageUI.ButtonWithStyle("[~y~"..ESX.PlayerData.job.label.."~s~] Radio #1", "Rejoignez la radio de travail #1.", { RightLabel = "→" }, true, function(_,a,s)
                                if s then
                                    if ESX.PlayerData.job.name == 'police' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 1, 1);
                                    end
                                    if ESX.PlayerData.job.name == 'ambulance' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 4, 1);
                                    end
                                    if ESX.PlayerData.job.name == 'mechanic' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 7, 1);
                                    end
                                    if ESX.PlayerData.job.name == 'bacars' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 10, 1);
                                    end
                                    if ESX.PlayerData.job.name == 'cardealer' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 13, 1);
                                    end
                                end
                            end)
                            RageUI.ButtonWithStyle("[~y~"..ESX.PlayerData.job.label.."~s~] Radio #2", "Rejoignez la radio de travail #2.", { RightLabel = "→" }, true, function(_,a,s)
                                if s then
                                    if ESX.PlayerData.job.name == 'police' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 2, 2);
                                    end
                                    if ESX.PlayerData.job.name == 'ambulance' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 5, 2);
                                    end
                                    if ESX.PlayerData.job.name == 'mechanic' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 8, 2);
                                    end
                                    if ESX.PlayerData.job.name == 'bacars' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 11, 2);
                                    end
                                    if ESX.PlayerData.job.name == 'cardealer' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 14, 2);
                                    end
                                end
                            end)
                            RageUI.ButtonWithStyle("[~y~"..ESX.PlayerData.job.label.."~s~] Radio #3", "Rejoignez la radio de travail #3.", { RightLabel = "→" }, true, function(_,a,s)
                                if s then
                                    if ESX.PlayerData.job.name == 'police' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 3, 3);
                                    end
                                    if ESX.PlayerData.job.name == 'ambulance' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 6, 3);
                                    end
                                    if ESX.PlayerData.job.name == 'mechanic' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 9, 3);
                                    end
                                    if ESX.PlayerData.job.name == 'bacars' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 12, 3);
                                    end
                                    if ESX.PlayerData.job.name == 'cardealer' then
                                        joinPrivateRadio(Config.jobsPrivateRadios, ESX.PlayerData.job.name, 15, 3);
                                    end
                                end
                            end)
                        else
                            RageUI.ButtonWithStyle("["..ESX.PlayerData.job.label.."] Radio #1", "Rejoignez la radio de travail #1.", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_,a,s)
                            end)
                            RageUI.ButtonWithStyle("["..ESX.PlayerData.job.label.."] Radio #2", "Rejoignez la radio de travail #2.", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_,a,s)
                            end)
                            RageUI.ButtonWithStyle("["..ESX.PlayerData.job.label.."] Radio #3", "Rejoignez la radio de travail #3.", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_,a,s)
                            end)
                        end
                    end
                end)
            end
        end)
    end
end, false)

