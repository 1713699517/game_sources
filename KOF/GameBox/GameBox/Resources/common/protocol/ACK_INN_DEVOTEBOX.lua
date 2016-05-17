
require "common/AcknowledgementMessage"

-- [31242]大仙宝箱 -- 客栈 

ACK_INN_DEVOTEBOX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_DEVOTEBOX
	self:init()
end)

-- {大仙id}
function ACK_INN_DEVOTEBOX.getDevoteid(self)
	return self.devoteid
end

-- {宝箱颜色}
function ACK_INN_DEVOTEBOX.getBoxColor(self)
	return self.box_color
end

-- {精魄颜色}
function ACK_INN_DEVOTEBOX.getColor(self)
	return self.color
end

-- {精魄数量}
function ACK_INN_DEVOTEBOX.getCount(self)
	return self.count
end
