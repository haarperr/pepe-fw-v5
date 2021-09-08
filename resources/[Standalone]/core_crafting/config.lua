Config = {

    BlipSprite = 237,
    BlipColor = 26,
    BlipText = 'Workbench',
    
    UseLimitSystem = false, -- Enable if your esx uses limit system
    
    CraftingStopWithDistance = true, -- Crafting will stop when not near workbench
    
    ExperiancePerCraft = 10, -- The amount of experiance added per craft (100 Experiance is 1 level)
    
    HideWhenCantCraft = true, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job
    
    Categories = {
    
    ['misc'] = {
        Label = 'MISC',
        Image = 'misc',
        Jobs = {}
    },
    ['weapon'] = {
        Label = 'WEAPON',
        Image = 'weapon',
        Jobs = {}
    },
    ['mechanic'] = {
        Label = 'MECHANIC',
        Image = 'mechanic',
        Jobs = {'mechanic'}
    }
    -- ['medical'] = {
    -- 	Label = 'ÖVRIGT',
    -- 	Image = 'bandage',
    -- 	Jobs = {}
    -- }
    
    
    },
    
    PermanentItems = { -- Items that dont get removed when crafting
        ['wrench'] = true
    },
    
    Recipes = { -- Enter Item name and then the speed value! The higher the value the more torque
    
    
    ['lockpick'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 20, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ['metalscrap'] = 22, -- item name and count, adding items that dont exist in database will crash the script
            ['plastic'] = 32, -- item name and count, adding items that dont exist in database will crash the script
    
        }
    }, 
    ['toolkit'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 20, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ['metalscrap'] = 30, -- item name and count, adding items that dont exist in database will crash the script
            ['plastic'] = 42, -- item name and count, adding items that dont exist in database will crash the script
    
        }
    },
    ['plastic-bag'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 2, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 25, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ['plastic'] = 16, -- item name and count, adding items that dont exist in database will crash the script
            
        }
    },
    ['electronickit'] = {
        Level = 3, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 45, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ['metalscrap'] = 30, -- item name and count, adding items that dont exist in database will crash the script
            ['plastic'] = 45, -- item name and count, adding items that dont exist in database will crash the script
            ["aluminum"] = 28,
        }
    },
    
    ['handcuffs'] = {
        Level = 02, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 45, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["metalscrap"] = 36,
            ["steel"] = 24,
            ["aluminum"] = 28,
        }
    },

    ['weapon_carbinerifle_mk2'] = {
        Level = 20, -- From what level this item will be craftable
        Category = 'weapon', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 45, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["rifle-trigger"] = 1,
            ["rifle-body"] = 1,
            ["rifle-stock"] = 1,
            ["rifle-clip"] = 1,
        }
    },
    
    ['handcuffs'] = {
        Level = 02, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 45, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["metalscrap"] = 36,
            ["steel"] = 24,
            ["aluminum"] = 28,
        }
    },
    
    ['armor'] = {
        Level = 07, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 45, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["iron"] = 33,
            ["steel"] = 44,
            ["plastic"] = 55,
            ["aluminum"] = 22,
        }
    },
    
    ['repairkit'] = {
        Level = 20, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 45, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["metalscrap"] = 32,
            ["steel"] = 43,
            ["plastic"] = 61,
        }
    },
    ['ironoxide'] = {
        Level = 25, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 45, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["iron"] = 60,
            ["glass"] = 30,
        }
    },
    
    ['aluminumoxide'] = {
        Level = 25, -- From what level this item will be craftable
        Category = 'misc', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 95, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 45, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["aluminum"] = 60,
            ["glass"] = 30,
        }
    },
    ['turbo_lvl_1'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'mechanic', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {'mechanic'}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 120, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["bearing"] = 6,
            ["metalscrap"] = 32,
            ["tape"] = 4,
        }
    },
    
    ['race_transmition'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'mechanic', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {'mechanic'}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 120, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["metalscrap"] = 32,
            ["spring"] = 4,
            ["bearing"] = 4,
            ["copper"] = 24,
            ["shell_oil"] = 2,
        }
    },
    ['race_suspension'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'mechanic', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {'mechanic'}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 120, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["metalscrap"] = 32,
            ["spring"] = 4,
            ["aluminum"] = 24,
            ["rubber"] = 4,
            ["gear"] = 4,
    
        }
    },
    ['stock_engine'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'mechanic', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {'mechanic'}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 120, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["piston"] = 4,
            ["aluminum"] = 24,
            ["bearing"] = 4,
            ["gear"] = 6,
    
        }
    },
    ['v8engine'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'mechanic', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {'mechanic'}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 120, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["metalscrap"] = 42,
            ["piston"] = 8,
            ["aluminum"] = 44,
            ["bearing"] = 6,
            ["gear"] = 8,
    
        }
    },
    ['2jzengine'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'mechanic', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {'mechanic'}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 120, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["metalscrap"] = 52,
            ["piston"] = 16,
            ["aluminum"] = 62,
            ["bearing"] = 12,
            ["gear"] = 12,
    
        }
    },
    ['michelin_tires'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'mechanic', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {'mechanic'}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 120, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["rubber"] = 52,
            ["tape"] = 16,
        }
    },
    ['race_brakes'] = {
        Level = 0, -- From what level this item will be craftable
        Category = 'mechanic', -- The category item will be put in
        isGun = false, -- Specify if this is a gun so it will be added to the loadout
        Jobs = {'mechanic'}, -- What jobs can craft this item, leaving {} allows any job
        JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
        Amount = 1, -- The amount that will be crafted
        SuccessRate = 100, --  100% you will recieve the item
        requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
        Time = 120, -- Time in seconds it takes to craft this item
        Ingredients = { -- Ingredients needed to craft this item
            ["copper"] = 52,
            ["bearing"] = 16,
            ["spring"] = 16,
            ["shell_oil"] = 3,
    
        }
    }
    
    },
    
    Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access
    
            {coords = vector3(101.26113891602,6615.810546875,33.58126831054), jobs = {}, blip = true, recipes = {}, radius = 3.0 }
    
    },
     
    
    Text = {
    
        ['not_enough_ingredients'] = 'You dont have enough ingredients',
        ['you_cant_hold_item'] = 'You have no place for the item',
        ['item_crafted'] = 'The item was crafted!',
        ['wrong_job'] = 'You cant open this workbench',
        ['workbench_hologram'] = '[~b~E~w~] Workbench',
        ['wrong_usage'] = 'Wrong use of command',
        ['inv_limit_exceed'] = 'You have no place left in the pockets! Clean up before you lose more',
        ['crafting_failed'] = 'You failed to manufacture the item!'
    
    }
    
    }
    
    
    
    function SendTextMessage(msg)
    
            -- SetNotificationTextEntry('STRING')
            -- AddTextComponentString(msg)
            -- DrawNotification(0,1)
			Framework.Functions.Notify(msg, "info")
            --EXAMPLE USED IN VIDEO
            --exports['mythic_notify']:SendAlert('inform', msg)
    
    end
    