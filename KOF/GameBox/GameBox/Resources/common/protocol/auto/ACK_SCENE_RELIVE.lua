
require "common/AcknowledgementMessage"

-- [5160]玩家可以复活 -- 场景 

ACK_SCENE_RELIVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_RELIVE
	self:init()
end)

function ACK_SCENE_RELIVE.deserialize(self, reader)
	self.rmb = reader:readInt32Unsigned() -- {复活需要的RMB}
end

-- {复活需要的RMB}
function ACK_SCENE_RELIVE.getRmb(self)
	return self.rmb
end
