require "controller/command"
require "model/VO_EquipEnchantModel"

EquipEnchantCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CEquipEnchantCommand"
	self.data = VO_data
	print("VO_data==",VO_data)
end)

EquipEnchantCommand.TYPE = "TYPE_CEquipEnchantSceneCommand"

function EquipEnchantCommand.getModel(self)
	return self.data
end

function EquipEnchantCommand.setType(self,CommandType)
	self.type = CommandType
end

function  EquipEnchantCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function EquipEnchantCommand.getOtheData(self)
	return self.otherData
end