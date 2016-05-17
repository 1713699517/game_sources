
require "common/RequestMessage"

-- [18120]领取奖励 -- 荣誉 

REQ_HONOR_REWARD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HONOR_REWARD
	self:init(0, nil)
end)

function REQ_HONOR_REWARD.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:火影目标2:角色成长3:强者之路4:角色历练5:神宠神骑6:浴血沙场}
	writer:writeInt32Unsigned(self.id)  -- {荣誉ID}
end

function REQ_HONOR_REWARD.setArguments(self,type,id)
	self.type = type  -- {1:火影目标2:角色成长3:强者之路4:角色历练5:神宠神骑6:浴血沙场}
	self.id = id  -- {荣誉ID}
end

-- {1:火影目标2:角色成长3:强者之路4:角色历练5:神宠神骑6:浴血沙场}
function REQ_HONOR_REWARD.setType(self, type)
	self.type = type
end
function REQ_HONOR_REWARD.getType(self)
	return self.type
end

-- {荣誉ID}
function REQ_HONOR_REWARD.setId(self, id)
	self.id = id
end
function REQ_HONOR_REWARD.getId(self)
	return self.id
end
