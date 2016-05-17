
require "common/AcknowledgementMessage"

-- (手动) -- [4050]是否推荐好友返回 -- 好友 

ACK_FRIEND_RECOM_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_RECOM_BACK
	self:init()
end)

function ACK_FRIEND_RECOM_BACK.deserialize(self, reader)
	self.recom_result = reader:readInt8Unsigned() -- {是否可推荐(1：可以|0：不可以)}
end

-- {是否可推荐(1：可以|0：不可以)}
function ACK_FRIEND_RECOM_BACK.getRecomResult(self)
	return self.recom_result
end
