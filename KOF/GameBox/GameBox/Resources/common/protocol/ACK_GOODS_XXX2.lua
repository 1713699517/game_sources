
require "common/AcknowledgementMessage"

-- [2002]属性信息块 -- 物品/背包

ACK_GOODS_XXX2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_XXX2
	self:init()
end)

function ACK_GOODS_XXX2.deserialize(self, reader)
	self.is_data = reader:readBoolean() -- {是否有数据 false:没 true:有}
	if self.is_data == false then
		return
	end
	self.sp = reader:readInt16Unsigned() -- {怒气}
	self.sp_speed = reader:readInt32Unsigned() -- {怒气回复速度}
	self.anima = reader:readInt32Unsigned() -- {灵气值}
	self.hp = reader:readInt32Unsigned() -- {气血值}
	self.hp_gro = reader:readInt16Unsigned() -- {气血成长值}
	self.strong = reader:readInt32Unsigned() -- {力量值}
	self.strong_gro = reader:readInt16Unsigned() -- {力量成长值}
	self.magic = reader:readInt32Unsigned() -- {灵力值}
	self.magic_gro = reader:readInt16Unsigned() -- {灵力攻击成长值}
	self.strong_att = reader:readInt32Unsigned() -- {力量物理攻击}
	self.strong_def = reader:readInt16Unsigned() -- {力量物理防御值}
	self.skill_att = reader:readInt32Unsigned() -- {技能攻击}
	self.skill_def = reader:readInt16Unsigned() -- {技能防御}
	self.crit = reader:readInt16Unsigned() -- {暴击值(万分比)}
	self.crit_res = reader:readInt16Unsigned() -- {抗暴值(万分比)}
	self.crit_harm = reader:readInt16Unsigned() -- {暴击伤害值(万分比)}
	self.wreck = reader:readInt16Unsigned() -- {破甲值(万分比)}
	self.light = reader:readInt16Unsigned() -- {光属性(万分比)}
	self.light_def = reader:readInt16Unsigned() -- {光抗性(万分比)}
	self.dark = reader:readInt16Unsigned() -- {暗属性(万分比)}
	self.dark_def = reader:readInt16Unsigned() -- {暗抗性(万分比)}
	self.god = reader:readInt16Unsigned() -- {灵属性(万分比)}
	self.god_def = reader:readInt16Unsigned() -- {灵抗性(万分比)}
	self.bonus = reader:readInt16Unsigned() -- {伤害系数(万分比)}
	self.reduction = reader:readInt16Unsigned() -- {免伤系数(万分比)}
	self.imm_dizz = reader:readInt16Unsigned() -- {抗晕值(万分比)}
end

-- {是否有数据 false:没 true:有}
function ACK_GOODS_XXX2.getIsData(self)
	return self.is_data
end

-- {怒气}
function ACK_GOODS_XXX2.getSp(self)
	return self.sp
end

-- {怒气回复速度}
function ACK_GOODS_XXX2.getSpSpeed(self)
	return self.sp_speed
end

-- {灵气值}
function ACK_GOODS_XXX2.getAnima(self)
	return self.anima
end

-- {气血值}
function ACK_GOODS_XXX2.getHp(self)
	return self.hp
end

-- {气血成长值}
function ACK_GOODS_XXX2.getHpGro(self)
	return self.hp_gro
end

-- {力量值}
function ACK_GOODS_XXX2.getStrong(self)
	return self.strong
end

-- {力量成长值}
function ACK_GOODS_XXX2.getStrongGro(self)
	return self.strong_gro
end

-- {灵力值}
function ACK_GOODS_XXX2.getMagic(self)
	return self.magic
end

-- {灵力攻击成长值}
function ACK_GOODS_XXX2.getMagicGro(self)
	return self.magic_gro
end

-- {力量物理攻击}
function ACK_GOODS_XXX2.getStrongAtt(self)
	return self.strong_att
end

-- {力量物理防御值}
function ACK_GOODS_XXX2.getStrongDef(self)
	return self.strong_def
end

-- {技能攻击}
function ACK_GOODS_XXX2.getSkillAtt(self)
	return self.skill_att
end

-- {技能防御}
function ACK_GOODS_XXX2.getSkillDef(self)
	return self.skill_def
end

-- {暴击值(万分比)}
function ACK_GOODS_XXX2.getCrit(self)
	return self.crit
end

-- {抗暴值(万分比)}
function ACK_GOODS_XXX2.getCritRes(self)
	return self.crit_res
end

-- {暴击伤害值(万分比)}
function ACK_GOODS_XXX2.getCritHarm(self)
	return self.crit_harm
end

-- {破甲值(万分比)}
function ACK_GOODS_XXX2.getWreck(self)
	return self.wreck
end

-- {光属性(万分比)}
function ACK_GOODS_XXX2.getLight(self)
	return self.light
end

-- {光抗性(万分比)}
function ACK_GOODS_XXX2.getLightDef(self)
	return self.light_def
end

-- {暗属性(万分比)}
function ACK_GOODS_XXX2.getDark(self)
	return self.dark
end

-- {暗抗性(万分比)}
function ACK_GOODS_XXX2.getDarkDef(self)
	return self.dark_def
end

-- {灵属性(万分比)}
function ACK_GOODS_XXX2.getGod(self)
	return self.god
end

-- {灵抗性(万分比)}
function ACK_GOODS_XXX2.getGodDef(self)
	return self.god_def
end

-- {伤害系数(万分比)}
function ACK_GOODS_XXX2.getBonus(self)
	return self.bonus
end

-- {免伤系数(万分比)}
function ACK_GOODS_XXX2.getReduction(self)
	return self.reduction
end

-- {抗晕值(万分比)}
function ACK_GOODS_XXX2.getImmDizz(self)
	return self.imm_dizz
end
