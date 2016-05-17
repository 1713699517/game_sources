
require "common/RequestMessage"

-- (手动) -- [31190]请求斗法卡片 -- 客栈 

REQ_INN_START_CONTEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_START_CONTEST
	self:init()
end)

function REQ_INN_START_CONTEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.color)  -- {使用刀的颜色}
end

function REQ_INN_START_CONTEST.setArguments(self,color)
	self.color = color  -- {使用刀的颜色}
end

-- {使用刀的颜色}
function REQ_INN_START_CONTEST.setColor(self, color)
	self.color = color
end
function REQ_INN_START_CONTEST.getColor(self)
	return self.color
end
