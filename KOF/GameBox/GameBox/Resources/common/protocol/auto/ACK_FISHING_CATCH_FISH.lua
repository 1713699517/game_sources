
require "common/AcknowledgementMessage"

-- [18030]钓到鱼了 -- 活动-钓鱼达人 

ACK_FISHING_CATCH_FISH = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FISHING_CATCH_FISH
	self:init()
end)

function ACK_FISHING_CATCH_FISH.deserialize(self, reader)
	self.num = reader:readInt8Unsigned() -- {浮漂编号}
	self.fish_type = reader:readInt8Unsigned() -- {鱼的品阶常量CONST_FISHING_FISH_TYPE_XXX}
end

-- {浮漂编号}
function ACK_FISHING_CATCH_FISH.getNum(self)
	return self.num
end

-- {鱼的品阶常量CONST_FISHING_FISH_TYPE_XXX}
function ACK_FISHING_CATCH_FISH.getFishType(self)
	return self.fish_type
end
