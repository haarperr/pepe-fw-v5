Config = {}

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

Config.CurrentId = nil

Config.IsEscorted = false
Config.IsHandCuffed = false

Config.Keys = {["E"] = 38, ["G"] = 47, ["H"] = 74}

Config.AmmoLabels = {
 ["AMMO_PISTOL"] = "9x19mm Parabellum bullet",
 ["AMMO_SMG"] = "9x19mm Parabellum bullet",
 ["AMMO_RIFLE"] = "7.62x39mm bullet",
 ["AMMO_MG"] = "7.92x57mm Mauser bullet",
 ["AMMO_SHOTGUN"] = "12-gauge bullet",
 ["AMMO_SNIPER"] = "Large caliber bullet",
}

Config.StatusList = {
 ["fight"] = "Red hands",
 ["widepupils"] = "Wide pupils",
 ["redeyes"] = "Red eyes",
 ["weedsmell"] = "Smelling like weed",
 ["alcohol"] = "Alcohol breath",
 ["gunpowder"] = "Gunpowder in clothing",
 ["chemicals"] = "Chemical smell",
 ["heavybreath"] = "Labored breathing",
 ["sweat"] = "Sweaty",
 ["handbleed"] = "Blood on hands",
 ["confused"] = "Confused",
 ["alcohol"] = "Alcaholic smell",
 ["heavyalcohol"] = "Severe alcohol smell",
}

Config.SilentWeapons = {
 "WEAPON_UNARMED",
 "WEAPON_SNOWBALL",
 "WEAPON_PETROLCAN",
 "WEAPON_STUNGUN",
 "WEAPON_FIREEXTINGUISHER",
}

Config.WeaponHashGroup = {
 [416676503] =   {['name'] = "Pistol"},
 [860033945] =   {['name'] = "Shotgun"},
 [970310034] =   {['name'] = "Semi-Automatic"},
 [1159398588] =  {['name'] = "Automatic"},
 [-1212426201] = {['name'] = "Sniper"},
 [-1569042529] = {['name'] = "Heavy"},
 [1548507267] =  {['name'] = "Grenade"},
}

Config.Locations = {
    ['checkin'] = {
      [1] = {['X'] = 441.27, ['Y'] = -981.96, ['Z'] = 30.68},
    },
    ['fingerprint'] = {
        [1] = {['X'] = 473.19, ['Y'] = -1007.45, ['Z'] = 26.27},
    },
    ['personal-safe'] = {
      [1] = {['X'] = 461.70, ['Y'] = -996.09, ['Z'] = 30.68},
    -- },
    -- ['outfits'] = {
    --   [1] = {['X'] = 461.5067, ['Y'] = -999.2241, ['Z'] = 30.68},
    },
    ['boss'] = {
      [1] = {['X'] = 460.55288, ['Y'] = -985.4736, ['Z'] = 30.728073},
    },
    ['impound'] = {
      [1] = {['X'] = 425.91876, ['Y'] = -991.558, ['Z'] = 25.69979},
    },
    ['work-shops'] = {
      [1] = {['X'] = 482.63, ['Y'] = -995.21, ['Z'] = 30.68},
    },
    ['garage'] = {
        [1] = {
         ['X'] = 459.29, 
         ['Y'] = -994.13, 
         ['Z'] = 25.70,       
          ['Spawns'] = {
            [1] = {
             ['X'] = 436.87,
             ['Y'] = -994.17,
             ['Z'] = 25.69,
             ['H'] = 88.02,
            },
            [2] = {
             ['X'] = 437.08,
             ['Y'] = -988.96,
             ['Z'] = 25.89,
             ['H'] = 90.94,
            },
            [3] = {
             ['X'] = 445.19,
             ['Y'] = -991.56,
             ['Z'] = 25.69,
             ['H'] = 268.71,
            },
          },
       },
       [2] = {
        ['X'] = 1855., 
        ['Y'] = -981.21, 
        ['Z'] = 43.69,
        ['Spawns'] = nil
      },
    },
}

Config.Objects = {
  ["cone"] = {model = `prop_roadcone02a`, freeze = false},
  ["barrier"] = {model = `prop_barrier_work06a`, freeze = true},
  ["schot"] = {model = `prop_snow_sign_road_06g`, freeze = true},
  ["tent"] = {model = `prop_gazebo_03`, freeze = true},
  ["light"] = {model = `prop_worklight_03b`, freeze = true},
}

Config.Items = {
  label = "Police Weapon Locker",
  slots = 30,
  items = {
      [1] = {
        name = "weapon_pistol_mk2",
        price = 0,
        amount = 1,
        info = {
            serie = "",
            melee = false,  
            quality = 100.0,              
            attachments = {{component = "COMPONENT_AT_PI_FLSH_02", label = "Flashlight"}}
        },
        type = "weapon",
        slot = 1,
      },
      [2] = {
        name = "weapon_stungun",
        price = 0,
        amount = 1,
        info = {
            serie = "",  
            melee = false, 
            quality = 100.0,         
        },
        type = "weapon",
        slot = 2,
      },
      [3] = {
        name = "weapon_carbinerifle_mk2",
        price = 0,
        amount = 1,
        info = {
          serie = "", 
          melee = false, 
          quality = 100.0,
          attachments = {{component = "COMPONENT_AT_SCOPE_MEDIUM_MK2", label = "Scope"}, {component = "COMPONENT_AT_MUZZLE_05", label = "Muzzle Brake"}, {component = "COMPONENT_AT_AR_AFGRIP_02", label = "Grip"}, {component = "COMPONENT_AT_AR_FLSH", label = "Falshlight"}}    
        },
        type = "weapon",
        slot = 3,
      },
      [4] = {
        name = "weapon_flashlight",
        price = 0,
        amount = 1,
        info = {
          melee = true,
          quality = 100.0
        },
        type = "weapon",
        slot = 4,
      },
      [5] = {
        name = "weapon_nightstick",
        price = 0,
        amount = 1,
        info = {
          melee = true,
          quality = 100.0
        },
        type = "weapon",
        slot = 5,
      },
      [6] = {
        name = "pistol-ammo",
        price = 100,
        amount = 50,
        info = {},
        type = "item",
        slot = 6,
      },
      [7] = {
        name = "rifle-ammo",
        price = 250,
        amount = 50,
        info = {},
        type = "item",
        slot = 7,
      },
      [8] = {
        name = "taser-ammo",
        price = 75,
        amount = 50,
        info = {},
        type = "item",
        slot = 8,
      },
      [9] = {
        name = "armor",
        price = 150,
        amount = 50,
        info = {},
        type = "item",
        slot = 9,
      },
      [10] = {
        name = "heavy-armor",
        price = 350,
        amount = 50,
        info = {},
        type = "item",
        slot = 10,
      },
      [11] = {
        name = "handcuffs",
        price = 0,
        amount = 1,
        info = {},
        type = "item",
        slot = 11,
      },
      [12] = {
        name = "empty_evidence_bag",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 12,
      },
      [13] = {
        name = "radio",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 13,
      },
      [14] = {
        name = "police_stormram",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 14,
      },
      [15] = {
        name = "spikestrip",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 15,
      },
   }
}