
require "common/RequestMessage"

-- [21230]请求拾取击杀奖励 -- 活动-保卫经书 

REQ_DEFEND_BOOK_ASK_GET_REWARDS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_ASK_GET_REWARDS
	self:init(0, nil)
end)

function REQ_DEFEND_BOOK_ASK_GET_REWARDS.serialize(self, writer)
	writer:writeInt32Unsigned(self.gmid)  -- {被击杀的怪物生成Id}
end

function REQ_DEFEND_BOOK_ASK_GET_REWARDS.setArguments(self,gmid)
	self.gmid = gmid  -- {被击杀的怪物生成Id}
end

-- {被击杀的怪物生成Id}
function REQ_DEFEND_BOOK_ASK_GET_REWARDS.setGmid(self, gmid)
	self.gmid = gmid
end
function REQ_DEFEND_BOOK_ASK_GET_REWARDS.getGmid(self)
	return self.gmid
end
