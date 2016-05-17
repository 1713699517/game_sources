
require "common/AcknowledgementMessage"

-- [2535]附加属性数据块 -- 物品/打造/强化 

ACK_MAKE_PLUS_MSG_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_PLUS_MSG_XXX
	self:init()
end)

-- {索引}
function ACK_MAKE_PLUS_MSG_XXX.getIdex(self)
	return self.idex
end

-- {数量}
function ACK_MAKE_PLUS_MSG_XXX.getCount(self)
	return self.count
end

-- {附加属性块2536}
function ACK_MAKE_PLUS_MSG_XXX.getMsgXxx2(self)
	return self.msg_xxx2
end
