
require "common/RequestMessage"

-- [4010]请求好友面板 -- 好友 

REQ_FRIEND_REQUES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_REQUES
	self:init(0, nil)
end)

function REQ_FRIEND_REQUES.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）}
end

function REQ_FRIEND_REQUES.setArguments(self,type)
	self.type = type  -- {请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）}
end

-- {请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）}
function REQ_FRIEND_REQUES.setType(self, type)
	self.type = type
end
function REQ_FRIEND_REQUES.getType(self)
	return self.type
end
