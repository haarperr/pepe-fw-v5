Config = Config or {}

Config.CurrentItems = {}

Config.SmeltTime = 300

Config.CanTake = false

Config.Smelting = false

Config.Locations = {
    ['PawnShops'] = {
        [1] = {['X'] = 182.26, ['Y'] = -1319.10, ['Z'] = 29.31, ['Open-Time'] = 6, ['Close-Time'] = 12, ['Sell-Value'] = 1.0, ['Type'] = 'Gold'},
        [2] = {['X'] = -1468.99, ['Y'] = -406.36, ['Z'] = 36.81, ['Open-Time'] = 12, ['Close-Time'] = 16, ['Sell-Value'] = 1.0, ['Type'] = 'Bars'},
    },
    ['Smeltery'] = {
        [1] = {['X'] = 1109.91, ['Y'] = -2008.23, ['Z'] = 31.08},
    },
    ['Gold-Sell'] = {
      [1] = {['X'] = -1468.99, ['Y'] = -406.36, ['Z'] = 36.81},
  },
}

Config.ItemPrices = {
  ['gold-rolex'] = 2000,
  ['gold-necklace'] = 1500,
  ['diamond-ring'] = 1000,
}

Config.SmeltItems = {
  ['gold-rolex'] = 16,
  ['gold-necklace'] = 26,
}