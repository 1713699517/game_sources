
require "common/AcknowledgementMessage"

-- [18130]荣誉状态列表 -- 荣誉 

ACK_HONOR_LIST_RETURN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HONOR_LIST_RETURN
	self:init()
end)

-- {1:火影目标2:角色成长3:强者之路4:角色历练5:神宠神骑6:浴血沙场}
function ACK_HONOR_LIST_RETURN.getType(self)
	return self.type
end

-- {数量}
function ACK_HONOR_LIST_RETURN.getCount(self)
	return self.count
end

-- {荣誉ID}
function ACK_HONOR_LIST_RETURN.getId(self)
	return self.id
end

-- {0:未完成1:完成未领取2:已领取}
function ACK_HONOR_LIST_RETURN.getState(self)
	return self.state
end

-- {进度当前值}
function ACK_HONOR_LIST_RETURN.getValue(self)
	return self.value
end
