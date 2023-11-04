-- Single state animation class

AnimationSingle = lazy.class("AnimationSingle")

function AnimationSingle:constructor(AnimationSingleData)
    self.frames = AnimationSingleData.frames
    self.times = AnimationSingleData.times
    self.size  = AnimationSingleData.size

    self.frame_index = 1
    self.current_time = 0

    self.max_times = 0

    for _, frame_time in ipairs(self.times) do
        self.max_times = self.max_times + frame_time
    end

    self.current_frame_id = self.frames[self.frame_index]
    self.current_frame_time  = self.times[self.frame_index]

    self.is_done = false
end

function AnimationSingle:update(dt)
    self.current_time = lazy.math.bound(self.current_time + 1, 0, self.current_frame_time)

    if self.frame_index == #self.frames and self.current_time == self.current_frame_time then
        self.is_done = true
    elseif self.current_time == self.current_frame_time then
        self.frame_index = self.frame_index + 1
        self.current_time = 0

        self.current_frame_id = self.frames[self.frame_index]
        self.current_frame_time  = self.times[self.frame_index]
    end
end

function AnimationSingle:render(x, y)
    spr(
        self.current_frame_id,
        x, y,
        0, 1, 0, 0,
        self.size , self.size
    )
end

function AnimationSingle:isDone()
    return self.is_done
end