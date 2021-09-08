Config = Config or {}

Config.BackEngineVehicles = {
  'ninef',
  'adder',
  'vagner',
  't20',
  'infernus',
  'zentorno',
  'reaper',
  'comet2',
  'comet3',
  'jester',
  'jester2',
  'cheetah',
  'cheetah2',
  'prototipo',
  'turismor',
  'pfister811',
  'ardent',
  'nero',
  'nero2',
  'tempesta',
  'vacca',
  'bullet',
  'osiris',
  'entityxf',
  'turismo2',
  'fmj',
  're7b',
  'tyrus',
  'italigtb',
  'penetrator',
  'monroe',
  'ninef2',
  'stingergt',
  'surfer',
  'surfer2',
  'comet3',
}


Config.Fuckage = 2000 -- in MS

-- Adjust the time to change how long the driver is forced into the random event. IN MS
-- There are more random events you can add on the fivem native wiki

Config.RandomVehicleInteraction = {
    {interaction = 27, time = 1500},
    {interaction = 6, time = 1000},
    {interaction = 7, time = 800}, --turn left and accel
    {interaction = 8, time = 800}, --turn right and accel
    {interaction = 10, time = 800}, --turn left and restore wheel pos
    {interaction = 11, time = 800}, --turn right and restore wheel pos
    {interaction = 23, time = 2000}, -- accel fast
    {interaction = 31, time = 2000} -- accel fast and then handbrake 
}