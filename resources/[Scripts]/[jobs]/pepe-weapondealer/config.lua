Config = Config or {}

Config.Locations = {
    ['stash'] = { ['x'] = -600.56, ['y'] = -1618.72, ['z'] = 33.0, ['h'] = 202.22789 },
    ['shop'] = { ['x'] = -592.56, ['y'] = -1617.72, ['z'] = 33.0, ['h'] = 23.484317 }
}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end


Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end
--[[
Config.Items = {
    label = "Weapons",
    slots = 1,
    items = {
        [1] = {
            name = "weapon_combatmg",
            price = 100000,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_mg",
            price = 80000,
            amount = 3,
            info = {},
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_assaultrifle_mk2",
            price = 53000,
            amount = 10,
            info = {},
            type = "weapon",
            slot = 3,
        },
        [5] = {
            name = "weapon_bullpuprifle",
            price = 53000,
            amount = 10,
            info = {},
            type = "weapon",
            slot = 5,
        },
        [4] = {
            name = "weapon_assaultrifle",
            price = 45000,
            amount = 10,
            info = {},
            type = "weapon",
            slot = 4,
        },
        [6] = {
            name = "weapon_compactrifle",
            price = 30000,
            amount = 15,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "weapon_gusenberg",
            price = 28000,
            amount = 15,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "weapon_assaultsmg",
            price = 27500,
            amount = 20,
            info = {},
            type = "weapon",
            slot = 8,
        }, 
        [9] = {
            name = "weapon_microsmg",
            price = 22500,
            amount = 20,
            info = {},
            type = "weapon",
            slot = 9,
        },
        [10] = {
            name = "weapon_machinepistol",
            price = 19500,
            amount = 20,
            info = {},
            type = "weapon",
            slot = 10,
        },
        [11] = {
            name = "weapon_minismg",
            price = 17500,
            amount = 20,
            info = {},
            type = "weapon",
            slot = 11,
        },
        [12] = {
            name = "weapon_pumpshotgun",
            price = 25000,
            amount = 15,
            info = {},
            type = "weapon",
            slot = 12,
        },
        [13] = {
            name = "weapon_sawnoffshotgun",
            price = 20000,
            amount = 15,
            info = {},
            type = "weapon",
            slot = 13,
        }, 
        [14] = {
            name = "weapon_dbshotgun",
            price = 15000,
            amount = 15,
            info = {},
            type = "weapon",
            slot = 14,
           }, 
        [15] = {
            name = "weapon_appistol",
            price = 16500,
            amount = 20,
            info = {},
            type = "weapon",
            slot = 15,
           }, 
        [16] = {
            name = "weapon_pistol50",
            price = 15000,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 16,
           },  
        [17] = {
            name = "weapon_revolver_mk2",
            price = 12500,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 17,
           }, 
        [18] = {
            name = "weapon_doubleaction",
            price = 10000,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 18,
           }, 
        [19] = {
            name = "weapon_heavypistol",
            price = 10000,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 19,
           },     
        [20] = {
            name = "weapon_combatpistol",
            price = 4000,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 20,
           }, 
        [21] = {
            name = "weapon_vintagepistol",
            price = 3000,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 21,
           },    
        [22] = {
            name = "weapon_pistol",
            price = 2500,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 22,
           }, 
        [23] = {
            name = "weapon_snspistol",
            price = 500,
            amount = 30,
            info = {},
            type = "weapon",
            slot = 23,
           },    
        [24] = {
            name = "pistol_ammo",
            price = 20,
            amount = 100,
            info = {},
            type = "item",
            slot = 24,
           },    
        [25] = {
            name = "smg_ammo",
            price = 30,
            amount = 100,
            info = {},
            type = "item",
            slot = 25,
           },  
        [26] = {
            name = "mg_ammo",
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 26,
           },  
        [27] = {
            name = "shotgun_ammo",
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 27,
           },  
        [28] = {
            name = "rifle_ammo",
            price = 50,
            amount = 100,
            info = {},
            type = "item",
            slot = 28,
           }, 
        [29] = {
            name = "pistol_suppressor",
            price = 400,
            amount = 25,
            info = {},
            type = "item",
            slot = 29,
           }, 
        [30] = {
            name = "pistol_extendedclip",
            price = 500,
            amount = 25,
            info = {},
            type = "item",
            slot = 30,
           }, 
        [31] = {
            name = "smg_flashlight",
            price = 250,
            amount = 25,
            info = {},
            type = "item",
            slot = 31,
           }, 
        [32] = {
            name = "smg_extendedclip",
            price = 500,
            amount = 25,
            info = {},
            type = "item",
            slot = 32,
           }, 
        [33] = {
            name = "smg_scope",
            price = 2000,
            amount = 25,
            info = {},
            type = "item",
            slot = 33,
           }, 
        [34] = {
            name = "smg_suppressor",
            price = 400,
            amount = 25,
            info = {},
            type = "item",
            slot = 34,
           }, 
        [35] = {
            name = "rifle_extendedclip",
            price = 500,
            amount = 25,
            info = {},
            type = "item",
            slot = 35,
           }, 
        [36] = {
            name = "rifle_drummag",
            price = 2000,
            amount = 25,
            info = {},
            type = "item",
            slot = 36,
           },    
        [37] = {
            name = "rifle_suppressor",
            price = 400,
            amount = 25,
            info = {},
            type = "item",
            slot = 37,
        },      
        [38] = {
            name = "weapon_machete",
            price = 1500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 38,
        }, 
        [39] = {
            name = "weapon_hatchet",
            price = 1000,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 39,
        }, 
        [40] = {
            name = "weapon_dagger",
            price = 800,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 40,
        },
        [41] = {
            name = "weapon_knife",
            price = 800,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 41,
           },     
        [42] = {
            name = "weapon_switchblade",
            price = 800,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 42,
        },
        [43] = {
            name = "weapon_golfclub",
            price = 500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 43,
        },
        [44] = {
            name = "weapon_crowbar",
            price = 500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 44,
        },
        [45] = {
            name = "weapon_hammer",
            price = 500,
            amount = 25,
            info = {},
            type = "weapon",
            slot = 45,
		},
        [46] = {
            name = "weapon_molotov",
            price = 800,
            amount = 50,
            info = {},
            type = "weapon",
            slot = 46,
		},
		[47] = {
            name = "weedburn",
            price = 2500,
            amount = 1,
			info = {},
            type = "item",
			slot = 47,
		},
		[48] = {
            name = "methburn",
            price = 9000,
            amount = 1,
			info = {},
            type = "item",
			slot = 48,
		},
		[49] = {
            name = "cokeburn",
            price = 9000,
            amount = 1,
			info = {},
            type = "item",
			slot = 49,
        }
    }
}
]]--


Config.Items = {
    label = "High Gang",
    slots = 1,
    items = {
        [1] = {
            name = "weapon_heavypistol",
            price = 45000,
            amount = 4,
            info = {
                serie = "",                
                attachments = {
                }
            },
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "handcuffs",
            price = 1300,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "weapon_assaultrifle_mk2",
            price = 150000,
            amount = 1,
            info = {},
            type = "item",
            slot = 3,
        }, 
        [4] = {
            name = "heavy-armor",
            price = 25000,
            amount = 25,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "weapon_sawnoffshotgun",
            price = 125000,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 5,
        },
        [6] = {
            name = "pistol-ammo",
            price = 2500,
            amount = 20,
            info = {},
            type = "item",
           slot = 6,
        },    
        [7] = {
            name = "smg-ammo",
            price = 6500,
            amount = 4,
            info = {},
            type = "item",
           	slot = 7,
        },
        [8] = {
            name = "rifle-ammo",
            price = 10000,
            amount = 4,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "shotgun-ammo",
            price = 8000,
            amount = 4,
            info = {},
            type = "item",
            slot = 9,
        },
    }
}