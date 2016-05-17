
require "common/RequestMessage"

-- [46040]转盘动画结束 -- 幸运大转盘 

REQ_WHEEL_PLAY_END = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WHEEL_PLAY_END
	self:init(0, nil)
end)
