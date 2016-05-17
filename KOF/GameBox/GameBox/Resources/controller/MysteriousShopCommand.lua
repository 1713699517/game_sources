require "controller/command"
require "model/VO_LuckyModel"

CMysteriousShopCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CMysteriousShopCommand"
	self.data = VO_data
end)

CMysteriousShopCommand.TYPE = "TYPE_CMysteriousShopCommand"

function CMysteriousShopCommand.getModel(self)
    return self.data
end

function CMysteriousShopCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CMysteriousShopCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CMysteriousShopCommand.getOtheData(self)
	return self.otherData
end
