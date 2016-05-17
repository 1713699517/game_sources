
require "common/RequestMessage"

-- [48211]请求开始领悟 -- 斗气系统 

REQ_SYS_DOUQI_ASK_START_GRASP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYS_DOUQI_ASK_START_GRASP
	self:init(1 ,{ 48220,48223,48201,700 })
end)

function REQ_SYS_DOUQI_ASK_START_GRASP.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {0 钻石| 1美金 |2美金一键领悟}
end

function REQ_SYS_DOUQI_ASK_START_GRASP.setArguments(self,type)
	self.type = type  -- {0 钻石| 1美金 |2美金一键领悟}
end

-- {0 钻石| 1美金 |2美金一键领悟}
function REQ_SYS_DOUQI_ASK_START_GRASP.setType(self, type)
	self.type = type
end
function REQ_SYS_DOUQI_ASK_START_GRASP.getType(self)
	return self.type
end
