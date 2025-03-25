script_name('Launcher Emulator')
script_author('Isus_Christos')

local sampev = require('lib.samp.events')
local inicfg = require('inicfg')
local dlstatus = require('moonloader').download_status

local settingsSource = 'Launcher Emulator.ini'
local settingsScript = inicfg.load({
    settings = {
        isActive = true,
        carID = 579
    }}, settingsSource)
inicfg.save(settingsScript, settingsSource)

local isActive = settingsScript.settings.isActive
local carID = settingsScript.settings.carID

updateState = false;

local scriptVersion = 5
local scriptVersionText = '1.04'

local updateSource = "https://raw.githubusercontent.com/meinhard-ru/scripts/refs/heads/main/Launcher_Emulator_Update.ini"
local updatePath = getWorkingDirectory() .. "Launcher_Emulator_Update.ini"

local scriptSource = "https://github.com/meinhard-ru/scripts/raw/refs/heads/main/Launcher_Emulator.lua"
local scriptPath = thisScript().path

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

	downloadUrlToFile(updateSource, updatePath, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            UpdateIni = inicfg.load(nil, updatePath)
            if tonumber(UpdateIni.version.Version) > scriptVersion then
                userNotification("Есть обновление! Текущая версия - {FF0000}"..scriptVersionText.."{ffffff}. Доступная версия - {A7FC00}"..UpdateIni.version.VersionText)
                updateState = true
            end
            os.remove(updatePath)
        end
    end)

    userNotification('Эмулятор '..(isActive and '{A7FC00}включен. {ffffff}' or '{FF0000}выключен. {ffffff}')..'ID неучтенной машины - \'{A7FC00}'..
    carID..'{FFFFFF}\'. Команды: /emul, /emul_car')

    sampRegisterChatCommand('emul', function()
        isActive = not isActive
        userNotification('Скрипт теперь '..(isActive and '{A7FC00}включен' or '{FF0000}выключен'))
        settingsScript.settings.isActive = isActive
        inicfg.save(settingsScript, settingsSource)
    end)

    sampRegisterChatCommand('emul_car', function(id)
        if id == nil or not tonumber(id) then
            userNotification('Введите после команды существующий ID неучтенного автомобиля. Пример: /emul_car 411')
            return false
        end

        id = tonumber(id)
        if id < 400 or id > 611 then
            userNotification('Указанный ID не существует, введите существующий ID автомобиля (из оригинальной gta_sa)')
            return false
        else
            carID = id
            settingsScript.settings.carID = carID
            inicfg.save(settingsScript, settingsSource)
            userNotification('ID неучтенного кастомного автомобиля изменен на \'{A7FC00}'..carID..'{FFFFFF}\'')
        end
    end)

	while true do
		wait(0)

		if updateState then
            downloadUrlToFile(scriptSource, scriptPath, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    userNotification("Скрипт успешно обновлен до версии "..UpdateIni.version.VersionText..". Приятного пользования!")
                    thisScript():reload()
                end
            end)
        end
	end
end

function sampev.onSendClientJoin(version, mod, nickname, challengeResponse, joinAuthKey, clientVer, challengeResponse2)
	clientVer = 'SRP-1.0.0'
	return {version, mod, nickname, challengeResponse, joinAuthKey, clientVer, challengeResponse2}
end

function sampev.onVehicleStreamIn(id, data)
    if data.type < 400 or data.type > 611 then
		if launcherCars[data.type] then
			data.type = launcherCars[data.type]
			return{id, data}
		else
			data.type = carID
			return{id, data}
		end
	end
end

function userNotification(userNotificationText)
    sampAddChatMessage("[Launcher Emulator]: {FFFFFF}"..userNotificationText, 0xFF4040)
end

launcherCars = {
	[13891] = 579,
	[13892] = 402,
	[13893] = 405,
	[13894] = 445,
	[13895] = 579,
	[13896] = 560,
	[13897] = 506,
	[13898] = 411,
	[13899] = 429,
	[13900] = 451,
	[13901] = 470,
	[13902] = 470,
	[13903] = 579,
	[13904] = 507,
	[13905] = 579,
	[13906] = 579,
	[13907] = 477,
	[13908] = 419,
	[13909] = 426,
	[13910] = 480,
	[13911] = 550,
	[13912] = 458,
	[13913] = 410,
	[13914] = 547,
	[13915] = 529,
	[13916] = 602,
	[13917] = 424,
	[13918] = 542,
	[13919] = 415,
	[13920] = 411,
	[13921] = 400,
	[13922] = 545,
	[13923] = 422,
	[13924] = 470,
	[13925] = 540,
	[13926] = 409,
	[13927] = 418,
	[13928] = 588,
	[13929] = 402,
	[13930] = 405,
	[13931] = 541,
	[13932] = 579,
	[13933] = 516,
	[13934] = 579,
	[13935] = 579,
	[13936] = 421,
	[13937] = 558,
	[13938] = 561,
	[13939] = 551,
	[13940] = 579,
	[13941] = 426,
	[13942] = 426,
	[13943] = 402,
	[13944] = 579,
	[13945] = 490,
	[13946] = 560,
	[13947] = 560,
	[13948] = 429,
	[13949] = 589,
	[13950] = 559,
	[13951] = 562,
	[13952] = 579,
	[13953] = 426,
	[13954] = 579,
	[13955] = 587,
	[13956] = 560,
	[13957] = 494,
	[13958] = 565,
	[13959] = 560,
	[13960] = 445,
	[13961] = 426,
	[13962] = 579,
	[13963] = 426,
	[13964] = 579,
	[13965] = 426,
}