
require "common/AcknowledgementMessage"

-- [32020]上香好友请求返回 -- 财神 

ACK_WEAGOD_CEN_FRIEND_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_CEN_FRIEND_REPLY
	self:init()
end)

-- {一键上香(1：是 | 0：否)}
function ACK_WEAGOD_CEN_FRIEND_REPLY.getQkweagod(self)
	return self.qkweagod
end

-- {已给多少个好友上了香}
function ACK_WEAGOD_CEN_FRIEND_REPLY.getFricentimes(self)
	return self.fricentimes
end

-- {可上香好友数量}
function ACK_WEAGOD_CEN_FRIEND_REPLY.getCount(self)
	return self.count
end

-- {32025}
function ACK_WEAGOD_CEN_FRIEND_REPLY.getData(self)
	return self.data
end
