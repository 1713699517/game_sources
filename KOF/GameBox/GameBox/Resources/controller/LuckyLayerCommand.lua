require "controller/command"
require "model/VO_LuckyModel"

CLuckyLayerCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CLuckyLayerCommand"
	self.data = VO_data
end)

CLuckyLayerCommand.TYPE = "TYPE_CLuckyLayerCommand"

function CLuckyLayerCommand.getModel(self)
    return self.data
end

function CLuckyLayerCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CLuckyLayerCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CLuckyLayerCommand.getOtheData(self)
	return self.otherData
end
