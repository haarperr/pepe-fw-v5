Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = Config or {}

Config.Locale = "en"
Config.Timeout = 45 * (60 * 1000)

Config.RequiredCops = -1

Config.Apple = {
    ["coords"] = {
            ["x"] = 157.0838, 
            ["y"] = -230.0955, 
            ["z"] = 54.42401,
    }
}
Config.VitrineRewards = {
    [1] = {
        ["item"] = "laptop",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 1
        },
    },
    [2] = {
        ["item"] = "tablet",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 2
        },
    },
    [3] = {
        ["item"] = "gold-rolex",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 2
        },
    },
}

Config.Locations = {
    [1] = {
        ["coords"] = {
            ["x"] = 157.0838, 
            ["y"] = -230.0955, 
            ["z"] = 54.42401,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [2] = {
        ["coords"] = {
            ["x"] = 158.7311, 
            ["y"] = -225.5713, 
            ["z"] = 54.42401,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [3] = {
        ["coords"] = {
            ["x"] = 155.6221, 
            ["y"] = -224.5015, 
            ["z"] = 54.42401,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [4] = {
        ["coords"] = {
            ["x"] = 153.8737, 
            ["y"] = -229.0323, 
            ["z"] = 54.42401,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [5] = {
        ["coords"] = {
            ["x"] = 151.9592, 
            ["y"] = -223.1847, 
            ["z"] = 54.42402,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [6] = {
        ["coords"] = {
            ["x"] = 150.2838, 
            ["y"] = -227.8233, 
            ["z"] = 54.42402,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    }, 
    [7] = {
        ["coords"] = {
            ["x"] = 147.1916, 
            ["y"] = -226.4779, 
            ["z"] = 54.42402,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [8] = {
        ["coords"] = {
            ["x"] = 148.9756, 
            ["y"] = -221.8463, 
            ["z"] = 54.42402,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [9] = {
        ["coords"] = {
            ["x"] = 145.3721, 
            ["y"] = -226.1051, 
            ["z"] = 54.42402,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    }
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