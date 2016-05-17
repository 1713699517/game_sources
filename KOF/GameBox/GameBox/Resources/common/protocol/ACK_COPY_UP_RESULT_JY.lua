
require "common/AcknowledgementMessage"

-- [7920]挂机-精英副本某一次战斗返回结果 -- 副本 

ACK_COPY_UP_RESULT_JY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_RESULT_JY
	self:init()
end)

-- {挂机返回信息块(7096)}
function ACK_COPY_UP_RESULT_JY.getData(self)
	return self.data
end
