Settings = {}

Settings.Locations = {
    ['stash'] = {
        ['help'] = "[E] - Stash",
        ['event'] = "gangs:openStash"
    },
    ['boss'] = {
        ['help'] = "[E] - Gang",
        ['event'] = "gangs:requestOpenBoss"
    },
    ['vehicles'] = {
        ['help'] = "[E] - Vehicles",
        ['event'] = "gangs:vehiclesMenu"
    },
}

Settings.Grades = {
    ['none'] = 0,
    ['soldier'] = 1,
    ['underboss'] = 2,
    ['boss'] = 3,
}

Settings.Gangs = {
    ['none'] = {},
    ['crips'] = {
        ['label'] = "Crips",
        ['color'] = {9,112,204},
        ['locations'] = {
            ['stash'] = vector3(0.0, 0.0, 0.0),
            ['boss'] = vector3(0.0, 0.0, 0.0),
            ['vehicles'] = vector3(0.0, 0.0, 21.0)
        },
        ['vehicles'] = {
            { ['model'] = "akuma", ['label'] = "Akuma", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "sultan", ['label'] = "Sultan", ['icon'] = "fas fa-car-alt" }
        }
    },
    ['ballas'] = {
        ['label'] = "Ballas",
        ['color'] = {76,0,108},
        ['locations'] = {
            ['stash'] = vector3(108.99762, -1982.302, 20.962623),
            ['boss'] = vector3(116.99819, -1961.8, 21.327606),
            ['vehicles'] = vector3(106.98784, -1941.618, 20.803724)
        },
        ['vehicles'] = {
            { ['model'] = "chino", ['label'] = "Chino", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "blazer", ['label'] = "Blazer", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "manchez", ['label'] = "Manchez", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "sentinel3", ['label'] = "Sentinel Classic", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "guardian", ['label'] = "Guardian 6X6", ['icon'] = "fas fa-car-alt" }
        }
    },
    ['bloods'] = {
        ['label'] = "Bloods",
        ['color'] = {255,0,0},
        ['locations'] = {
            ['stash'] = vector3(-136.2029, -1609.057, 35.030216),
            ['boss'] = vector3(-156.9419, -1601.341, 35.043884),
            ['vehicles'] = vector3(-162.3784, -1574.845, 35.155052)
        },
        ['vehicles'] = {
            { ['model'] = "chino", ['label'] = "Chino", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "blazer", ['label'] = "Blazer", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "manchez", ['label'] = "Manchez", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "sentinel3", ['label'] = "Sentinel Classic", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "guardian", ['label'] = "Guardian 6X6", ['icon'] = "fas fa-car-alt" }
        }
    },
    ['vagos'] = {
        ['label'] = "Vagos",
        ['color'] = {255,254,22},
        ['locations'] = {
            ['stash'] = vector3(338.54171, -2012.886, 22.39496),
            ['boss'] = vector3(340.29132, -2021.027, 22.394962),
            ['vehicles'] = vector3(332.67541, -2037.941, 21.048429)
        },
        ['vehicles'] = {
            { ['model'] = "chino", ['label'] = "Chino", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "blazer", ['label'] = "Blazer", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "manchez", ['label'] = "Manchez", ['icon'] = "fas fa-motorcycle" },
            { ['model'] = "sentinel3", ['label'] = "Sentinel Classic", ['icon'] = "fas fa-car-alt" },
            { ['model'] = "guardian", ['label'] = "Guardian 6X6", ['icon'] = "fas fa-car-alt" }
        }
    },
}
