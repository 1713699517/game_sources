
require "common/RequestMessage"

-- [47201]请求层次id -- 珍宝阁系统 

REQ_TREASURE_LEVEL_ID = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TREASURE_LEVEL_ID
	self:init(1 ,{ 47210,700 })
end)

function REQ_TREASURE_LEVEL_ID.serialize(self, writer)
	writer:writeInt32Unsigned(self.level_id)  -- {层次id|初次请求为0}
end

function REQ_TREASURE_LEVEL_ID.setArguments(self,level_id)
	self.level_id = level_id  -- {层次id|初次请求为0}
end

-- {层次id|初次请求为0}
function REQ_TREASURE_LEVEL_ID.setLevelId(self, level_id)
	self.level_id = level_id
end
function REQ_TREASURE_LEVEL_ID.getLevelId(self)
	return self.level_id
end
