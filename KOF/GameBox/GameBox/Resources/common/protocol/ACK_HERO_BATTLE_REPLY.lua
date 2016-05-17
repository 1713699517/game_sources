
require "common/AcknowledgementMessage"

-- [39021]战役信息返回 -- 英雄副本 

ACK_HERO_BATTLE_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_BATTLE_REPLY
	self:init()
end)

function ACK_HERO_BATTLE_REPLY.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	self.pildata = reader:readXXXGroup() -- {取经战役信息块(39022)}
end

-- {数量}
function ACK_HERO_BATTLE_REPLY.getCount(self)
	return self.count
end

-- {取经战役信息块(39022)}
function ACK_HERO_BATTLE_REPLY.getPildata(self)
	return self.pildata
end
