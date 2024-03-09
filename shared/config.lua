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
    ['ApplePieMash'] = {
        label = 'Apple Mash', -- Oude Label Teeling Poitin Mash
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['Alcohol'] = 1,
            ['consumable_apple'] = 1,
        },
        Tip = 'You need 5 Water, 20 Blackberries, 5 Empty Bottles and 2 Alcohol'
    },
    ['BlueberryMash'] = {
        label = 'Blueberry Mash', -- Oude Label Teeling Poitin Mash
        AmountToBrew = 5,
        fermenttime = 10,
        ingredients = {
            ['alcohol'] = 2,
            ['emptybottle'] = 5,
        },
        Tip = 'You need 5 Water, 20 Blackberries, 5 Empty Bottles and 2 Alcohol'
    },

}

Config.Moonshines = {
    ['alcohol'] = {
        label = 'Alcohol',
        AmountToBrew = 2,
        LastStage = 3, -- This must be set to whatever your last stage of brewing is, smoke will not be in the last stage ie no smoke for bottling
        [1] = {
            stilltime = 1,
            ingredients = {
                ['water'] = 1,
            },
            Tip = 'You need 1x Water'
        },
        [2] = {
            stilltime = 3,
            ingredients = {
                ['sugarcube'] = 1,
            },
            Tip = 'You need 1x Sugarcube'
        },
        [3] = {
            stilltime = 6,
            ingredients = {
                ['hop'] = 5,
            },
            Tip = 'You need 5x hop'
        },
    },
    ['BlackberryMoonshine'] = {
        label = 'Blackberry Moonshine',
        AmountToBrew = 15,
        LastStage = 3,
        [1] = {
            stilltime = 1,
            ingredients = {

                ['Water'] = 1,


            },
            Tip = 'You need 1x Water'
        },
        [2] = {
            stilltime = 3,
            ingredients = {

                ['BlackberryMash'] = 1,
                ['Sugar'] = 1,
            },
            Tip = 'You need 1x Blackberry Mash and 1x Sugar'
        },
        [3] = {
            stilltime = 6,
            ingredients = {

                ['GlassBottles'] = 15,
            },
            Tip = 'You need 15x Empty Bottles'
        },
    },
  
    ['ApplePieMoonshine'] = {
        label = 'Apple Moonshine',
        AmountToBrew = 5,
        LastStage = 3,
        [1] = {
            stilltime = 1,
            ingredients = {

                ['Water'] = 1,


            },
            Tip = 'You need 1x Water'
        },
        [2] = {
            stilltime = 3,
            ingredients = {

                ['BlackberryMash'] = 1,
                ['Sugar'] = 1,
            },
            Tip = 'You need 1x Blackberry Mash and 1x Sugar'
        },
        [3] = {
            stilltime = 6,
            ingredients = {

                ['GlassBottles'] = 15,
            },
            Tip = 'You need 15x Empty Bottles'
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
