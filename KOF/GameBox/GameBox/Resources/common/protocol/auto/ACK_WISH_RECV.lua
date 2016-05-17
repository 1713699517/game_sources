
require "common/AcknowledgementMessage"

-- [10012]收到好友祝福 -- 祝福 

ACK_WISH_RECV = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WISH_RECV
	self:init()
end)

function ACK_WISH_RECV.deserialize(self, reader)
	self.name = reader:readString() -- {名字}
	self.exp = reader:readInt32Unsigned() -- {经验}
end

-- {名字}
function ACK_WISH_RECV.getName(self)
	return self.name
end

-- {经验}
function ACK_WISH_RECV.getExp(self)
	return self.exp
end
