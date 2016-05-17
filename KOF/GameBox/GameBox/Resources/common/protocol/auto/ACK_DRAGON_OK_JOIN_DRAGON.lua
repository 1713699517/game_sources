
require "common/AcknowledgementMessage"

-- [34020]请求界面成功 -- 活动-龙宫寻宝 

ACK_DRAGON_OK_JOIN_DRAGON = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DRAGON_OK_JOIN_DRAGON
	self:init()
end)

function ACK_DRAGON_OK_JOIN_DRAGON.deserialize(self, reader)
	self.viplv = reader:readInt8Unsigned() -- {VIP等级}
	self.treasure = reader:readInt32Unsigned() -- {寻宝令数量}
end

-- {VIP等级}
function ACK_DRAGON_OK_JOIN_DRAGON.getViplv(self)
	return self.viplv
end

-- {寻宝令数量}
function ACK_DRAGON_OK_JOIN_DRAGON.getTreasure(self)
	return self.treasure
end
