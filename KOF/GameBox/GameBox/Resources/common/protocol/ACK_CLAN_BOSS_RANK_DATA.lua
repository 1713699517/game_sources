
require "common/AcknowledgementMessage"

-- [54250]界面信息返回--排行榜信息 -- 社团BOSS 

ACK_CLAN_BOSS_RANK_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_RANK_DATA
	self:init()
end)

function ACK_CLAN_BOSS_RANK_DATA.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	self.role_msg = reader:readXXXGroup() -- {玩家信息块【54255】}
end

-- {数量}
function ACK_CLAN_BOSS_RANK_DATA.getCount(self)
	return self.count
end

-- {玩家信息块【54255】}
function ACK_CLAN_BOSS_RANK_DATA.getRoleMsg(self)
	return self.role_msg
end
