script_name('NoDrugs')
script_author('Isus_Christos')

local sampev = require('samp.events')
local inicfg = require('inicfg')

local settingsSource = 'NoDrugs.ini'
local settingsScript = inicfg.load({
    settings = {
        isActive = true,
    }}, settingsSource)
inicfg.save(settingsScript, settingsSource)

local isActive = settingsScript.settings.isActive

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    userNotification('Скрипт был успешно загружен. Для'..((isActive and ' выключения' or ' включения'))..' используйте команду - /lomka')

    sampRegisterChatCommand('lomka', function()
        isActive = not isActive
        userNotification('Режим спортика был успешно '..(isActive and '{A7FC00}активирован{ffffff}. Теперь ни одна травка Вас не возьмет' or '{FF0000}деактивирован{ffffff}. Теперь Вы - злоебучий наркоман'))
        settingsScript.settings.isActive = isActive
        inicfg.save(settingsScript, settingsSource)
    end)

end

function sampev.onApplyPlayerAnimation(id, _, animName)
    if isActive and (animName == 'crckdeth1' or 'crckdeth3' or 'crckidle3' or 'EAT_Burger') and id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
        return false
    end
end

function userNotification(userNotificationText)
    sampAddChatMessage("[NoDrugs] {FFFFFF}"..userNotificationText, 0x7442C8)
end