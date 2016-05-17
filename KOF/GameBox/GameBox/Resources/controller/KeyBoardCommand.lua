require "controller/command"

CKeyBoardCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CKeyBoardCommand"
	self.data = VO_data
end)

CKeyBoardCommand.TYPE = "TYPE_CKeyBoardCommand"


CKeyBoardSkillCDCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CKeyBoardSkillCDCommand"
	self.data = VO_data
end)

CKeyBoardSkillCDCommand.TYPE = "TYPE_CKeyBoardSkillCDCommand"
