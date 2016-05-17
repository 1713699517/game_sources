
require "common/AcknowledgementMessage"

-- [22801]宠物消息块 -- 宠物 

ACK_PET_PET = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_PET
	self:init()
end)

-- {有无宠物（true:有|false:无）}
function ACK_PET_PET.getFlag(self)
	return self.flag
end

-- {宠物唯一ID}
function ACK_PET_PET.getPuid(self)
	return self.puid
end

-- {宠物等级}
function ACK_PET_PET.getLv(self)
	return self.lv
end

-- {宠物名称}
function ACK_PET_PET.getName(self)
	return self.name
end

-- {宠物战斗力}
function ACK_PET_PET.getPower(self)
	return self.power
end

-- {等阶}
function ACK_PET_PET.getStep(self)
	return self.step
end

-- {等级当前经验值}
function ACK_PET_PET.getExpLv(self)
	return self.exp_lv
end

-- {下一等级经验值}
function ACK_PET_PET.getExpLvNext(self)
	return self.exp_lv_next
end

-- {等阶当前经验值}
function ACK_PET_PET.getStepExp(self)
	return self.step_exp
end

-- {下一等阶升级经验}
function ACK_PET_PET.getStepExpNext(self)
	return self.step_exp_next
end

-- {生命值（现有）}
function ACK_PET_PET.getHp(self)
	return self.hp
end

-- {能力值（现有）}
function ACK_PET_PET.getMp(self)
	return self.mp
end

-- {生命灵性}
function ACK_PET_PET.getSpiritHp(self)
	return self.spirit_hp
end

-- {攻击灵性}
function ACK_PET_PET.getSpiritAttack(self)
	return self.spirit_attack
end

-- {防御灵性}
function ACK_PET_PET.getSpiritDefense(self)
	return self.spirit_defense
end

-- {健体灵性}
function ACK_PET_PET.getSpiritHealthy(self)
	return self.spirit_healthy
end

-- {附身属性百分比}
function ACK_PET_PET.getAttach(self)
	return self.attach
end

-- {隐藏属性}
function ACK_PET_PET.getHide(self)
	return self.hide
end

-- {生命上限}
function ACK_PET_PET.getHpMax(self)
	return self.hp_max
end

-- {能力上限}
function ACK_PET_PET.getMpMax(self)
	return self.mp_max
end

-- {攻击}
function ACK_PET_PET.getAtt(self)
	return self.att
end

-- {防御}
function ACK_PET_PET.getDef(self)
	return self.def
end

-- {命中}
function ACK_PET_PET.getHit(self)
	return self.hit
end

-- {闪避}
function ACK_PET_PET.getDod(self)
	return self.dod
end

-- {暴击}
function ACK_PET_PET.getCri(self)
	return self.cri
end

-- {坚韧}
function ACK_PET_PET.getTough(self)
	return self.tough
end

-- {速度}
function ACK_PET_PET.getSpeed(self)
	return self.speed
end

-- {暗抗}
function ACK_PET_PET.getDark(self)
	return self.dark
end

-- {火抗}
function ACK_PET_PET.getFire(self)
	return self.fire
end

-- {电抗}
function ACK_PET_PET.getThunder(self)
	return self.thunder
end

-- {水抗}
function ACK_PET_PET.getWater(self)
	return self.water
end

-- {土抗}
function ACK_PET_PET.getSoil(self)
	return self.soil
end

-- {宠物状态（0：出战；1：附体）}
function ACK_PET_PET.getState(self)
	return self.state
end
