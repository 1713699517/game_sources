
require "common/AcknowledgementMessage"

-- [21232]拾取击杀奖励 -- 活动-保卫经书 

ACK_DEFEND_BOOK_OK_GET_REWARDS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_OK_GET_REWARDS
	self:init()
end)

function ACK_DEFEND_BOOK_OK_GET_REWARDS.deserialize(self, reader)
	self.gmid = reader:readInt32Unsigned() -- {被击杀的怪物生成Id}
end

-- {被击杀的怪物生成Id}
function ACK_DEFEND_BOOK_OK_GET_REWARDS.getGmid(self)
	return self.gmid
end
