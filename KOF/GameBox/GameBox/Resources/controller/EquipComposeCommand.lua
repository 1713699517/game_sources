require "controller/command"
require "model/VO_EquipComposeModel"

CEquipComposeCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CEquipComposeCommand"
	self.data = VO_data
    print("VO_data==",VO_data,self.type)
end)

CEquipComposeCommand.TYPE = "TYPE_CEquipComposeCommand"

function CEquipComposeCommand.getModel(self)
    return self.data
end

function CEquipComposeCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CEquipComposeCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CEquipComposeCommand.getOtheData(self)
	return self.otherData
end
