
require "common/AcknowledgementMessage"

-- [7790]场景目标完成 -- 副本 

ACK_COPY_SCENE_OVER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_SCENE_OVER
	self:init()
end)
