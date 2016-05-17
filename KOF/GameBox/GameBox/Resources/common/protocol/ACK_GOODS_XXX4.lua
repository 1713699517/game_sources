
require "common/AcknowledgementMessage"

-- [2004]装备打造附加块 -- 物品/背包 

ACK_GOODS_XXX4 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_XXX4
	self:init()
end)


function ACK_GOODS_XXX4.deserialize(self, reader)
    self.plus_type       = reader:readInt8Unsigned()  -- {附加属性类型}
    self.plus_colour     = reader:readInt8Unsigned()  -- {附加属性颜色}
    self.plus_current    = reader:readInt16Unsigned() -- {当前附加属性}
    self.plus_max        = reader:readInt16Unsigned() -- {附加属性上限}
    print("装备打造 附加属性类型:"..self.plus_type.."属性颜色:"..self.plus_colour.."当前属性:"..self.plus_current)
end

-- {附加属性类型 (组:装备-打造-附加)}
function ACK_GOODS_XXX4.getPlusType(self)
	return self.plus_type
end

-- {附加属性颜色 (组:装备-打造-附加)}
function ACK_GOODS_XXX4.getPlusColour(self)
	return self.plus_colour
end

-- {当前附加属性 (组:装备-打造-附加)}
function ACK_GOODS_XXX4.getPlusCurrent(self)
	return self.plus_current
end

-- {附加属性上限 (组:装备-打造-附加)}
function ACK_GOODS_XXX4.getPlusMax(self)
	return self.plus_max
end
