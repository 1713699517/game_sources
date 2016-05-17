
require "common/AcknowledgementMessage"

-- (手动) -- [47300]返回购买面板数据 -- 藏宝阁系统 

ACK_TREASURE_BUY_REFRESH = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_BUY_REFRESH
	self:init()
end)
