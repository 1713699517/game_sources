
require "common/AcknowledgementMessage"

-- [4040]好友删除成功 -- 好友 

ACK_FRIEND_DEL_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FRIEND_DEL_OK
	self:init()
end)

function ACK_FRIEND_DEL_OK.deserialize(self, reader)
	self.fid = reader:readInt32Unsigned() -- {好友id}
end

-- {好友id}
function ACK_FRIEND_DEL_OK.getFid(self)
	return self.fid
end
