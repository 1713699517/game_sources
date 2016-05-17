
require "common/AcknowledgementMessage"

-- [2060]获得|失去物品通知 -- 物品/背包 

ACK_GOODS_CHANGE_NOTICE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_CHANGE_NOTICE
	self:init()
end)

-- {true:获得 | false:失去}
function ACK_GOODS_CHANGE_NOTICE.getSwitchs(self)
	return self.switchs
end

-- {1:背包 3:临时背包}
function ACK_GOODS_CHANGE_NOTICE.getType(self)
	return self.type
end

-- {数量}
function ACK_GOODS_CHANGE_NOTICE.getCount(self)
	return self.count
end

-- {物品ID}
function ACK_GOODS_CHANGE_NOTICE.getGoodsId(self)
	return self.goods_id
end

-- {物品数量}
function ACK_GOODS_CHANGE_NOTICE.getGoodsCount(self)
	return self.goods_count
end
