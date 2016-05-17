
require "common/AcknowledgementMessage"

-- [21140]玩家对怪伤害值 -- 活动-保卫经书 

ACK_DEFEND_BOOK_SELF_HARM = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_SELF_HARM
	self:init()
end)

function ACK_DEFEND_BOOK_SELF_HARM.deserialize(self, reader)
	self.harm = reader:readInt32Unsigned() -- {玩家对怪伤害值}
end

-- {玩家对怪伤害值}
function ACK_DEFEND_BOOK_SELF_HARM.getHarm(self)
	return self.harm
end
