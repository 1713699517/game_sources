require "controller/command"


CEquipmentManufactureCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CEquipmentManufactureCommand"
	self.data = VO_data
end)

CEquipmentManufactureCommand.TYPE = "TYPE_CEquipmentManufactureCommand"

function CEquipmentManufactureCommand.getModel(self)
    return self.data
end

function CEquipmentManufactureCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CEquipmentManufactureCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CEquipmentManufactureCommand.getOtheData(self)
	return self.otherData
end
