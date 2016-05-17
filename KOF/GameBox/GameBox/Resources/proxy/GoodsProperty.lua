

require "common/Constant"


-- {物品普通属性}
-- 直接将协议放进来

CGoodsProperty = class( function ( self )
    self.is_data                = nil  --是否有数据
    self.index                  = nil  --所在容器位置索引
    self.goods_id               = nil  --物品ID
    self.goods_num              = nil  --重叠数量
    self.expiry                 = nil  --失效时间（秒）
    self.time                   = nil  --物品获得时间
    self.price                  = nil  --出售价格
    self.goods_type             = nil  --物品大类
    self.powerful               = nil  --装备评分
    self.pearl_score            = nil  --灵珠评分
    self.suit_id                = nil  --所属的套装ID 
    self.wskill_id              = nil  --武器技能
    self.attr_count             = nil  --基础属性数量
    self.attr_data              = {}   --信息块(基础属性类型 基础属性数值) 
    self.strengthen             = nil  --强化等级
    self.plus_count             = nil  --附家属性数量
    self.plus_msg_no            = {}   --附家属性信息块    
    self.slots_count            = nil  --插槽个数
    self.slot_group             = {}   --插槽块(宝石)
    self.attr1                  = nil  --动态1
    self.attr2                  = nil  --动态2
    self.attr3                  = nil  --动态3
    self.attr4                  = nil  --动态4

    --self.funList                = {} --函数列表(方便传值拿方法)
    --self : initFunList()
end)


-- {是否有数据}
function CGoodsProperty.getIs_data(self)
    return self.is_data
end
function CGoodsProperty.setIs_data(self, _is_data )
    self.is_data = _is_data
end

-- {所在容器位置索引}
function CGoodsProperty.getIndex(self)
    return self.index
end
function CGoodsProperty.setIndex(self, _index )
    self.index= _index
end

-- {物品ID}
function CGoodsProperty.getGoods_id(self)
    return self.goods_id
end
function CGoodsProperty.setGoods_id(self, _goods_id )
    self.goods_id = _goods_id
end

-- {重叠数量}
function CGoodsProperty.getGoods_num(self)
    return self.goods_num
end
function CGoodsProperty.setGoods_num(self, _goods_num )
    self.goods_num = _goods_num
end

-- {失效时间}
function CGoodsProperty.getExpiry(self)
    return self.expiry
end
function CGoodsProperty.setExpiry(self, _expiry )
    self.expiry = _expiry
end

-- {物品获得时间}
function CGoodsProperty.getTime(self)
    return self.time
end
function CGoodsProperty.setTime(self, _time )
    self.time = _time
end

-- {出售价格}
function CGoodsProperty.getPrice(self)
    return self.price
end
function CGoodsProperty.setPrice(self, _price )
    self.price = _price
end

-- {物品大类}
function CGoodsProperty.getGoods_type(self)
    return self.goods_type
end
function CGoodsProperty.setGoods_type(self, _goods_type )
    self.goods_type = _goods_type
end

-- {装备评分}
function CGoodsProperty.getPowerful(self)
    return self.powerful
end
function CGoodsProperty.setPowerful(self, _powerful )
    self.powerful = _powerful
end

-- {灵珠评分}
function CGoodsProperty.getPearl_score(self)
    return self.pearl_score
end
function CGoodsProperty.setPearl_score(self, _pearl_score )
    self.pearl_score = _pearl_score
end

-- {所属的套装ID}
function CGoodsProperty.getSuit_id(self)
    return self.suit_id
end
function CGoodsProperty.setSuit_id(self, _suit_id )
    self.suit_id = _suit_id
end

-- {武器技能}
function CGoodsProperty.getWskill_id(self)
    return self.wskill_id
end
function CGoodsProperty.setWskill_id(self, _wskill_id )
    self.wskill_id = _wskill_id
end
    
-- {基础属性数量}
function CGoodsProperty.getAttr_count(self)
    return self.attr_count
end
function CGoodsProperty.setAttr_count(self, _attr_count )
    self.attr_count = _attr_count
end
    
-- {信息块}
function CGoodsProperty.getAttr_data(self)
    return self.attr_data
end
function CGoodsProperty.setAttr_data(self, _attr_data )
    self.attr_data = _attr_data
end
    
-- {强化等级}
function CGoodsProperty.getStrengthen(self)
    return self.strengthen
end
function CGoodsProperty.setStrengthen(self, _strengthen )
    self.strengthen = _strengthen
end

-- {附家属性数量}
function CGoodsProperty.getPlus_count(self)
    return self.plus_count
end
function CGoodsProperty.setPlus_count(self, _plus_count )
    self.plus_count = _plus_count
end

-- {附属性信息块}
function CGoodsProperty.getPlus_msg_no(self)
    return self.plus_msg_no
end
function CGoodsProperty.setPlus_msg_no(self, _plus_msg_no )
    self.plus_msg_no = _plus_msg_no
end

-- {插槽个数}
function CGoodsProperty.getSlots_count(self)
    return self.slots_count
end
function CGoodsProperty.setSlots_count(self, _slots_count )
    self.slots_count = _slots_count
end

-- {插槽块}
function CGoodsProperty.getSlot_group(self)
    return self.slot_group
end
function CGoodsProperty.setSlot_group(self, _slot_group )
    self.slot_group = slot_group
end

-- {动态1}
function CGoodsProperty.getAttr1(self)
    return self.attr1
end
function CGoodsProperty.setAttr1(self, _attr1 )
    self.attr1 = _attr1
end

 -- {动态2}
function CGoodsProperty.getAttr2(self)
    return self.attr2
end
function CGoodsProperty.setAttr1(self, _attr2 )
    self.attr2 = _attr2
end

-- {动态3}
function CGoodsProperty.getAttr3(self)
    return self.attr3
end
function CGoodsProperty.setAttr1(self, _attr3 )
    self.attr3 = _attr3
end

-- {动态4}
function CGoodsProperty.getAttr4(self)
    return self.attr4
end
function CGoodsProperty.setAttr4(self, _attr4 )
    self.attr4 = _attr4
end











































