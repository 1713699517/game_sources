require "controller/command"

CSkillInitCommand = class( command, function( self, _data_model )
    self.m_type = "TYPE_CSkillInitCommand"
    self.m_data = _data_model
    print("command Name ::=", self.m_type)
end)


CSkillInitCommand.TYPE = "TYPE_CSkillInitCommand"

function CSkillInitCommand.getType( self)
    return self.m_type
end


--更新数据的command 
CSkillCommand = class( command, function(self, VO_data)
    self.m_type = "TYPE_CSkillCommand"
    self.m_data = VO_data
end)

CSkillCommand.TYPE = "TYPE_CSkillCommand"

function CSkillCommand.getType( self)
    return self.m_type
end

