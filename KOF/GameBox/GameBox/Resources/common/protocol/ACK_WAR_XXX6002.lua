
require "common/AcknowledgementMessage"

-- [6002]数据结果包 -- 战斗 

ACK_WAR_XXX6002 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_XXX6002
	self:init()
end)

-- {站位 1:左边 2:右边(见常量)}
function ACK_WAR_XXX6002.getPosition(self)
	return self.position
end

-- {站位索引(后端1-9)(前端0-8)}
function ACK_WAR_XXX6002.getIdx(self)
	return self.idx
end

-- {0:正常，1:暴击}
function ACK_WAR_XXX6002.getIsCrit(self)
	return self.is_crit
end

-- {击方表现状态数量}
function ACK_WAR_XXX6002.getDisplayCount(self)
	return self.display_count
end

-- {击方表现状态       (见常量,表现状态CONST_WAR_DISPLAY_*)}
function ACK_WAR_XXX6002.getStatusDisplay(self)
	return self.status_display
end

-- {被击方结果状态  (见常量,战斗状态CONST_WAR_STATE_*)}
function ACK_WAR_XXX6002.getStatusResult(self)
	return self.status_result
end

-- {伤害-次数}
function ACK_WAR_XXX6002.getHarmCount(self)
	return self.harm_count
end

-- {被击方所受到的伤害}
function ACK_WAR_XXX6002.getHarm(self)
	return self.harm
end

-- {现有HP}
function ACK_WAR_XXX6002.getHp(self)
	return self.hp
end

-- {现有sp}
function ACK_WAR_XXX6002.getSp(self)
	return self.sp
end
