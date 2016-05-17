
require "common/RequestMessage"

-- [2516]请求装备强化数据 -- 物品/打造/强化 

REQ_MAKE_STREN_DATA_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_STREN_DATA_ASK
	self:init(1 ,{ 2517,2519,700 })
end)

function REQ_MAKE_STREN_DATA_ASK.serialize(self, writer)
	writer:writeInt8Unsigned(self.ref)  -- {标识}
	writer:writeInt16Unsigned(self.goods_id)  -- {物品ID}
	writer:writeInt16Unsigned(self.stren_lv)  -- {强化等级}
	writer:writeInt8Unsigned(self.color)  -- {颜色}
	writer:writeInt8Unsigned(self.type)  -- {物品大类}
	writer:writeInt8Unsigned(self.type_sub)  -- {物品子类}
	writer:writeInt8Unsigned(self.equip_class)  -- {等阶}
end

function REQ_MAKE_STREN_DATA_ASK.setArguments(self,ref,goods_id,stren_lv,color,type,type_sub,equip_class)
	self.ref = ref  -- {标识}
	self.goods_id = goods_id  -- {物品ID}
	self.stren_lv = stren_lv  -- {强化等级}
	self.color = color  -- {颜色}
	self.type = type  -- {物品大类}
	self.type_sub = type_sub  -- {物品子类}
	self.equip_class = equip_class  -- {等阶}
end

-- {标识}
function REQ_MAKE_STREN_DATA_ASK.setRef(self, ref)
	self.ref = ref
end
function REQ_MAKE_STREN_DATA_ASK.getRef(self)
	return self.ref
end

-- {物品ID}
function REQ_MAKE_STREN_DATA_ASK.setGoodsId(self, goods_id)
	self.goods_id = goods_id
end
function REQ_MAKE_STREN_DATA_ASK.getGoodsId(self)
	return self.goods_id
end

-- {强化等级}
function REQ_MAKE_STREN_DATA_ASK.setStrenLv(self, stren_lv)
	self.stren_lv = stren_lv
end
function REQ_MAKE_STREN_DATA_ASK.getStrenLv(self)
	return self.stren_lv
end

-- {颜色}
function REQ_MAKE_STREN_DATA_ASK.setColor(self, color)
	self.color = color
end
function REQ_MAKE_STREN_DATA_ASK.getColor(self)
	return self.color
end

-- {物品大类}
function REQ_MAKE_STREN_DATA_ASK.setType(self, type)
	self.type = type
end
function REQ_MAKE_STREN_DATA_ASK.getType(self)
	return self.type
end

-- {物品子类}
function REQ_MAKE_STREN_DATA_ASK.setTypeSub(self, type_sub)
	self.type_sub = type_sub
end
function REQ_MAKE_STREN_DATA_ASK.getTypeSub(self)
	return self.type_sub
end

-- {等阶}
function REQ_MAKE_STREN_DATA_ASK.setEquipClass(self, equip_class)
	self.equip_class = equip_class
end
function REQ_MAKE_STREN_DATA_ASK.getEquipClass(self)
	return self.equip_class
end
