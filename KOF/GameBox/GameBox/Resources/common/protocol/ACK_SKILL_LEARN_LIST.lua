
require "common/AcknowledgementMessage"

-- [6549]返回该职业所能学习的技能 -- 技能系统 

ACK_SKILL_LEARN_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_LEARN_LIST
	self:init()
end)

function ACK_SKILL_LEARN_LIST.deserialize(self, reader)
    print("------ACK_SKILL_LEARN_LIST.deserialize")
	self.count = reader:readInt16Unsigned() -- {循环数量}
    --print("{循环数量}=", self.count)
    if self.count <= 0 then
        --CCMessageBox("ACK_SKILL_LEARN_LIST.deserialize self.count faild!","Error!")
        CCLOG("codeError!!!! ACK_SKILL_LEARN_LIST.deserialize self.count faild!")
        return;
    end
    
    self.skill_id = {}
    for i=self.count, 1, -1 do
        self.skill_id[i] = reader:readInt32Unsigned() -- {技能id}
        -- print(i,"===", self.skill_id[i])
    end
end

-- {循环数量}
function ACK_SKILL_LEARN_LIST.getCount(self)
	return self.count
end

-- {技能id}
function ACK_SKILL_LEARN_LIST.getSkillId(self)
	return self.skill_id
end
