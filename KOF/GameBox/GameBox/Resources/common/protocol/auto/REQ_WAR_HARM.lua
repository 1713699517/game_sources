
require "common/RequestMessage"

-- [6020]战斗伤害广播 -- 战斗 

REQ_WAR_HARM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_HARM
	self:init(0, nil)
end)

function REQ_WAR_HARM.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {战斗类型(见常量CONST_WAR_PARAS_1_)}
	writer:writeInt8Unsigned(self.one_type)  -- {攻击对象类型}
	writer:writeInt32Unsigned(self.one_mid)  -- {攻击对象唯一ID}
	writer:writeInt32Unsigned(self.one_id)  -- {攻击对象ID}
	writer:writeInt8Unsigned(self.foe_type)  -- {被攻击对象类型}
	writer:writeInt8Unsigned(self.attr_type)  -- {攻击类型1:技能攻击，0:普通攻击}
	writer:writeInt16Unsigned(self.mid)  -- {怪物唯一ID，伙伴类型为主人UID,玩家为UID}
	writer:writeInt32Unsigned(self.id)  -- {怪物ID,伙伴ID}
	writer:writeInt16Unsigned(self.skill_id)  -- {技能id}
	writer:writeInt16Unsigned(self.lv)  -- {技能lv}
	writer:writeInt8Unsigned(self.stata)  -- {见通用常量?CONST_WAR_DISPLAY}
	writer:writeInt32Unsigned(self.harm)  -- {伤害}
end

function REQ_WAR_HARM.setArguments(self,type,one_type,one_mid,one_id,foe_type,attr_type,mid,id,skill_id,lv,stata,harm)
	self.type = type  -- {战斗类型(见常量CONST_WAR_PARAS_1_)}
	self.one_type = one_type  -- {攻击对象类型}
	self.one_mid = one_mid  -- {攻击对象唯一ID}
	self.one_id = one_id  -- {攻击对象ID}
	self.foe_type = foe_type  -- {被攻击对象类型}
	self.attr_type = attr_type  -- {攻击类型1:技能攻击，0:普通攻击}
	self.mid = mid  -- {怪物唯一ID，伙伴类型为主人UID,玩家为UID}
	self.id = id  -- {怪物ID,伙伴ID}
	self.skill_id = skill_id  -- {技能id}
	self.lv = lv  -- {技能lv}
	self.stata = stata  -- {见通用常量?CONST_WAR_DISPLAY}
	self.harm = harm  -- {伤害}
end

-- {战斗类型(见常量CONST_WAR_PARAS_1_)}
function REQ_WAR_HARM.setType(self, type)
	self.type = type
end
function REQ_WAR_HARM.getType(self)
	return self.type
end

-- {攻击对象类型}
function REQ_WAR_HARM.setOneType(self, one_type)
	self.one_type = one_type
end
function REQ_WAR_HARM.getOneType(self)
	return self.one_type
end

-- {攻击对象唯一ID}
function REQ_WAR_HARM.setOneMid(self, one_mid)
	self.one_mid = one_mid
end
function REQ_WAR_HARM.getOneMid(self)
	return self.one_mid
end

-- {攻击对象ID}
function REQ_WAR_HARM.setOneId(self, one_id)
	self.one_id = one_id
end
function REQ_WAR_HARM.getOneId(self)
	return self.one_id
end

-- {被攻击对象类型}
function REQ_WAR_HARM.setFoeType(self, foe_type)
	self.foe_type = foe_type
end
function REQ_WAR_HARM.getFoeType(self)
	return self.foe_type
end

-- {攻击类型1:技能攻击，0:普通攻击}
function REQ_WAR_HARM.setAttrType(self, attr_type)
	self.attr_type = attr_type
end
function REQ_WAR_HARM.getAttrType(self)
	return self.attr_type
end

-- {怪物唯一ID，伙伴类型为主人UID,玩家为UID}
function REQ_WAR_HARM.setMid(self, mid)
	self.mid = mid
end
function REQ_WAR_HARM.getMid(self)
	return self.mid
end

-- {怪物ID,伙伴ID}
function REQ_WAR_HARM.setId(self, id)
	self.id = id
end
function REQ_WAR_HARM.getId(self)
	return self.id
end

-- {技能id}
function REQ_WAR_HARM.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_WAR_HARM.getSkillId(self)
	return self.skill_id
end

-- {技能lv}
function REQ_WAR_HARM.setLv(self, lv)
	self.lv = lv
end
function REQ_WAR_HARM.getLv(self)
	return self.lv
end

-- {见通用常量?CONST_WAR_DISPLAY}
function REQ_WAR_HARM.setStata(self, stata)
	self.stata = stata
end
function REQ_WAR_HARM.getStata(self)
	return self.stata
end

-- {伤害}
function REQ_WAR_HARM.setHarm(self, harm)
	self.harm = harm
end
function REQ_WAR_HARM.getHarm(self)
	return self.harm
end
