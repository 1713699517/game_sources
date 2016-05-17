
require "common/AcknowledgementMessage"

-- [6540]返回该技能id信息 -- 技能系统 

ACK_SKILL_SKILLID_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_SKILLID_INFO
	self:init()
end)

function ACK_SKILL_SKILLID_INFO.deserialize(self, reader)
    CCLOG("```````ACK_SKILL_SKILLID_INFO.deserialize")
	--[[
     self.type = reader:readInt8Unsigned() -- {0:学习|1:升级}
	self.power = reader:readInt32Unsigned() -- {达到下一级所需的元宝}
	self.money = reader:readInt32Unsigned() -- {达到下一级所需的潜能}
     --]]
    self.m_nSkillNum = reader:readInt16Unsigned()
    
    print("已经学习的技能数量===", self.m_nSkillNum)
    self.m_skill_study_list = {}
    if self.m_nSkillNum > 0 then
        
        
        local nCount = 1
        while nCount <= self.m_nSkillNum do
            self.m_skill_study_list[nCount] = {}
            
            self.m_skill_study_list[nCount].skill_id = reader:readInt32Unsigned()       --技能id
            self.m_skill_study_list[nCount].now_lv = reader:readInt32Unsigned()         --当前强化等级
            
            print("技能id--"..self.m_skill_study_list[nCount].skill_id)
            print("技能lv--"..self.m_skill_study_list[nCount].now_lv)
     
            nCount = nCount + 1
        end
    else
        CCLOG("～～莫非木数据?~!")
    end
    
    
    
end

function ACK_SKILL_SKILLID_INFO.getCount( self)
   return self.m_nSkillNum
end

function ACK_SKILL_SKILLID_INFO.getSkillStudyList( self)
   return self.m_skill_study_list
end



--[[ {0:学习|1:升级}
function ACK_SKILL_SKILLID_INFO.getType(self)
	return self.type
end

-- {达到下一级所需的元宝}
function ACK_SKILL_SKILLID_INFO.getPower(self)
	return self.power
end

-- {达到下一级所需的潜能}
function ACK_SKILL_SKILLID_INFO.getMoney(self)
	return self.money
end
--]]