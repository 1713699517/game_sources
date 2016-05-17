
require "common/RequestMessage"

-- [4030]请求删除好友 -- 好友 

REQ_FRIEND_DEL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_DEL
	self:init(0, nil)
end)

function REQ_FRIEND_DEL.serialize(self, writer)
	writer:writeInt32Unsigned(self.fid)  -- {好友id}
	writer:writeInt8Unsigned(self.type)  -- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
end

function REQ_FRIEND_DEL.setArguments(self,fid,type)
	self.fid = fid  -- {好友id}
	self.type = type  -- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
end

-- {好友id}
function REQ_FRIEND_DEL.setFid(self, fid)
	self.fid = fid
end
function REQ_FRIEND_DEL.getFid(self)
	return self.fid
end

-- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
function REQ_FRIEND_DEL.setType(self, type)
	self.type = type
end
function REQ_FRIEND_DEL.getType(self)
	return self.type
end
