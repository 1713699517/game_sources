
require "common/AcknowledgementMessage"

-- (手动) -- [22820]返回魔宠信息列表 -- 宠物

ACK_PET_REVERSE = class(CAcknowledgementMessage,function(self)
                        self.MsgID = Protocol.ACK_PET_REVERSE
                        self:init()
                        end)

function ACK_PET_REVERSE.deserialize(self, reader)
	self.lv       = reader:readInt8Unsigned()   -- {宠物等级}
	self.skin_id  = reader:readInt16Unsigned()  -- {皮肤id}
	self.skill_id = reader:readInt16Unsigned()  -- {技能id}
	self.exp      = reader:readInt16Unsigned()  -- {当前经验值}
    
	self.count    = reader:readInt8Unsigned()   -- {式神数量}
    print("-----------------44444--------",self.lv,self.skin_id,self.skill_id,self.exp,self.count)
    self.MsgSkill = {}
    local icount  = 1
    while icount <= self.count do
        self.MsgSkill[icount] = reader:readInt16Unsigned()
        icount = icount + 1
    end
    
	self.count2    = reader:readInt8Unsigned()   -- {皮肤数量} 
    print("self.count2===",self.count2)
    self.MsgSkin   = {}
    local icount2  = 1
    while icount2 <= self.count2 do
        --print ("妥妥的是不是",reader:readInt16Unsigned())
        self.MsgSkin[icount2] = reader:readInt16Unsigned()
        print("然后呢？？",self.MsgSkin[icount2])
        icount2 = icount2 + 1
    end
end

-- {宠物等级}
function ACK_PET_REVERSE.getLv(self)
	return self.lv
end

-- {皮肤id}
function ACK_PET_REVERSE.getSkinId(self)
	return self.skin_id
end

-- {技能id}
function ACK_PET_REVERSE.getSkillId(self)
	return self.skill_id
end

-- {当前经验值}
function ACK_PET_REVERSE.getExp(self)
	return self.exp
end

-- {式神数量}
function ACK_PET_REVERSE.getCount(self)
	return self.count
end

-- {技能信息块(22825)}
function ACK_PET_REVERSE.getMsgSkill(self)
	return self.MsgSkill
end

-- {皮肤数量}
function ACK_PET_REVERSE.getCount2(self)
	return self.count2
end

-- {皮肤信息块(22827)}
function ACK_PET_REVERSE.getMsgSkin(self)
	return self.MsgSkin
end
