require "controller/command"
require "model/VO_LuckyModel"

CTreasureHouseCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CTreasureHouseCommand"
	self.data = VO_data
end)

CTreasureHouseCommand.TYPE = "TYPE_CTreasureHouseCommand"

function CTreasureHouseCommand.getModel(self)
    return self.data
end

function CTreasureHouseCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CTreasureHouseCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CTreasureHouseCommand.getOtheData(self)
	return self.otherData
end
