
require "common/AcknowledgementMessage"

-- [6520]技能列表数据 -- 技能系统 

ACK_SKILL_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_LIST
	self:init()
end)

function ACK_SKILL_LIST.deserialize(self, reader)
    print("\n============[6520]技能列表数据============")
    
	self.power = reader:readInt32Unsigned() -- {潜能}
    
	    print("============ACK_SKILL_LIST============", self.power)
end

-- {银子}
function ACK_SKILL_LIST.getGold(self)
	return self.gold
end

-- {元宝}
function ACK_SKILL_LIST.getRmb(self)
	return self.rmb
end

-- {潜能}
function ACK_SKILL_LIST.getPower(self)
	return self.power
end

-- {技能等级类型}
function ACK_SKILL_LIST.getRmbBind(self)
	return self.rmb_bind
end
