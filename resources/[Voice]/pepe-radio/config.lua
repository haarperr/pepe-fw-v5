
--- Change DBFW to your core name

---- Done by Dolaji

---- Discord - https://discord.gg/qZQfHuYWSm



Config = {}

Config.RestrictedChannels = 10 -- channels that are encrypted (EMS, Fire and police can be included there) if we give eg 10, channels from 1 - 10 will be encrypted

Config.MaxFrequency = 500

Config.messages = {
  ['not_on_radio'] = 'Bạn không kết nối với tín hiệu',
  ['on_radio'] = 'Radio của bạn đã kết nối với: <b>',
  ['joined_to_radio'] = 'Bạn đã kết nối: <b>',
  ['restricted_channel_error'] = 'Bạn không thể kết nối với radio này!',
  ['you_on_radio'] = 'Bạn đã kết nối với radio này: <b>',
  ['you_leave'] = 'Bạn đã thoát radio: <b>'
}