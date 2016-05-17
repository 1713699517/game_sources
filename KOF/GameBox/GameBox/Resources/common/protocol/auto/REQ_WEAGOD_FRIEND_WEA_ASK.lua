
require "common/RequestMessage"

-- (手动) -- [32095]请求好友财神信息 -- 财神 

REQ_WEAGOD_FRIEND_WEA_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WEAGOD_FRIEND_WEA_ASK
	self:init()
end)

function REQ_WEAGOD_FRIEND_WEA_ASK.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {好友Uid}
end

function REQ_WEAGOD_FRIEND_WEA_ASK.setArguments(self,uid)
	self.uid = uid  -- {好友Uid}
end

-- {好友Uid}
function REQ_WEAGOD_FRIEND_WEA_ASK.setUid(self, uid)
	self.uid = uid
end
function REQ_WEAGOD_FRIEND_WEA_ASK.getUid(self)
	return self.uid
end
