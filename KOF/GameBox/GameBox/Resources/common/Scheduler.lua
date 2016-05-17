


CScheduler = class(function ( self )
    self.m_lpScheduler = CCDirector:sharedDirector():getScheduler()
    self.m_handleList = {}
end)

function CScheduler.enterFrame( self, listener, isPaused )
    --每帧回调
    local handle = self.m_lpScheduler:scheduleScriptFunc(listener, 0, isPaused or false)
    self.m_handleList[handle] = handle
    return handle
end

function CScheduler.schedule(self, listener, interval, isPaused)
    --间隔多少回调  
    --listener 函数   
    --interval 间隔   
    --isPaused 是否暂停???
    --返回一个 handle
    local handle = self.m_lpScheduler:scheduleScriptFunc(listener, interval, isPaused or false)
    self.m_handleList[handle] = handle
    return handle
end

function CScheduler.unschedule( self, handle )
    --解除回调
    self.m_handleList[handle] = nil
    self.m_lpScheduler:unscheduleScriptEntry( handle )
end

function CScheduler.unAllschedule( self )
    --解除所有回调
    for _,handle in pairs(self.m_handleList) do
        self.m_lpScheduler:unscheduleScriptEntry( handle )
    end
end

function CScheduler.performWithDelay(self, time, listener)
    --以time时间回调一次  仅此一次
    local handle = nil
    local function unscheduleEntry()
        self.m_handleList[handle] = nil
        if handle ~= nil then
            self.m_lpScheduler:unscheduleScriptEntry(handle)
            handle = nil
        end
        listener()
    end
    handle = self.m_lpScheduler:scheduleScriptFunc(unscheduleEntry, time, false)
    unscheduleEntry = nil
    self.m_handleList[handle] = handle
    return handle
end




_G.Scheduler = CScheduler()


-- require("Scheduler")

-- local handle -- save script callback ID

-- -- schedule every frame update
-- local frameCount = 0
-- local function onEnterFrame(dt)
--     -- dt is float number
--     frameCount = frameCount + 1
--     if frameCount >= 60 then
--         -- unschedule callback
--         scheduler.unschedule(handle)
--     end
-- end

-- handle = Scheduler.enterFrame(onEnterFrame)

-- -- print message after delay
-- scheduler.performWithDelay(0.5, function()
--     print("delay 0.5 second")
-- end)