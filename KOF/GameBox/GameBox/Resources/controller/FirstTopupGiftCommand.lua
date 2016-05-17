require "controller/command"

CFirstTopupGiftCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CFirstTopupGiftCommand"
	self.data = VO_data
end)

CFirstTopupGiftCommand.TYPE = "TYPE_CFirstTopupGiftCommand"

function CFirstTopupGiftCommand.getModel(self)
    return self.data
end

function CFirstTopupGiftCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CFirstTopupGiftCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CFirstTopupGiftCommand.getOtheData(self)
	return self.otherData
end
