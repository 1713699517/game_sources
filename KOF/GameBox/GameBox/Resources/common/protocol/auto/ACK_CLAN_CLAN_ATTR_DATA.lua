
require "common/AcknowledgementMessage"

-- [33215]帮派技能属性数据块【33215】 -- 社团 

ACK_CLAN_CLAN_ATTR_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_CLAN_ATTR_DATA
	self:init()
end)

function ACK_CLAN_CLAN_ATTR_DATA.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {属性类型}
	self.skill_lv = reader:readInt8Unsigned() -- {技能等级}
	self.value = reader:readInt32Unsigned() -- {原有属性值}
	self.add_value = reader:readInt16Unsigned() -- {培养可增加属性值}
	self.cast = reader:readInt32Unsigned() -- {消费体能点数}
end

-- {属性类型}
function ACK_CLAN_CLAN_ATTR_DATA.getType(self)
	return self.type
end

-- {技能等级}
function ACK_CLAN_CLAN_ATTR_DATA.getSkillLv(self)
	return self.skill_lv
end

-- {原有属性值}
function ACK_CLAN_CLAN_ATTR_DATA.getValue(self)
	return self.value
end

-- {培养可增加属性值}
function ACK_CLAN_CLAN_ATTR_DATA.getAddValue(self)
	return self.add_value
end

-- {消费体能点数}
function ACK_CLAN_CLAN_ATTR_DATA.getCast(self)
	return self.cast
end
