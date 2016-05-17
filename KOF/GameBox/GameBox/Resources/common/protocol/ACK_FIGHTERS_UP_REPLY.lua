
require "common/AcknowledgementMessage"

-- (手动) -- [55870]挂机返回 -- 拳皇生涯 

ACK_FIGHTERS_UP_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_UP_REPLY
	self:init()
end)

function ACK_FIGHTERS_UP_REPLY.deserialize(self, reader)
	self.chap_id = reader:readInt16Unsigned() -- {挂到这个章节}
	self.copy_id = reader:readInt16Unsigned() -- {挂机这个副本}
	self.exp = reader:readInt32Unsigned()     -- {经验}
	self.gold = reader:readInt32Unsigned()    -- {铜钱}
	self.power = reader:readInt32Unsigned()   -- {战功}
	self.num = reader:readInt16Unsigned()     -- {物品数量}
	--self.data = reader:readXXXGroup()       -- {物品信息块(5575)}
    local i = 1
    self.goods = {}
    while i <= self.num do
        self.goods[i] = {}
        self.goods[i].goold_id  = reader:readInt16Unsigned() -- {物品Id}
        self.goods[i].count     = reader:readInt16Unsigned()  -- {物品数量}
        print("------>>lllllll",self.goods[i].goold_id,self.goods[i].count )
        i = i + 1
    end
end

-- {挂到这个章节}
function ACK_FIGHTERS_UP_REPLY.getChapId(self)
	return self.chap_id
end

-- {挂机这个副本}
function ACK_FIGHTERS_UP_REPLY.getCopyId(self)
	return self.copy_id
end

-- {经验}
function ACK_FIGHTERS_UP_REPLY.getExp(self)
	return self.exp
end

-- {铜钱}
function ACK_FIGHTERS_UP_REPLY.getGold(self)
	return self.gold
end

-- {战功}
function ACK_FIGHTERS_UP_REPLY.getPower(self)
	return self.power
end

-- {物品数量}
function ACK_FIGHTERS_UP_REPLY.getNum(self)
	return self.num
end

-- {物品信息块(5575)}
function ACK_FIGHTERS_UP_REPLY.getData(self)
	return self.goods
end
