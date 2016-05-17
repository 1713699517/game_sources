
require "common/RequestMessage"

-- (手动) -- [1375]请求领取buff -- 角色 

REQ_ROLE_BUFF_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_BUFF_REQUEST
	self:init(0, nil)
end)

function REQ_ROLE_BUFF_REQUEST.serialize(self, writer)
	writer:writeInt32Unsigned(self.id)  -- {buff的id}
end

function REQ_ROLE_BUFF_REQUEST.setArguments(self,id)
	self.id = id  -- {buff的id}
end

-- {buff的id}
function REQ_ROLE_BUFF_REQUEST.setId(self, id)
	self.id = id
end
function REQ_ROLE_BUFF_REQUEST.getId(self)
	return self.id
end
