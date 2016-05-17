
require "common/AcknowledgementMessage"

-- [54260]鼓舞属性加成 -- 社团BOSS 

ACK_CLAN_BOSS_BUFF_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_BUFF_DATA
	self:init()
end)

function ACK_CLAN_BOSS_BUFF_DATA.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	self.buff_msg = reader:readXXXGroup() -- {属性加成信息块【54265】}
end

-- {数量}
function ACK_CLAN_BOSS_BUFF_DATA.getCount(self)
	return self.count
end

-- {属性加成信息块【54265】}
function ACK_CLAN_BOSS_BUFF_DATA.getBuffMsg(self)
	return self.buff_msg
end
