
require "common/RequestMessage"

-- [2010]请求装备,背包物品信息 -- 物品/背包 

REQ_GOODS_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_GOODS_REQUEST
	self:init(1 ,{ 2020,700 })
end)

function REQ_GOODS_REQUEST.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:背包 3:临时背包}
	writer:writeInt16Unsigned(self.sid)  -- {服务器ID}
	writer:writeInt32Unsigned(self.uid)  -- {玩家UID(查看别人用到) 1345无效}
end

function REQ_GOODS_REQUEST.setArguments(self,type,sid,uid)
	self.type = type  -- {1:背包 3:临时背包}
	self.sid = sid  -- {服务器ID}
	self.uid = uid  -- {玩家UID(查看别人用到) 1345无效}
end

-- {1:背包 3:临时背包}
function REQ_GOODS_REQUEST.setType(self, type)
	self.type = type
end
function REQ_GOODS_REQUEST.getType(self)
	return self.type
end

-- {服务器ID}
function REQ_GOODS_REQUEST.setSid(self, sid)
	self.sid = sid
end
function REQ_GOODS_REQUEST.getSid(self)
	return self.sid
end

-- {玩家UID(查看别人用到) 1345无效}
function REQ_GOODS_REQUEST.setUid(self, uid)
	self.uid = uid
end
function REQ_GOODS_REQUEST.getUid(self)
	return self.uid
end
