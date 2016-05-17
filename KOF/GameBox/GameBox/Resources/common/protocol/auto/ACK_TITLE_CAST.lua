
require "common/AcknowledgementMessage"

-- [10701]玩家称号广播 -- 称号 

ACK_TITLE_CAST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TITLE_CAST
	self:init()
end)

function ACK_TITLE_CAST.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.tid = reader:readInt16Unsigned() -- {称号id}
end

-- {玩家Uid}
function ACK_TITLE_CAST.getUid(self)
	return self.uid
end

-- {称号id}
function ACK_TITLE_CAST.getTid(self)
	return self.tid
end
