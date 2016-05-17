
require "common/RequestMessage"

-- [52300]请求下一级属性 -- 神器 

REQ_MAGIC_EQUIP_ASK_NEXT_ATTR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAGIC_EQUIP_ASK_NEXT_ATTR
	self:init(0, nil)
end)

function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.serialize(self, writer)
	writer:writeInt8Unsigned(self.type_sub)  -- {子类}
	writer:writeInt8Unsigned(self.lv)  -- {等级}
	writer:writeInt8Unsigned(self.color)  -- {颜色}
	writer:writeInt8Unsigned(self.class)  -- {等阶}
end

function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.setArguments(self,type_sub,lv,color,class)
	self.type_sub = type_sub  -- {子类}
	self.lv = lv  -- {等级}
	self.color = color  -- {颜色}
	self.class = class  -- {等阶}
end

-- {子类}
function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.setTypeSub(self, type_sub)
	self.type_sub = type_sub
end
function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.getTypeSub(self)
	return self.type_sub
end

-- {等级}
function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.setLv(self, lv)
	self.lv = lv
end
function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.getLv(self)
	return self.lv
end

-- {颜色}
function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.setColor(self, color)
	self.color = color
end
function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.getColor(self)
	return self.color
end

-- {等阶}
function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.setClass(self, class)
	self.class = class
end
function REQ_MAGIC_EQUIP_ASK_NEXT_ATTR.getClass(self)
	return self.class
end
