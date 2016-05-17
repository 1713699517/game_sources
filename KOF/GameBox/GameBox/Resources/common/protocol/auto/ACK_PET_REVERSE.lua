
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
	--self.msg_skill = reader:readXXXGroup()      -- {技能信息块(22825)}
    print("-----------------44444--------",self.lv,self.skin_id,self.skill_id,self.exp,self.count)
    self.Msg = {}
    local icount = 1
    while icount <= self.count do
        self.Msg[icount].skill_id = reader:readInt16Unsigned()
        icount = icount + 1
        print("self.Msg[icount].skill_id===",self.Msg[icount].skill_id)
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
	return self.Msg
end
