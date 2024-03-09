FeatherMenu = exports['feather-menu'].initiate()
local BrewingMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
    top = '40%',
    left = '20%',
    ['720width'] = '500px',
    ['1080width'] = '600px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '900px',
    style = {
    },
    contentslot = {
        style = { --This style is what is currently making the content slot scoped and scrollable. If you delete this, it will make the content height dynamic to its inner content.
            ['width'] = '500px',
            ['height'] = '500px',
            ['min-height'] = '300px'
        }
    },
    draggable = true,
    canclose = true
})
local selected

function OpenStillMenu(id, stage, currentbrew)
    print(stage)
    if stage > 4 then
        stage = 4
    end
    local StillMenu = BrewingMenu:RegisterPage('first:page')
    StillMenu:RegisterElement('header', {
        value = _U('BrewMenu'),
        slot = "header",
        style = {}
    })
    StillMenu:RegisterElement('subheader', {
        value = _U('BrewDesc'),
        slot = "header",
        style = {}
    })
    StillMenu:RegisterElement('bottomline', {
        slot = "header",
    })
    if currentbrew ~= 'None' then
        TextDisplay1 = StillMenu:RegisterElement('textdisplay', {
            value = 'Current Brew: ' .. Config.Moonshines[currentbrew].label,
            style = {}

        })
    end
    TextDisplay5 = StillMenu:RegisterElement('textdisplay', {
        value = 'Stage: ' .. stage,
        style = {}

    })

    if stage > 4 then
        if Config.ShowIngredients.Menu then
            if currentbrew ~= 'None' then
                TextDisplay2 = StillMenu:RegisterElement('textdisplay', {
                    value = Config.Moonshines[currentbrew][stage].Tip,
                    style = {}
                })
            end
        elseif Config.ShowIngredients.Notify then
            TextDisplay3 = StillMenu:RegisterElement('textdisplay', {
                value = "Brewing Moonshine takes steps along the way, make sure to have your ingredients",
                style = {}
            })
        end
    end
    for k, value in pairs(Config.Moonshines) do
        if stage == 1 then
            StillMenu:RegisterElement('button', {
                label = 'Brew ' .. value.label,
                style = {
                },
            }, function()
                selected = k
                TriggerServerEvent('bcc-brewing:CheckIngredients', id, stage, selected)
                BrewingMenu:Close({ MenuOpen = false })
                -- This gets triggered whenever the button is clicked
            end)
            TextDisplay4 = StillMenu:RegisterElement('textdisplay', {
                value = Config.Moonshines[k][stage].Tip,
                style = {}
            })

            StillMenu:RegisterElement('line', {
                slot = "content",
                style = {}
            })
        end
    end


    if stage > 1 and stage < 4 then
        StillMenu:RegisterElement('button', {
            label = 'Continue Brewing ' .. Config.Moonshines[currentbrew].label,
            style = {
            },
        }, function()
            TriggerServerEvent('bcc-brewing:CheckIngredients', id, stage, currentbrew)
            BrewingMenu:Close({ MenuOpen = false })
            -- This gets triggered whenever the button is clicked
        end)
    end
    if stage == 4 then
        StillMenu:RegisterElement('button', {
            label = 'Collect Brew : ' .. ' ' .. Config.Moonshines[currentbrew].label,
            style = {
            },
        }, function()
            TriggerServerEvent('bcc-brewing:FinishBrewing', id, currentbrew, Config.Moonshines)
            BrewingMenu:Close({ MenuOpen = false })
            -- This gets triggered whenever the button is clicked
        end)
    end
    BrewingMenu:Open({
        cursorFocus = true,
        menuFocus = true,
        startupPage = StillMenu,
    })
end

function OpenMashMenu(id, stage, currentbrew)
    local MashMenu = BrewingMenu:RegisterPage('second:page')
    MashMenu:RegisterElement('header', {
        value = _U('BrewMenu'),
        slot = "header",
        style = {}
    })
    MashMenu:RegisterElement('subheader', {
        value = _U('BrewDesc'),
        slot = "header",
        style = {}
    })
    MashMenu:RegisterElement('bottomline', {
        slot = "header",
    })
    for k, value in pairs(Config.MashesandAlcohol) do
        if Config.ShowIngredients.Menu then
            TextDisplay = MashMenu:RegisterElement('textdisplay', {
                value = value[stage].Tip,
                style = {}
            })
        elseif Config.ShowIngredients.Notify then
            TextDisplay = MashMenu:RegisterElement('textdisplay', {
                value = "Brewing Mash is a singular stage",
                style = {}
            })
        end
        MashMenu:RegisterElement('button', {
            label = 'Brew ' .. value.label,
            style = {
            },
        }, function()
            selected = value.label
            TriggerServerEvent('bcc-brewing:CheckIngredients', id, nil, selected)
            BrewingMenu:Close()
            -- This gets triggered whenever the button is clicked
        end)
    end

    if stage == 3 then
        MashMenu:RegisterElement('button', {
            label = 'Collect Brew : ' .. ' ' .. Config.MashesandAlcohol[currentbrew].label,
            style = {
            },
        }, function()
            selected = value.label
            TriggerServerEvent('bcc-brewing:FinishBrewing', id, currentbrew, Config.MashesandAlcohol)
            BrewingMenu:Close()
            -- This gets triggered whenever the button is clicked
        end)
    end
    BrewingMenu:Open({
        cursorFocus = true,
        menuFocus = true,
        startupPage = MashMenu,
    })
end

RegisterNetEvent('FeatherMenu:closed', function(menudata)
    MenuOpen = false
    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())
end)
--[[
TriggerServerEvent('bcc-brewing:ChangeStage', id, -1, 1, currentbrew)
CloseMenu(menu)
Wait(Config.MashesandAlcohol[currentbrew].fermenttime * 60000)
TriggerServerEvent('bcc-brewing:ChangeStage', id, -1, 0, 'None')
]]
