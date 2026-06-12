
local keyboardLayoutModule = {}
keyboardLayoutModule.showPopUp = true
keyboardLayoutModule.leftCmdLayout = "ABC"
keyboardLayoutModule.rightCmdLayout = "Russian"

keyboardLayoutModule.eventwatcher1 = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
    local flags = e:getFlags()

    if flags.cmd
        and not (flags.alt or flags.shift or flags.ctrl or flags.fn)
    then
        keyboardLayoutModule.cmdWasPressed = true
        keyboardLayoutModule.cmdShouldBeIgnored = false
        return false;
    end

    if flags.cmd
        and (flags.alt or flags.shift or flags.ctrl or flags.fn)
        and keyboardLayoutModule.cmdWasPressed
    then
        keyboardLayoutModule.cmdShouldBeIgnored = true
        return false;
    end

    if not flags.cmd
    then
        if keyboardLayoutModule.cmdWasPressed
            and not keyboardLayoutModule.cmdShouldBeIgnored
        then
            local keyCode = e:getKeyCode()

            if keyCode == 0x37 then
                hs.keycodes.setLayout(keyboardLayoutModule.leftCmdLayout)

                if keyboardLayoutModule.showPopUp then
                    --hs.alert.show("English", 0.2)
                end
            elseif keyCode == 0x36 then
                hs.keycodes.setLayout(keyboardLayoutModule.rightCmdLayout)

                if keyboardLayoutModule.showPopUp then
                    --hs.alert.show("Russian", 0.2)
                end
            end
        end

        keyboardLayoutModule.cmdWasPressed = false
        keyboardLayoutModule.cmdShouldBeIgnored = false
    end

    return false;
end):start()

keyboardLayoutModule.eventwatcher2 = hs.eventtap.new({ "all", hs.eventtap.event.types.flagsChanged }, function(e)
    local flags = e:getFlags()

    if flags.cmd and keyboardLayoutModule.cmdWasPressed then
        keyboardLayoutModule.cmdShouldBeIgnored = true
    end

    return false;
end):start()

-- Switch to English when VS Code is activated
-- application.watcher.new(function(appName, eventType, appObject)
--     if eventType == application.watcher.activated then
--         if (appName == "Code") then
--             hs.alert.show("VS Code", nil, nil, 1)
--             useEnglishLayout()
--         end
--     end
-- end):start()