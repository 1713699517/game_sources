
require "common/AcknowledgementMessage"

-- [21220]战斗结果返回 -- 活动-保卫经书 

ACK_DEFEND_BOOK_WAR_RETRUN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_WAR_RETRUN
	self:init()
end)

function ACK_DEFEND_BOOK_WAR_RETRUN.deserialize(self, reader)
	self.gmid = reader:readInt32Unsigned() -- {被攻击的怪物 Id}
	self.harm = reader:readInt32Unsigned() -- {伤害量}
end

-- {被攻击的怪物 Id}
function ACK_DEFEND_BOOK_WAR_RETRUN.getGmid(self)
	return self.gmid
end

-- {伤害量}
function ACK_DEFEND_BOOK_WAR_RETRUN.getHarm(self)
	return self.harm
end
