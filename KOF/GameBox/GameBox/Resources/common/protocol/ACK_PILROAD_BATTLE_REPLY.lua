
require "common/AcknowledgementMessage"

-- [39021]战役信息返回 -- 取经之路 

ACK_PILROAD_BATTLE_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_BATTLE_REPLY
	self:init()
end)

-- {数量}
function ACK_PILROAD_BATTLE_REPLY.getCount(self)
	return self.count
end

-- {取经战役信息块(39022)}
function ACK_PILROAD_BATTLE_REPLY.getPildata(self)
	return self.pildata
end
