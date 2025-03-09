script_name('[Samp-RP] AdBlock')
script_author('Isus_Christos')

local inicfg = require('inicfg')
local sampev = require('samp.events')
local imgui = require('mimgui')

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

local settingsSource = 'Samp-RP AdBlock.ini'
local settingsScript = inicfg.load({
    settings = {
        isActive = false,
        isNews = false,
        isAdmins = false,
        isEvent = false,
        isEvents = false,
        isGov = false,
        isSquad = false
    }}, settingsSource)
inicfg.save(settingsScript, settingsSource)

local isActive = imgui.new.bool(settingsScript.settings.isActive)
local isNews = imgui.new.bool(settingsScript.settings.isNews)
local isAdmins = imgui.new.bool(settingsScript.settings.isAdmins)
local isEvent = imgui.new.bool(settingsScript.settings.isEvent)
local isEvents = imgui.new.bool(settingsScript.settings.isEvents)
local isGov = imgui.new.bool(settingsScript.settings.isGov)
local isSquad = imgui.new.bool(settingsScript.settings.isSquad)
local WinState = imgui.new.bool(false)

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500,500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(465,200), imgui.Cond.Always)
    imgui.Begin('Samp-RP AdBlock', WinState, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse)
    SoftBlueTheme()

    if isActive[0] then
        imgui.SetCursorPosX((imgui.GetWindowWidth() - 165) / 2)
    else
        imgui.SetCursorPosX((imgui.GetWindowWidth() - 165) / 2)
        imgui.SetCursorPosY((imgui.GetWindowHeight() - 15) / 2)
    end

    if imgui.Checkbox(u8'Активация скрипта', isActive) then
        settingsScript.settings.isActive = isActive[0]
        inicfg.save(settingsScript, settingsSource)
    end

    if isActive[0] then
        if imgui.Checkbox(u8'Блокировка объявлений', isNews) then 
            settingsScript.settings.isNews = isNews[0]
            inicfg.save(settingsScript, settingsSource)
        end
        imgui.SameLine(250)
        if imgui.Checkbox(u8'Блокировка входов сквада', isSquad) then 
            settingsScript.settings.isSquad = isSquad[0]
            inicfg.save(settingsScript, settingsSource)
        end

        if imgui.Checkbox(u8'Блокировка действий админов', isAdmins) then 
            settingsScript.settings.isAdmins = isAdmins[0]
            inicfg.save(settingsScript, settingsSource)
        end
        imgui.SameLine(250)
        if imgui.Checkbox(u8'Блокировка Event Team', isEvent) then 
            settingsScript.settings.isEvent = isEvent[0]
            inicfg.save(settingsScript, settingsSource)
        end

        if imgui.Checkbox(u8'Блокировка мероприятий', isEvents) then 
            settingsScript.settings.isEvents = isEvents[0]
            inicfg.save(settingsScript, settingsSource)
        end
        imgui.SameLine(250)
        if imgui.Checkbox(u8'Блокировка гос.волны', isGov) then 
            settingsScript.settings.isGov = isGov[0]
            inicfg.save(settingsScript, settingsSource)
        end

    end
end)

local blockMessage = {
    ['news'] = '.+Объявление:.+%. Присла',
    ['newsEditor'] = 'Редакция News',
    ['admins'] = 'Администратор:',
    ['event'] = '%[Event%]',
    ['events'] = '%[Центр развлечений%]',
    ['gov'] = 'Новости:',
    ['govStart'] = '-----------=== Государственные Новости ===-----------',
    ['squad'] = '%[Сообщество%]',
}

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    userNotification('Блокировщик рекламы загружен. Открыть меню настроек - /adblock')
    
    sampRegisterChatCommand('adblock', function()
        WinState[0] = not WinState[0]
    end)
end

function sampev.onServerMessage(color, message)
    if isActive[0] then
        if message:find(blockMessage.news) and isNews[0] or message:find(blockMessage.newsEditor) and isNews[0] or message:find(blockMessage.admins) and isAdmins[0] or
        message:find(blockMessage.event) and isEvent[0] or message:find(blockMessage.events) and isEvents[0] or message:find(blockMessage.gov) and isGov[0] or
        message:find(blockMessage.govStart) and isGov[0] or message:find(blockMessage.squad) and isSquad[0] then
            return false
        end
    end
end

function userNotification(userNotificationText)
    sampAddChatMessage("[Samp-RP]{DDA0DD} AdBlock: {FFFFFF}"..userNotificationText, 0x9966CC)
end

function SoftBlueTheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    style.WindowPadding = imgui.ImVec2(15, 15)
    style.WindowRounding = 10.0
    style.ChildRounding = 6.0
    style.FramePadding = imgui.ImVec2(8, 7)
    style.FrameRounding = 8.0
    style.ItemSpacing = imgui.ImVec2(8, 8)
    style.ItemInnerSpacing = imgui.ImVec2(10, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 12.0
    style.GrabMinSize = 10.0
    style.GrabRounding = 6.0
    style.PopupRounding = 8
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.90, 0.90, 0.93, 1.00)
    style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
    style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
    style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.18, 0.20, 0.22, 0.30)
    style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.13, 0.13, 0.15, 1.00)
    style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.30, 0.30, 0.35, 1.00)
    style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
    style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
    style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.15, 0.17, 1.00)
    style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.10, 0.10, 0.12, 1.00)
    style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.15, 0.15, 0.17, 1.00)
    style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
    style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
    style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.35, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
    style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.70, 0.70, 0.90, 1.00)
    style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.70, 0.70, 0.90, 1.00)
    style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.80, 0.80, 0.90, 1.00)
    style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
    style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.60, 0.60, 0.90, 1.00)
    style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.28, 0.56, 0.96, 1.00)
    style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.20, 0.20, 0.23, 1.00)
    style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
    style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
    style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
    style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.60, 0.60, 0.65, 1.00)
    style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.20, 0.20, 0.23, 1.00)
    style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
    style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.64, 1.00)
    style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)
    style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.61, 0.61, 0.64, 1.00)
    style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)
    style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
    style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.10, 0.10, 0.12, 0.80)
    style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.18, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.60, 0.60, 0.90, 1.00)
    style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.28, 0.56, 0.96, 1.00)
end