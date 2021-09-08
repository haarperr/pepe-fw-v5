Config = Config or {}

Config.Locale = "en"
Config.LabPolice = 6

Config.RewardTypes = {
    [1] = {
        type = "item",
    },
    [2] = {
        type = "money",
        maxAmount = 500
    }
}

Config.Lab = {
    ["label"] = "Humane Labs",
    ["coords"] = {
        ["x"] = 3536.99,
        ["y"] = 3668.48,
        ["z"] = 28.12,
    },
    ["explosive"] = {
      ["x"] = 3525.29,
      ["y"] = 3702.82,
      ["z"] = 20.99,
      ["isOpened"] = false,
    },
    ["alarm"] = true,
    ["isOpened"] = false,
    ["lockers"] = {
        [1] = {
            x = 3537.02, 
            y = 3662.85, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [2] = {
            x = 3533.33, 
            y = 3659.85, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },--
        [3] = {
            x = 3540.5, 
            y = 3642.74, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [4] = {
            x = 3558.12, 
            y = 3662.78, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [5] = {
            x = 3558.6, 
            y = 3669.09, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [6] = {
            x = 3559.52, 
            y = 3672.10, 
            z = 28.121, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [7] = {
            x = 3562.584, 
            y = 3675.67, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [8] = {
            x = 3564.20, 
            y = 3678.94, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [9] = {
            x = 3558.50, 
            y = 3685.16, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [10] = {
            x = 3563.12, 
            y = 3684.20, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [11] = {
            x = 3553.22, 
            y = 3656.39, 
            z = 28.12, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [12] = {
            x = 3621.94, 
            y = 3735.19, 
            z = 28.69, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
        [13] = {
            x = 3608.05, 
            y = 3744.40, 
            z = 28.69, 
            ["isBusy"] = false,
            ["isOpened"] = false,
        },
    },
    ['trucks'] = {
        [1] = {
            x = 3613.33, 
            y = 3741.20, 
            z = 28.69, 
            h = 146.142, 
           },
        [2] = {
            x = 3620.34, 
            y = 3736.26, 
            z = 28.69, 
            h = 146.142, 
        },
    },
    ['peds'] = {
         [1] = {
          x = 3526.96, 
          y = 3647.54, 
          z = 27.52, 
          h = 0.0, 
         },
         [2] = {
          x = 3552.34, 
          y = 3657, 
          z = 28.12, 
          h = 0.0, 
         },
         [3] = {
          x = 3561.98, 
          y = 3675.19, 
          z = 28.12, 
          h = 127.0, 
         },
         [4] = {
          x = 3606.43, 
          y = 3730.73, 
          z = 29.68,
          h = 286.19, 
         },
         [5] = {
            x = 3626.87, 
            y = 3736.25, 
            z = 28.69,
            h = 134.68, 
        },
        [6] = {
            x = 3539.03, 
            y = 3665.38, 
            z = 28.12,
            h = 86.49, 
        },
        [7] = {
            x = 3542.57, 
            y = 3670.69, 
            z = 20.99,
            h = 75.61, 
        },
        [8] = {
            x = 3582.07, 
            y = 3694.7, 
            z = 27.12,
            h = 134.79, 
        },
        [8] = {
            x = 3591.48, 
            y = 3676.86, 
            z = 27.62,
            h = 8.27, 
        },
        [9] = {
            x = 3582.25, 
            y = 3694.18, 
            z = 27.12,
            h = 108.20, 
        },
        [10] = {
            x = 3567.95, 
            y = 3700.55, 
            z = 28.12,
            h = 167.41, 
        },
        [11] = {
            x = 3561.86, 
            y = 3678.96, 
            z = 28.12,
            h = 75.80, 
        },
        [12] = {
            x = 3593.44, 
            y = 3716.84, 
            z = 29.68,
            h = 168.06, 
        },
        [13] = {
            x = 3595.89, 
            y = 3702.86, 
            z = 29.68,
            h = 332.16, 
        },
        [14] = {
            x = 3611.95, 
            y = 3716.80, 
            z = 29.68,
            h = 140.69, 
        },
        [15] = {
            x = 3606.85, 
            y = 3735.22, 
            z = 28.69,
            h = 210.56, 
        },
    },
}


Config.LockerRewards = {
    ["tier1"] = {
        [1] = {item = "gold-necklace", maxAmount = 30},
    },
    ["tier2"] = {
        [1] = {item = "gold-rolex", maxAmount = 15},
    },
    ["tier3"] = {
        [1] = {item = "gold-bar", maxAmount = 6},
    },
}

Config.CabinetRewards = {
    ["tier1"] = {
        [1] = {item = "painkillers", maxAmount = 1},
    },
    ["tier2"] = {
        [1] = {item = "phone", maxAmount = 1},
    },
    ["tier3"] = {
        [1] = {item = "bandage", maxAmount = 1},
    },
    ["tier4"] = {
        [1] = {item = "black-card", maxAmount = 1},
    },
}


Config.MaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [18] = true,
    [26] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [118] = true,
    [125] = true,
    [132] = true,
}

Config.FemaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [19] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [135] = true,
    [142] = true,
    [149] = true,
    [153] = true,
    [157] = true,
    [161] = true,
    [165] = true,
}