
require "common/AcknowledgementMessage"

-- [54265]属性加成信息块 -- 社团BOSS 

ACK_CLAN_BOSS_BUFF_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_BOSS_BUFF_MSG
	self:init()
end)

function ACK_CLAN_BOSS_BUFF_MSG.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {属性类型 CONST_ATTR_}
	self.value = reader:readInt32Unsigned() -- {数值}
end

-- {属性类型 CONST_ATTR_}
function ACK_CLAN_BOSS_BUFF_MSG.getType(self)
	return self.type
end

-- {数值}
function ACK_CLAN_BOSS_BUFF_MSG.getValue(self)
	return self.value
end
