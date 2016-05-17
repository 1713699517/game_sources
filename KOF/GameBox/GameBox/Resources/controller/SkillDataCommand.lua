require "controller/command"

--发送request请求 ...  _G.Protocol["msgId"]
CSkillDataCommand = class(command, function(self, msgId)
	self.type = "TYPE_CSkillDataCommand"
	self.data = msgId
	print(" CSkillDataCommand            -->", self.type)
	--print(" CSkillDataCommand            -->", self.data)
end)

function CSkillDataCommand.setOtherData( self, _data)
    self.otherData = _data
end

function CSkillDataCommand.getOtherData( self )
    return self.otherData
end

function CSkillDataCommand.getData( self )
	return self.data
end


CSkillDataCommand.TYPE = "TYPE_CSkillDataCommand"



----------------------------------------------------
--缓存数据改变由此命令通知需要改变的UI
CSkillDataUpdateCommand = class(command, function(self, msgId)
	self.type = "TYPE_CSkillDataUpdateCommand"
	self.data = msgId
	print(" CSkillDataUpdateCommand           -->", self.type)
	--print(" CSkillDataUpdateCommand           -->", self.data)
end)

function CSkillDataUpdateCommand.setOtherData( self, _data)
    self.otherData = _data
end

function CSkillDataUpdateCommand.getOtherData( self )
    return self.otherData
end

CSkillDataUpdateCommand.TYPE = "TYPE_CSkillDataUpdateCommand"
CSkillDataUpdateCommand.TYPE_UPDATE = "TYPE_UPDATE_CSkillDataUpdateCommand"
CSkillDataUpdateCommand.TYPE_EQUIP  = "TYPE_EQUIP_CSkillDataUpdateCommand"
CSkillDataUpdateCommand.TYPE_PARTNER = "TYPE_PARTNER_CSkillDataUpdateCommand"

function CSkillDataUpdateCommand.getData( self )
	return self.data
end