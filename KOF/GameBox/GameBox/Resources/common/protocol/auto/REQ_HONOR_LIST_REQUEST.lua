
require "common/RequestMessage"

-- [18110]请求荣誉列表 -- 荣誉 

REQ_HONOR_LIST_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HONOR_LIST_REQUEST
	self:init(0, nil)
end)

function REQ_HONOR_LIST_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {0:荣誉总揽1:火影目标2:角色成长3:强者之路4:角色历练5:神宠神骑6:浴血沙场}
end

function REQ_HONOR_LIST_REQUEST.setArguments(self,type)
	self.type = type  -- {0:荣誉总揽1:火影目标2:角色成长3:强者之路4:角色历练5:神宠神骑6:浴血沙场}
end

-- {0:荣誉总揽1:火影目标2:角色成长3:强者之路4:角色历练5:神宠神骑6:浴血沙场}
function REQ_HONOR_LIST_REQUEST.setType(self, type)
	self.type = type
end
function REQ_HONOR_LIST_REQUEST.getType(self)
	return self.type
end
