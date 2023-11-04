-- Data aniimation class for single state animations

AnimationSingleData = lazy.class("AnimationSingleData")

function AnimationSingleData:constructor(frames, times, size)
    assert(#frames == #times, "frames and times in AnimationSingleData does not match.")

    self.frames = frames
    self.times = times

    self.size = size and size or 1
end

function AnimationSingleData:getIntanced()
    return AnimationSingle(self)
end

