
require "common/AcknowledgementMessage"

-- [2532]洗练数据返回 -- 物品/打造/强化 

ACK_MAKE_WASH_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAKE_WASH_BACK
	self:init()
end)

-- {洗练方式(常量定义)}
function ACK_MAKE_WASH_BACK.getArg(self)
	return self.arg
end

-- {技能ID}
function ACK_MAKE_WASH_BACK.getSkillId(self)
	return self.skill_id
end

-- {数量}
function ACK_MAKE_WASH_BACK.getCount(self)
	return self.count
end

-- {附加属性块(2535)}
function ACK_MAKE_WASH_BACK.getMsgXxx(self)
	return self.msg_xxx
end
