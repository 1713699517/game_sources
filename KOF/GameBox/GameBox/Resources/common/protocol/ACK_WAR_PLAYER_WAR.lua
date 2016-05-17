
require "common/AcknowledgementMessage"

require "common/protocol/ACK_GOODS_XXX2"
require "common/protocol/ACK_SKILL_EQUIP_INFO"

-- [6010]战斗数据块 -- 战斗

ACK_WAR_PLAYER_WAR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_PLAYER_WAR
	self:init()
end)

function ACK_WAR_PLAYER_WAR.deserialize(self, reader)
    self.uid = reader:readInt32Unsigned() -- {用户ID}
    self.name = reader:readString() -- {玩家名字}
    self.lv = reader:readInt8Unsigned() -- {玩家等级}
    self.pro = reader:readInt8Unsigned() -- {玩家职业}
    self.sex = reader:readInt8Unsigned() -- {玩家性别}
    self.skin_weapon = reader:readInt16Unsigned() -- {武器皮肤}
    self.skin_armor = reader:readInt16Unsigned() -- {衣服皮肤}
    self.rank = reader:readInt16Unsigned() -- {逐鹿台排名}
    self.attr = ACK_GOODS_XXX2()-- {信息块(2002)}
    self.attr : deserialize( reader )
    self.skill_count = reader:readInt16Unsigned() -- {技能数量}
    self.skill_data = {}
    for i=1,self.skill_count do
        self.skill_data[i] = ACK_SKILL_EQUIP_INFO()-- {技能信息块(6545)}
        self.skill_data[i] : deserialize( reader )
    end
end

-- {用户ID}
function ACK_WAR_PLAYER_WAR.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_WAR_PLAYER_WAR.getName(self)
	return self.name
end

-- {玩家等级}
function ACK_WAR_PLAYER_WAR.getLv(self)
	return self.lv
end

-- {玩家职业}
function ACK_WAR_PLAYER_WAR.getPro(self)
	return self.pro
end

-- {玩家性别}
function ACK_WAR_PLAYER_WAR.getSex(self)
	return self.sex
end

-- {武器皮肤}
function ACK_WAR_PLAYER_WAR.getSkinWeapon(self)
	return self.skin_weapon
end

-- {衣服皮肤}
function ACK_WAR_PLAYER_WAR.getSkinArmor(self)
	return self.skin_armor
end

-- {逐鹿台排名}
function ACK_WAR_PLAYER_WAR.getRank(self)
	return self.rank
end

-- {信息块(2002)}
function ACK_WAR_PLAYER_WAR.getAttr(self)
	return self.attr
end

-- {技能数量}
function ACK_WAR_PLAYER_WAR.getSkillCount(self)
	return self.skill_count
end

-- {技能信息块(6530)}
function ACK_WAR_PLAYER_WAR.getSkillData(self)
	return self.skill_data
end
