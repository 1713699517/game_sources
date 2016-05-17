require "controller/command"

CKeyBoardCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CEquipStrengthenCommand"
	self.data = VO_data
end)

CKeyBoardCommand.TYPE = "TYPE_CEquipStrengthenCommand"
