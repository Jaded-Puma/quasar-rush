-- Class to store and manipulate the sound system in tic-80

SfxData = lazy.class("SfxData")

function SfxData:constructor(id, note, duration, volume, speed, channel, prio)
    self.id = id
    self.note = note
    self.duration = duration or -1
    self.volume = volume or 15
    self.speed = speed or 0
    self.channel = channel or 3
    self.prio = prio or 0
end

function SfxData:play()
    local freq, vol = lazy.tic.get_channel_data(self.channel)
    local prio = lazy.tic.get_channel_prio(self.channel)

    if vol == 0 then
        sfx(self.id , self.note, self.duration, self.channel, self.volume, self.speed)
        lazy.tic.set_channel_prio(self.channel, self.prio)
    elseif vol ~= 0 and self.prio >= prio then 
        sfx(self.id , self.note, self.duration, self.channel, self.volume, self.speed)
        lazy.tic.set_channel_prio(self.channel, self.prio)
    end
end