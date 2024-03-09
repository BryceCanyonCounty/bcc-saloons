Config = {}

Config.defaultlang = 'en'

Config.menu = 'vorp_menu'         --vorp_menu or menuapi

Config.InteractDistance = 1.0   -- Distance to interact with still
Config.SpawnDistance = 50.0     -- Distance that stills will spawn within
Config.GivePropsBack = true     -- True Get item back on destroy, false don't
Config.TimeToConstruct = 15     -- Time in seconds to place down the props
Config.DestroyTime = 15         -- Time in seconds to destroy the props
Config.ShowIngredients = {
    Tip = false,
    Menu = true
}

Config.Keys = {
    r = 0xE3BF959B,
    g = 0xA1ABB953,
    e = 0x41AC83D1
}

Config.Props = {
    barrel = 'p_barrelmoonshine', -- p_boxcar_barrel_09a
    still = 'mp001_p_mp_still02x',
}

Config.Jobs = { --Jobs that will just destroy still not pickup
    'police',
    'sheriff',
    'marshal'
}

Config.MashesandAlcohol = {
    ['alcohol'] = {
        label = 'Alcohol', -- Oude Label Teeling Poitin Mash
        AmountToBrew = 10,
        fermenttime = 10,
        ingredients = {
            ['water'] = 1,
            ['hop'] = 5,
        },
        Tip = 'You need 1 water and 5 hops'
    },
    ['mashblackberry'] = {
        label = 'Blackberry Mash', -- Oude Label Blinder Mash
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['alcohol'] = 2,
            ['emptybottle'] = 5,
            ['blackberry'] = 20,
            ['water'] = 5,
        },
        Tip = 'You need 2 Alcohol, 20 Blackberries, 5 Water and 5 empty bottles'
    },
    ['mashraspberry'] = {
        label = 'Raspberry Mash',  
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['alcohol'] = 2,
            ['emptybottle'] = 5,
            ['redraspberry'] = 20,
            ['water'] = 5,  
        },
        Tip = 'You need 2 Alcohol, 20 Red Raspberries, 5 Water and 5 empty bottles'
    },
    ['mashapple'] = {
        label = 'Apple Mash',  
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['alcohol'] = 2,
            ['emptybottle'] = 5,
            ['apple'] = 20,
            ['water'] = 5,  
        },
        Tip = 'You need 2 Alcohol, 20 Apples, 5 Water and 5 empty bottles'
    },
    ['mashpeach'] = {
        label = 'Peach Mash',  
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['alcohol'] = 2,
            ['emptybottle'] = 5,
            ['peach'] = 20,
            ['water'] = 5,  
        },
        Tip = 'You need 2 Alcohol, 20 Peaches, 5 Water and 5 empty bottles'
    },
    ['mashplum'] = {
        label = 'Creekplum Mash',  
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['alcohol'] = 2,
            ['emptybottle'] = 5,
            ['creekplum'] = 20,
            ['water'] = 5,  
        },
        Tip = 'You need 2 Alcohol, 20 Creekplums, 5 Water and 5 empty bottles'
    },
    ['mashblackberry90p'] = {
        label = 'Blackberry Mash 90p',  
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['alcohol'] = 4,
            ['emptybottle'] = 5,
            ['blackberry'] = 40,
            ['water'] = 5,  
        },
        Tip = 'You need 4 Alcohol, 40 Blackberries, 5 Water and 5 empty bottles'
    },
    ['mashraspberry90p'] = {
        label = 'Raspberry Mash 90p',  
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['alcohol'] = 4,
            ['emptybottle'] = 5,
            ['redraspberry'] = 40,
            ['water'] = 5,
        },
        Tip = 'You need 4 Alcohol, 40 Red Raspberries, 5 Water and 5 empty bottles'
    }
}

Config.Moonshines = {

    ['alcohol'] = {
        label = 'Alcohol',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last stage of brewing is, smoke will not be in the last stage ie no smoke for bottling
        [1] = {
            stilltime = 1,
            ingredients = {
                ['wheat'] = 2,
                ['consumable_orange'] = 2,
            },
            Tip = 'You need 2x Wheat, 2x Orange'
        },
        [2] = {
            stilltime = 1,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 1,
            ingredients = {
                ['bigbottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },
    ['moonshineblackberry'] = {
        label = 'Blackberry Moonshine',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last stage of brewing is, smoke will not be in the last stage ie no smoke for bottling
        [1] = {
            stilltime = 1,
            ingredients = {
                ['mashblackberry'] = 1,
                ['emptybottle'] = 15,
                ['sugar'] = 1,
            },
            Tip = 'You need 1x Blackberry Mash, 15x Empty Bottle, 1x Sugar'
        },
        [2] = {
            stilltime = 1,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 1,
            ingredients = {
                ['bigbottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },
    ['moonshineraspberry'] = {
        label = 'Raspberry Moonshine',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last stage of brewing is, smoke will not be in the last stage ie no smoke for bottling
        [1] = {
            stilltime = 1,
            ingredients = {
                ['mashraspberry'] = 1,
                ['emptybottle'] = 15,
                ['sugar'] = 1,
            },
            Tip = 'You need 1x Raspberry Mash, 15x Empty Bottle, 1x Sugar'
        },
        [2] = {
            stilltime = 1,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 1,
            ingredients = {
                ['bigbottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },
    ['moonshineapple'] = {
        label = 'Apple Moonshine',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last
        [1] = {
            stilltime = 1,
            ingredients = {
                ['mashapple'] = 1,
                ['emptybottle'] = 15,
                ['sugar'] = 1,
            },
            Tip = 'You need 1x Apple Mash, 15x Empty Bottle, 1x Sugar'
        },
        [2] = {
            stilltime = 1,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 1,
            ingredients = {
                ['bigbottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },
    ['moonshinepeach'] = {
        label = 'Peach Moonshine',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last
        [1] = {
            stilltime = 1,
            ingredients = {
                ['mashpeach'] = 1,
                ['emptybottle'] = 15,
                ['sugar'] = 1,
            },
            Tip = 'You need 1x Peach Mash, 15x Empty Bottle, 1x Sugar'
        },
        [2] = {
            stilltime = 1,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 1,
            ingredients = {
                ['bigbottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },
    ['moonshineplum'] = {
        label = 'Plum Moonshine',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last
        [1] = {
            stilltime = 1,
            ingredients = {
                ['mashplum'] = 1,
                ['emptybottle'] = 15,
                ['sugar'] = 1,
            },
            Tip = 'You need 1x Plum Mash, 15x Empty Bottle, 1x Sugar'
        },
        [2] = {
            stilltime = 1,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 1,
            ingredients = {
                ['bigbottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },
    ['moonshine'] = {
        label = 'Moonshine',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last
        [1] = {
            stilltime = 1,
            ingredients = {
                ['water'] = 1,

            },
            Tip = 'You need 1x Strong Mash Batch, 10x Empty Bottle, 1x Sugar'
        },
        [2] = {
            stilltime = 2,
            ingredients = {
                ['mashstrong'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 5,
            ingredients = {
                ['sugar'] = 2,
                ['emptybottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },
    ['moonshineblackberry90p'] = {
        label = 'Blackberry Moonshine 90p',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last
        [1] = {
            stilltime = 1,
            ingredients = {
                ['mashblackberry90p'] = 1,
                ['emptybottle'] = 10,
                ['sugar'] = 1,
            },
            Tip = 'You need 1x Blackberry Mash 90p, 10x Empty Bottle, 1x Sugar'
        },
        [2] = {
            stilltime = 1,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 1,
            ingredients = {
                ['bigbottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },
    ['moonshineraspberry90p'] = {
        label = 'Raspberry Moonshine 90p',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last
        [1] = {
            stilltime = 1,
            ingredients = {
                ['mashraspberry90p'] = 1,
                ['emptybottle'] = 10,
                ['sugar'] = 1,
            },
            Tip = 'You need 1x Raspberry Mash 90p, 10x Empty Bottle, 1x Sugar'
        },
        [2] = {
            stilltime = 1,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 1,
            ingredients = {
                ['bigbottle'] = 2,
            },
            Tip = 'You need 2x Big Bottle'
        },
    },

}


Config.WebhookInfo = {
    Title = 'BCC Stashes',
    -- Webhook =  '', Needed if using, the rest are optional
    -- Color = '',
    -- Name = '',
    -- Logo = '',
    -- FooterLogo = '',
    -- Avatar = '',
}


