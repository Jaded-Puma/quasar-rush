FPS = {
    lastTime = tstamp(),
    frame = 0,
    fps = 60,

    getValue = function(self)
        self.frame = self.frame + 1

        if tstamp() ~= self.lastTime then
          self.lastTime = tstamp()
          self.fps = self.frame
          self.frame = 0
        end

        return self.fps
    end
}