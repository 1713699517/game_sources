
require "common/AcknowledgementMessage"

-- [18017]可收取鱼数据块 -- 活动-钓鱼达人 

ACK_FISHING_FISH_DATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FISHING_FISH_DATE
	self:init()
end)

function ACK_FISHING_FISH_DATE.deserialize(self, reader)
	self.num = reader:readInt8Unsigned() -- {浮漂编号}
	self.fish_type = reader:readInt8Unsigned() -- {鱼的品阶常量CONST_FISHING_FISH_TYPE_XXX}
end

-- {浮漂编号}
function ACK_FISHING_FISH_DATE.getNum(self)
	return self.num
end

-- {鱼的品阶常量CONST_FISHING_FISH_TYPE_XXX}
function ACK_FISHING_FISH_DATE.getFishType(self)
	return self.fish_type
end
