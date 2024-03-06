---@diagnostic disable: deprecated, undefined-field, lowercase-global, undefined-global, need-check-nil

----------------------------------------
                 --E--
----------------------------------------

local menus = {}
local functions = {}

local defaultTextColor = colors.black
local defaultBGColor = colors.lightGray

local menuSelected = nil
local boxFocus = nil
local objIncluded = false

function includeObj(include)
    objIncluded = include
end

function hasMenu(menuIndex)
    if menuIndex <= #menus then
        return true
    end
    return false
end

function func(name, func)
    functions[name] = func
end

function callFunction(name)
    if not functions[name] then
        error('Use gui.func("functionName", function) to set your function.')
    end

    functions[name]()
end

function createMenu()
    local index = #menus + 1
    menus[index] = {}
    if not menuSelected then
        menuSelected = menus[index]
    end

    if objIncluded then
        return index, menus[index]
    else
        return index
    end
end

function createButton(menuIndex, text, BGColor, pressedBGColor, func, posX, posY)
    local index = #menus[menuIndex] + 1

    menus[menuIndex][index] = {}

    menus[menuIndex][index].is = 0
    menus[menuIndex][index].text = text
    menus[menuIndex][index].textColor = nil
    menus[menuIndex][index].visible = true
    menus[menuIndex][index].BGColor = BGColor
    menus[menuIndex][index].pressedBGColor = pressedBGColor
    menus[menuIndex][index].pressed = false
    menus[menuIndex][index].posX = posX
    menus[menuIndex][index].posY = posY
    menus[menuIndex][index].endX = 0
    menus[menuIndex][index].func = func

    if objIncluded then
        return index, menus[menuIndex][index]
    else
        return index
    end
end

function createButtonTxtCol(menuIndex, text, textColor, BGColor, pressedBGColor, func, posX, posY)
    local index = #menus[menuIndex] + 1

    menus[menuIndex][index] = {}

    menus[menuIndex][index].is = 0
    menus[menuIndex][index].text = text
    menus[menuIndex][index].textColor = textColor
    menus[menuIndex][index].visible = true
    menus[menuIndex][index].BGColor = BGColor
    menus[menuIndex][index].pressedBGColor = pressedBGColor
    menus[menuIndex][index].pressed = false
    menus[menuIndex][index].posX = posX
    menus[menuIndex][index].posY = posY
    menus[menuIndex][index].endX = 0
    menus[menuIndex][index].func = func

    if objIncluded then
        return index, menus[menuIndex][index]
    else
        return index
    end
end

function createLabel(menuIndex, visible, text, textColor, BGColor, posX, posY)
    local index = #menus[menuIndex] + 1

    menus[menuIndex][index] = {}

    menus[menuIndex][index].is = 1
    menus[menuIndex][index].visible = visible
    menus[menuIndex][index].text = text
    menus[menuIndex][index].textColor = textColor
    menus[menuIndex][index].BGColor = BGColor
    menus[menuIndex][index].posX = posX
    menus[menuIndex][index].posY = posY

    if objIncluded then
        return index, menus[menuIndex][index]
    else
        return index
    end
end

function createPanel(menuIndex, BGColor, startX, startY, endX, endY)
    local index = #menus[menuIndex] + 1

    menus[menuIndex][index] = {}

    menus[menuIndex][index].is = 2
    menus[menuIndex][index].visible = true
    menus[menuIndex][index].BGColor = BGColor
    menus[menuIndex][index].startX = startX
    menus[menuIndex][index].startY = startY
    menus[menuIndex][index].endX = endX
    menus[menuIndex][index].endY = endY

    if objIncluded then
        return index, menus[menuIndex][index]
    else
        return index
    end
end

function createPanelFromCenter(menuIndex, BGColor, posX, posY, left, right, up, down)
    local index = #menus[menuIndex] + 1

    menus[menuIndex][index] = {}

    menus[menuIndex][index].is = 2
    menus[menuIndex][index].visible = true
    menus[menuIndex][index].BGColor = BGColor
    menus[menuIndex][index].startX = posX - left
    menus[menuIndex][index].startY = posY - up
    menus[menuIndex][index].endX = posX + right
    menus[menuIndex][index].endY = posY + down

    if objIncluded then
        return index, menus[menuIndex][index]
    else
        return index
    end
end

function createTextbox(menuIndex, length, BGColor, textColor, placeholder, placeholderColor, posX, posY)
    local index = #menus[menuIndex] + 1

    menus[menuIndex][index] = {}

    menus[menuIndex][index].is = 3
    menus[menuIndex][index].visible = true
    menus[menuIndex][index].length = length
    menus[menuIndex][index].text = ""
    menus[menuIndex][index].textColor = textColor
    menus[menuIndex][index].placeholder = placeholder
    menus[menuIndex][index].placeholderColor = placeholderColor
    menus[menuIndex][index].BGColor = BGColor
    menus[menuIndex][index].posX = posX
    menus[menuIndex][index].posY = posY
    menus[menuIndex][index].endX = 0

    if objIncluded then
        return index, menus[menuIndex][index]
    else
        return index
    end
end

function switch(menuIndex)
    menuSelected = menus[menuIndex]
end

function setVisible(menuIndex, elementIndex, visible)
    menus[menuIndex][elementIndex].visible = visible
end

function getVisible(menuIndex, elementIndex)
    return menus[menuIndex][elementIndex].visible
end

function getObj(menuIndex, elementIndex)
    return menus[menuIndex][elementIndex]
end

-----------------------------------------

local drawUpdate = false

function drawUI()
    local termX, termY = term.getSize()
    term.setBackgroundColor(defaultBGColor)
    term.clear()
    term.setCursorBlink(false)
    for index = 1, #menuSelected, 1 do
        local ref = menuSelected[index]
        
        if ref.visible then
            if ref.posX == -1 then

                if ref.text then
                    ref.posX = termX / 2 - (#ref.text + 1) / 2
                else
                    ref.posX = termX / 2
                end

                if ref.is == 2 then
                    ref.startX = posX - left
                    ref.startY = posY - up
                    ref.endX = posX + right
                    ref.endY = posY + down
                end
            end
            
            if ref.posY == -1 then
                ref.posY = termY / 2

                if ref.is == 2 then
                    ref.startX = posX - left
                    ref.startY = posY - up
                    ref.endX = posX + right
                    ref.endY = posY + down
                end
            end
            
            if ref.is == 0 then

                if ref.textColor then
                    term.setTextColor(ref.textColor)
                else
                    term.setTextColor(defaultTextColor)
                end
                
                if #ref.text % 2 == 0 then
                    ref.endX = ref.posX + 2 + #ref.text
                else
                    ref.endX = ref.posX + 1 + #ref.text
                end

                if ref.pressed then
                    ref.pressed = false
                    term.setBackgroundColor(ref.pressedBGColor)
                else
                    term.setBackgroundColor(ref.BGColor)
                end
            
                term.setCursorPos(ref.posX, ref.posY)
                term.write(" "..ref.text.." ")
                
            elseif ref.is == 1 then

                term.setTextColor(ref.textColor)
                term.setBackgroundColor(ref.BGColor)
                term.setCursorPos(ref.posX, ref.posY)
                term.write(" "..ref.text.." ")

            elseif ref.is == 2 then

                paintutils.drawFilledBox(ref.startX, ref.startY, ref.endX, ref.endY, ref.BGColor)

            elseif ref.is == 3 then

                ref.endX = ref.posX + 2
                term.setBackgroundColor(ref.BGColor)
                paintutils.drawFilledBox(ref.posX - ref.length / 2, ref.posY - 1, ref.endX + ref.length / 2, ref.posY + 1, ref.BGColor)
                term.setCursorPos(ref.posX - ref.length / 2, ref.posY)
                
                if boxFocus ~= ref and #ref.text == 0 then
                    term.setTextColor(ref.placeholderColor)
                    term.write(" "..ref.placeholder.." ")
                else
                    term.setTextColor(ref.textColor)
                    term.write(" ")
                    if boxFocus == ref then
                        term.write(ref.text.."_")
                    else
                        term.write(ref.text)
                    end
                end
                
            end
        end
    end
end

function boxFocusLoop()
    while true do
        local e, key = os.pullEvent()
        
        if boxFocus then
            if #boxFocus.text < boxFocus.length then
                
                if e == "key" and key == 257 then
                    boxFocus = nil
                    drawUI()
                elseif e == "key" and key == 259 then 
                    local got = string.sub(boxFocus.text, 1, #boxFocus.text - 1)
                    if got then
                        boxFocus.text = got
                        drawUI()
                    end
                elseif e == "char" then
                    boxFocus.text = boxFocus.text..string.lower(key)
                    drawUI()
                end
            else
                if e == "key" and key == 259 then
                    local got = string.sub(boxFocus.text, 1, #boxFocus.text - 1)
                    if got then
                        boxFocus.text = got
                        drawUI()
                    end
                end
            end
        end
    end
end

function clickedMouse(x, y)
    for index = 1, #menuSelected do
        local ref = menuSelected[index]
        
        if not ref then
            return
        end
        
        if ref.is == 0 then
            if #ref.text % 2 == 0 then
                if x >= ref.posX and x < ref.endX and y == ref.posY then
                    boxFocus = nil
                    ref.pressed = true
                    drawUI()
                    sleep(0.2)
                    if ref.func and ref.func ~= "" then
                        callFunction(ref.func)
                    end
                    drawUpdate = true
                    return
                end
            else
                if x >= ref.posX - 1 and x < ref.endX and y == ref.posY then
                    boxFocus = nil
                    ref.pressed = true
                    drawUI()
                    sleep(0.2)
                    if ref.func and ref.func ~= "" then
                        callFunction(ref.func)
                    end
                    drawUpdate = true
                    return
                end
            end
        elseif ref.is == 3 then
            if #ref.text % 2 == 0 then
                if x >= ref.posX - 1 - ref.length / 2 and x < ref.endX + 1 + ref.length / 2 and y >= ref.posY - 1 and y <= ref.posY + 1 then
                    boxFocus = ref
                    drawUpdate = true
                    return
                elseif boxFocus and boxFocus == ref then
                    boxFocus = nil
                    drawUpdate = true
                    return
                end
            else
                if x >= ref.posX - ref.length / 2 and x < ref.endX + ref.length / 2 and y >= ref.posY - 1 and y <= ref.posY + 1 then
                    boxFocus = ref
                    drawUpdate = true
                    return
                elseif boxFocus and boxFocus == ref then
                    boxFocus = nil
                    drawUpdate = true
                    return
                end
            end
        end
    end
end

function update()
    drawUI()
end

function setBGColor(bgColor)
    defaultBGColor = bgColor
end

function setTextColor(txtColor)
    defaultTextColor = txtColor
end

function guiLoop()
    drawUI()
    while true do

        if drawUpdate then
            drawUpdate = false
            drawUI()
        end

        local e, is, xpos, ypos = os.pullEvent("mouse_click")
        if is == 1 then -- Left click
            clickedMouse(xpos, ypos)
        end
    end
end

function start()
    if not menuSelected then
        error("No menu selected. Create one or set the selected menu.")
    end

    parallel.waitForAny(guiLoop, boxFocusLoop)
end

return {start=start, createMenu=createMenu, includeObj=includeObj, hasMenu=hasMenu, func=func, getObj=getObj, setVisible=setVisible, getVisible=getVisible, update=update, setBGColor=setBGColor, setTextColor=setTextColor, switch=switch, createPanel=createPanel, createPanelFromCenter=createPanelFromCenter, createLabel=createLabel, createButton=createButton, createButtonTxtCol=createButtonTxtCol, createTextbox=createTextbox}
