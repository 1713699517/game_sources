
require "common/RequestMessage"

-- [10001]好友祝福 -- 祝福 

REQ_WISH_SENT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WISH_SENT
	self:init(0, nil)
end)

function REQ_WISH_SENT.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {用户id}
	writer:writeInt16Unsigned(self.lv)  -- {等级}
	writer:writeInt8Unsigned(self.type)  -- {祝福类型(0：真挚祝福，1：赠送卡片，2：赠送礼盒，3：赠送大礼包}
end

function REQ_WISH_SENT.setArguments(self,uid,lv,type)
	self.uid = uid  -- {用户id}
	self.lv = lv  -- {等级}
	self.type = type  -- {祝福类型(0：真挚祝福，1：赠送卡片，2：赠送礼盒，3：赠送大礼包}
end

-- {用户id}
function REQ_WISH_SENT.setUid(self, uid)
	self.uid = uid
end
function REQ_WISH_SENT.getUid(self)
	return self.uid
end

-- {等级}
function REQ_WISH_SENT.setLv(self, lv)
	self.lv = lv
end
function REQ_WISH_SENT.getLv(self)
	return self.lv
end

-- {祝福类型(0：真挚祝福，1：赠送卡片，2：赠送礼盒，3：赠送大礼包}
function REQ_WISH_SENT.setType(self, type)
	self.type = type
end
function REQ_WISH_SENT.getType(self)
	return self.type
end
