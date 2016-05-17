
require "common/AcknowledgementMessage"

-- [23010]宠物游戏奖励数据 -- 宠物 

ACK_PET_GAME_REWARD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_GAME_REWARD
	self:init()
end)

-- {游戏类型}
function ACK_PET_GAME_REWARD.getType(self)
	return self.type
end

-- {货币类型}
function ACK_PET_GAME_REWARD.getTypeC(self)
	return self.type_c
end

-- {货币值}
function ACK_PET_GAME_REWARD.getValue(self)
	return self.value
end

-- {true:有|false:无物品}
function ACK_PET_GAME_REWARD.getIfGoods(self)
	return self.if_goods
end

-- {物品2001信息块}
function ACK_PET_GAME_REWARD.getMsg(self)
	return self.msg
end
