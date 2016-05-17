
require "common/AcknowledgementMessage"

-- [6001]玩家/怪物数据结构 -- 战斗 

ACK_WAR_XXX6001 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_XXX6001
	self:init()
end)

-- {站位索引(后端1-9)(前端0-8)}
function ACK_WAR_XXX6001.getIdx(self)
	return self.idx
end

-- {HP}
function ACK_WAR_XXX6001.getHp(self)
	return self.hp
end

-- {最大HP}
function ACK_WAR_XXX6001.getHpMax(self)
	return self.hp_max
end

-- {SP}
function ACK_WAR_XXX6001.getSp(self)
	return self.sp
end

-- {1:玩家,2:伙伴 false:怪物}
function ACK_WAR_XXX6001.getType(self)
	return self.type
end

-- {用户ID}
function ACK_WAR_XXX6001.getUid(self)
	return self.uid
end

-- {服务器ID}
function ACK_WAR_XXX6001.getSid(self)
	return self.sid
end

-- {昵称}
function ACK_WAR_XXX6001.getName(self)
	return self.name
end

-- {角色名颜色}
function ACK_WAR_XXX6001.getNameColor(self)
	return self.name_color
end

-- {性别}
function ACK_WAR_XXX6001.getSex(self)
	return self.sex
end

-- {职业}
function ACK_WAR_XXX6001.getPro(self)
	return self.pro
end

-- {等级}
function ACK_WAR_XXX6001.getLv(self)
	return self.lv
end

-- {装备武器SkinID}
function ACK_WAR_XXX6001.getWeapon(self)
	return self.weapon
end

-- {装备衣服SkinID}
function ACK_WAR_XXX6001.getArmor(self)
	return self.armor
end

-- {坐骑ID}
function ACK_WAR_XXX6001.getMount(self)
	return self.mount
end

-- {技能ID}
function ACK_WAR_XXX6001.getSkillId(self)
	return self.skill_id
end

-- {星魂}
function ACK_WAR_XXX6001.getTried(self)
	return self.tried
end

-- {VIP等级}
function ACK_WAR_XXX6001.getVip(self)
	return self.vip
end

-- {伙伴等级}
function ACK_WAR_XXX6001.getPartnerLv(self)
	return self.partner_lv
end

-- {伙伴ID}
function ACK_WAR_XXX6001.getPartnerId(self)
	return self.partner_id
end

-- {伙伴技能ID}
function ACK_WAR_XXX6001.getPSkillId(self)
	return self.p_skill_id
end

-- {怪物/宠物 生成ID}
function ACK_WAR_XXX6001.getMonsterMid(self)
	return self.monster_mid
end

-- {怪物/宠物 ID}
function ACK_WAR_XXX6001.getMonsterId(self)
	return self.monster_id
end

-- {怪物/宠物 等级}
function ACK_WAR_XXX6001.getMonsterLv(self)
	return self.monster_lv
end
