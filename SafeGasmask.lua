script_name('[Samp-RP] SafeGasmask')
script_author('Isus_Christos')

local sampev = require('samp.events')
local inicfg = require('inicfg')

local isDead = false
local isGasmask = false
local isActiveSafe = false

local settingsSource = 'SafeGasMask.ini'
local settingsScript = inicfg.load({
    settings = {
        isActive = true,
        isNotification = true,
    }}, settingsSource)
inicfg.save(settingsScript, settingsSource)

local isActive = settingsScript.settings.isActive
local isNotification = settingsScript.settings.isNotification



function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    userNotification('C����� ������� �������� � ������ '..(isActive and '{A7FC00}�������. {ffffff}' or '{FF0000}��������. {ffffff}')..'����������� ������� - /sgm')
    userNotification('��������� ����������� - /sgm_notif. ���������� ������������ ��������� - /sgm_status')

    sampRegisterChatCommand('sgm', function()
        isActive = not isActive
        userNotification('������ ������� '..(isActive and '{A7FC00}�����������' or '{FF0000}�������������'))
        settingsScript.settings.isActive = isActive
        inicfg.save(settingsScript, settingsSource)
    end)

    sampRegisterChatCommand('sgm_notif', function()
        isNotification = not isNotification
        userNotification('����������� ������� ������ '..(isNotification and '����� {A7FC00}��������' or '{FF0000}���������'))
        settingsScript.settings.isNotification = isNotification
        inicfg.save(settingsScript, settingsSource)
    end)

    sampRegisterChatCommand('sgm_status', function()
        userNotification('������ ������ '..(isActive and '{A7FC00}�������. {ffffff}' or '{FF0000}��������. {ffffff}')..'����������� - '..(isNotification and
        '{A7FC00}��������' or '{FF0000}���������'))
    end)

    while true do
        wait(0)
        onUserDeath()
    end
end

function onUserDeath()
    if isCharDead(PLAYER_PED) and not isDead and isActive then
        lua_thread.create(function()
            isActiveSafe, isDead = true, true
            sampSendChat('/i')
            wait(400)
            if isGasmask and isNotification then
                userNotification('���������� ��� � ���������, ���������� �� ���������')
            elseif not isGasmask then
                sampSendChat('/gasmask')
                if isNotification then
                    userNotification('������ ��������, ���� ��� ����� ���������� - �� ����������')
                end
            end
            isGasmask = false
            wait(5000)
            isActiveSafe = false
        end)
    elseif not isCharDead(PLAYER_PED) and isDead then
        isDead = false
    end
end

function sampev.onShowTextDraw(id, data)
    if isActiveSafe then
        if data.modelId == 19472 then isGasmask = true end
        return false
    end
end

function userNotification(userNotificationText)
    sampAddChatMessage("[SafeGasmask] {FFFFFF}"..userNotificationText, 0x6495ED)
end