
require "common/AcknowledgementMessage"

-- [10701]称号列表数据块 -- 称号 

ACK_TITLE_XXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TITLE_XXX1
	self:init()
end)

-- {称号数量}
function ACK_TITLE_XXX1.getCount(self)
	return self.count
end

-- {true:启用中 | false:未启用}
function ACK_TITLE_XXX1.getState(self)
	return self.state
end

-- {类型(见常量)}
function ACK_TITLE_XXX1.getType(self)
	return self.type
end

-- {固定称号}
function ACK_TITLE_XXX1.getTid(self)
	return self.tid
end

-- {称号名字}
function ACK_TITLE_XXX1.getName(self)
	return self.name
end
