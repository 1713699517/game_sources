
require "common/AcknowledgementMessage"

-- [33210]返回社团技能面板数据 -- 社团 

ACK_CLAN_OK_CLAN_SKILL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_CLAN_SKILL
	self:init()
end)

function ACK_CLAN_OK_CLAN_SKILL.deserialize(self, reader)
	self.stamina = reader:readInt32Unsigned() -- {体能点数}
	self.count = reader:readInt16Unsigned() -- {数量}
    print("体能点数:"..self.stamina.." 技能数量:"..self.count)
	--self.attr_msg = reader:readXXXGroup() -- {属性数据块【33215】}
    local icount = 1
    self.attr_msg = {}
    while icount <= self.count do
        print("第 "..icount.." 个属性数据:")
        local tempData = ACK_CLAN_CLAN_ATTR_DATA()
        tempData :deserialize( reader)
        self.attr_msg[icount] = tempData
        icount = icount + 1
    end
end

-- {体能点数}
function ACK_CLAN_OK_CLAN_SKILL.getStamina(self)
	return self.stamina
end

-- {数量}
function ACK_CLAN_OK_CLAN_SKILL.getCount(self)
	return self.count
end

-- {属性数据块【33215】}
function ACK_CLAN_OK_CLAN_SKILL.getAttrMsg(self)
	return self.attr_msg
end
