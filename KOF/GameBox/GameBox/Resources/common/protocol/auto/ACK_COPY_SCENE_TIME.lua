
require "common/AcknowledgementMessage"

-- [7060]场景时间同步(生存,限时类型) -- 副本 

ACK_COPY_SCENE_TIME = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_SCENE_TIME
	self:init()
end)

function ACK_COPY_SCENE_TIME.deserialize(self, reader)
	self.time = reader:readInt32Unsigned() -- {时间}
end

-- {时间}
function ACK_COPY_SCENE_TIME.getTime(self)
	return self.time
end
