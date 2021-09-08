Config = Config or {}

Config.CurrentWeaponData = nil

Config.DurabilityBlockedWeapons = {"weapon_stungun", "weapon_unarmed", "weapon_molotov", "weapon_pistol_mk2"}
Config.DurabilityMultiplier = {['weapon_carbinerifle_mk2'] = 0.25, ['weapon_assaultrifle_mk2'] = 0.25, ['weapon_heavypistol'] = 0.25, ['weapon_pistol_mk2'] = 0.25, ['weapon_snspistol_mk2'] = 0.25, ['weapon_nightstick'] = 0.5, ['weapon_flashlight'] = 0.5, ['weapon_switchblade'] = 0.5, ['weapon_wrench'] = 0.5, ['weapon_hatchet'] = 0.5, ['weapon_hammer'] = 0.5, ['weapon_bread'] = 0.5, ['weapon_sawnoffshotgun'] = 0.25, ['weapon_appistol'] = 0.25, ['weapon_machinepistol'] = 0.25, ['weapon_vintagepistol'] = 0.25}  

Config.WeaponsList = {
 -- // Unarmed \\ --
 [GetHashKey('weapon_unarmed')]     = {['Name'] = 'Hands',       ['IdName'] = 'weapon_unarmed',     ['AmmoType'] = nil,          ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_nightstick')]  = {['Name'] = 'Baton',       ['IdName'] = 'weapon_nightstick',  ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_flashlight')]  = {['Name'] = 'Zaklamp',     ['IdName'] = 'weapon_flashlight',  ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_hatchet')]     = {['Name'] = 'Hakbijl',     ['IdName'] = 'weapon_hatchet',     ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_switchblade')] = {['Name'] = 'Klapmes',     ['IdName'] = 'weapon_switchblade', ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_hammer')]      = {['Name'] = 'Hamer',      ['IdName'] = 'weapon_hammer',      ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_wrench')]      = {['Name'] = 'Moersleutel', ['IdName'] = 'weapon_wrench',      ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_bread')]       = {['Name'] = 'Stokbrood',   ['IdName'] = 'weapon_bread',       ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_knife')]       = {['Name'] = 'Mes',   ['IdName'] = 'weapon_knife',       ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 
 [GetHashKey('weapon_molotov')]     = {['Name'] = 'Molotov Cocktail', ['IdName'] = 'weapon_molotov',  ['AmmoType'] = 'AMMO_FIRE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 -- // Pistols \\ --
 [GetHashKey('weapon_snspistol_mk2')]  = {['Name'] = 'Sns Pistool',     ['IdName'] = 'weapon_snspistol_mk2',   ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Recoil'] = 2.5},
 [GetHashKey('weapon_pistol_mk2')]     = {['Name'] = 'Glock 17',        ['IdName'] = 'weapon_pistol_mk2',      ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Recoil'] = 2.5},
 [GetHashKey('weapon_heavypistol')]    = {['Name'] = 'Heavy Pistool',   ['IdName'] = 'weapon_heavypistol',     ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Recoil'] = 2.5},
 [GetHashKey('weapon_vintagepistol')]  = {['Name'] = 'Klasiek Pistool', ['IdName'] = 'weapon_vintagepistol',   ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 25, ['Recoil'] = 2.5},
 -- // SMG Pistols \\ --
 [GetHashKey('weapon_machinepistol')]  = {['Name'] = 'Machine Pistool',   ['IdName'] = 'weapon_machinepistol', ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 60, ['Recoil'] = 3.5},
 [GetHashKey('weapon_appistol')]       = {['Name'] = 'AP Pistool',        ['IdName'] = 'weapon_appistol',      ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 60, ['Recoil'] = 3.5},
 -- Shotgun --
 [GetHashKey('weapon_sawnoffshotgun')]  = {['Name'] = 'Korte Shotgun',   ['IdName'] = 'weapon_sawnoffshotgun', ['AmmoType'] = 'AMMO_SHOTGUN', ['MaxAmmo'] = 16, ['Recoil'] = 0.35},
 -- // Rifles \\ --
 [GetHashKey('weapon_carbinerifle_mk2')]  = {['Name'] = 'Carbine Geweer',   ['IdName'] = 'weapon_carbinerifle_mk2', ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 60, ['Recoil'] = 0.15},
 [GetHashKey('weapon_assaultrifle_mk2')]  = {['Name'] = 'Assault Rifle',   ['IdName'] = 'weapon_assaultrifle_mk2', ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 60, ['Recoil'] = 0.15},
}

Config.WeaponAttachments = {
    ["WEAPON_CARBINERIFLE_MK2"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP",
            label = "Demper",
            item = "rifle_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_CARBINERIFLE_MK2_CLIP_01",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Flashlight",
            item = "rifle_flashlight",
        },
        ["grip"] = {
            component = "COMPONENT_AT_AR_AFGRIP_02",
            label = "Grip",
            item = "rifle_grip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
            label = "Scope",
            item = "rifle_scope",
        },
    },
    ["WEAPON_ASSAULTRIFLE_MK2"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Demper",
            item = "rifle_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Flashlight",
            item = "rifle_flashlight",
        },
        ["grip"] = {
            component = "COMPONENT_AT_AR_AFGRIP_02",
            label = "Grip",
            item = "rifle_grip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO_MK2",
            label = "Scope",
            item = "rifle_scope",
        },
    },
    ["WEAPON_HEAVYPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Demper",
            item = "pistol_suppressor",
        },
    },
    ["WEAPON_SNSPISTOL_MK2"] = {
        ["extendedclip"] = {
            component = "COMPONENT_PISTOL_MK2_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_MACHINEPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Demper",
            item = "pistol_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_MACHINEPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_VINTAGEPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Demper",
            item = "pistol_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_VINTAGEPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_APPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Demper",
            item = "pistol_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_APPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
}